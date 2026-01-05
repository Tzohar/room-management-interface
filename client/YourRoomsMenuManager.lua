local TweenService = game:GetService("TweenService")

local StarterGui = script.Parent.Parent
local RoomCreateModule = require(StarterGui.Modules.CreateRoom)
local RoomInfoModule = require(StarterGui.Modules.RoomInfo) 
local AlertModule = require(StarterGui.Modules.AlertModule)

local CreateRoomFunction = game.ReplicatedStorage.Remote.CreateRoom

local StatusOnID = "rbxassetid://7072725070"
local StatusOffID = "rbxassetid://7072725070"

local Menu = script.Parent.Parent.LeftListMenu.Menu
local RoomsMenu = Menu["2YourRooms"]
local Rooms = {
	RoomsMenu.Rooms["1Slot"],
	RoomsMenu.Rooms["2Slot"],
	RoomsMenu.Rooms["3Slot"],
	RoomsMenu.Rooms["4Slot"]
}


local PlayerRooms = game.ReplicatedStorage.Remote.GetRemote:InvokeServer("Rooms") or {}
print(PlayerRooms)

local function Used(ID, Information)
	local Room = Rooms[ID]
	Room:FindFirstChild("RoomTitle").Text = Information.RoomName
	Rooms[ID].UnclaimedOverlay.Visible = false
	
	Room.Clickable.MouseEnter:Connect(function()
		Room.PlayButton.ImageColor3 = Color3.fromRGB(123, 255, 75)
	end)
	Room.Clickable.MouseLeave:Connect(function()
		Room.PlayButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	end)
	local newFunc = Room.Clickable.MouseButton1Click:Connect(function()
		local GetRemote = game.ReplicatedStorage.Remote.GetRemote:InvokeServer("Rooms", tostring(ID))
		RoomInfoModule.Load(GetRemote, Room:GetAttribute('RoomValue'))
	end)
end

local function UnUsed(ID, Data)
	local Room = Rooms[ID]
	Room.UnclaimedOverlay.Visible = true 
	Room.StatusFrame.Status.Image = StatusOffID
	Room.StatusFrame.Status.ImageColor3 = Color3.fromRGB(255, 0, 0)
end

local function PassRoomData(ID, Data)
	
end

---------------------------------
local IsOpen = false

if PlayerRooms then
	for i = 1, 4 do
		local RoomData = PlayerRooms[tostring(i)]
		local RoomObject = Rooms[i]
		
		if RoomData then
			Used(i, RoomData)
		else
			UnUsed(i)
			local func 
			func = RoomObject.Clickable.MouseButton1Click:Connect(function()
				if IsOpen then
					AlertModule.Alert1("Room Creation", "You're already creating a room")
					return
				end
				IsOpen = true
				
				local OldData = RoomCreateModule.EnterRoomCreation()
				IsOpen = false
				print(OldData)
				if OldData == "QUIT" then
					return
				end
				
				print(OldData)
				
				OldData.RoomID = RoomObject:GetAttribute('RoomValue')
				
				local Data = CreateRoomFunction:InvokeServer(OldData)
				print(Data)
				Used(i, Data)
				PassRoomData(i, Data)
				
				func:Disconnect()
			end)
		end
	end
end
