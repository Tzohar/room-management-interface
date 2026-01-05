local RoomInterface = {}
RoomInterface.__index = RoomInterface

local TweenService = game:GetService("TweenService")

local RoomInfoModule = require(script.Parent.RoomInfo)

local GetRemote = game.ReplicatedStorage.Remote.GetRemote

local RoomTemplate = script.RoomTemplate

function RoomInterface.new(parentTo)
	local room = {}
	setmetatable(room, RoomInterface)
	
	room.InterfaceFrame = RoomTemplate:Clone()
	room.InterfaceFrame.Parent = parentTo
	
	return room
end

function RoomInterface:LoadData(Data)
	local frame = self.InterfaceFrame
	local GenresFrame = frame.Genres
	local BackgroundBox = frame.Background
	local Clickable = frame.Clickable
	local RoomImage = frame.ImageLabel
	local PlayersOnlineText = frame.PlayersOnline
	local RoomNameText = frame.RoomName 
	
	local toFill = GenresFrame.RoomGenres1
	local oldText 
	for i,genre in ipairs(Data.Genres) do
		if toFill.TextBounds.X < toFill.AbsoluteSize.X * 0.9 then
			oldText = toFill.Text
			toFill.Text = toFill.Text..", "..genre
		else
			if toFill then
				toFill.Text = oldText
				toFill = (toFill == GenresFrame.RoomGenres1) and GenresFrame.RoomGenres2 or nil
				if toFill then
					toFill.Text = Data.Genres[i - 1]
					toFill.Text = toFill.Text..", "..genre
				end
			else 
				break
			end
		end		
	end
	
	RoomImage.Image = Data.RoomIcon
	RoomNameText.Text = Data.RoomName
	PlayersOnlineText.Text = Data.Players.." Players"

	frame:SetAttribute("CreatorID", Data.CreatorID)
	frame:SetAttribute("RoomID", Data.RoomID)
end

function RoomInterface:LoadFunctions()
	local Frame = self.InterfaceFrame
	local Clickable = Frame.Clickable
	local FrameBackground = Frame.Clickable
	local OriginalSize = FrameBackground.Size

	Clickable.MouseEnter:Connect(function()
		TweenService:Create(
			FrameBackground, 
			TweenInfo.new(0.1),
			{
				BackgroundTransparency = 0, 
				Size = UDim2.new(OriginalSize.X.Scale * 1.1, 0, OriginalSize.Y.Scale * 1.1, 0)
			}	
		):Play()
	end)

	Clickable.MouseLeave:Connect(function()
		TweenService:Create(
			FrameBackground, 
			TweenInfo.new(0.1),
			{
				BackgroundTransparency = 1,
				Size = OriginalSize
			}
		):Play()
	end)

	Clickable.MouseButton1Click:Connect(function()
		local CreatorID = self:GetAttribute("CreatorID")
		local RoomID = self:GetAttribute("RoomID")
		local RoomData = GetRemote:InvokeServer("Rooms", RoomID)
		RoomInfoModule.Load(RoomData)
	end)
end

return RoomInterface
