local RS = game:GetService("ReplicatedStorage")

local Modules = script.Parent
local Remote = RS.Remote

local RoomClassModule = require(Modules.RoomClass)
local UserDataModule = require(Modules.UserData)

local CreateRoomFunction = Remote.CreateRoom

local ActiveRooms = {}

CreateRoomFunction.OnServerInvoke = function(Player, OldData)
	local Data = RoomClassModule.new(Player.UserId, OldData)
	Data:GenerateID()
	print(Data)
	UserDataModule.Set(Player, Data, "Rooms", tostring(Data.RoomID))
	
	return Data
end

game.Players.PlayerAdded:Connect(function(Player)
	local Rooms = UserDataModule.Get(Player,"Rooms")
end)

game.Players.PlayerRemoving:Connect(function(Player)
	
end)



