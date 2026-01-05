local TweenService = game:GetService("TweenService")
local RoomInfo = nil
local StarterGui = script.Parent.Parent
local Main = script.Parent.Parent.Main
local Info = Main.Info

local WindowsManagerModule = require(script.Parent.Parent.Modules.WindowsManager)
local EditRoomModule = require(script.Parent.EditRoom)

local RoomInfoWindow = WindowsManagerModule.FetchWindow("Info")
local LowerBar, UpperBar = Info.LowerBar, Info.UpperBar

local CreateRoomFunction = game.ReplicatedStorage.Remote.CreateRoom
local SendUserToServerFunction = game.ReplicatedStorage.Remote.SendUserToServer

local OCreationDate = LowerBar.CreationDate
local OFavorites = LowerBar.Favorites
local OInQueue = LowerBar.InQueue
local OMaxPlayers = LowerBar.MaxPlayers
local OPlaying = LowerBar.Playing
local OVisits = LowerBar.Visits
local OHostedBy = UpperBar.HostedBy
local OGenres = UpperBar.Genres
local OTitle = UpperBar.Title
local ODescription = UpperBar.Description
local ORoomIcon = UpperBar.RoomIcon

local StarButton = UpperBar.StarButton
local PlayButton = UpperBar.PlayButton
local SettingsButton = UpperBar.SettingsButton

local Data 
local RoomGlobalID  

local CloseButton = Info.CloseButton
local CBSize = CloseButton.Size
local CBColor = CloseButton.ImageColor3
	
CloseButton.Activated:Connect(function()
	RoomInfo.Leave()
end)
CloseButton.MouseEnter:Connect(function()
	CloseButton.ImageColor3 = Color3.fromRGB(170, 170, 170)
	CloseButton:TweenSize(UDim2.new(CBSize.X.Scale * 1.2, 0,CBSize.Y.Scale * 1.2, 0), 
			Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint, 0.2)
end)
CloseButton.MouseLeave:Connect(function()
	CloseButton.ImageColor3 = CBColor
	CloseButton:TweenSize(CBSize, 
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint, 0.2)
end)


local SBSize = SettingsButton.Size

SettingsButton.MouseEnter:Connect(function()
	SettingsButton:TweenSize(UDim2.new(SBSize.X.Scale * 1.2, 0,SBSize.Y.Scale * 1.2, 0), 
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint, 0.2)
end)
SettingsButton.MouseLeave:Connect(function()
	SettingsButton:TweenSize(SBSize, 
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint, 0.2)
end)

function OnSettingsClick(RoomInfo)
	print(RoomInfo)
	local Data = EditRoomModule.EnterRoomCreation(RoomInfo)
	if Data ~= "QUIT" then
		Data.RoomID = RoomGlobalID
		CreateRoomFunction:InvokeServer(Data)
	else
		RoomInfo:UpdateRoomEditing(Data)
		print(RoomInfo)
	end
end
SettingsButton.Clickable.MouseButton1Click:Connect(function()
	OnSettingsClick(Data)
end)

UpperBar.PlayButton.MouseButton1Click:Connect(function()
	SendUserToServerFunction:InvokeServer(Data.AccessCode)
end)


RoomInfo = {}

function RoomInfo.Leave()
	SettingsButton.Visible = false
	WindowsManagerModule.FetchWindow("Home"):Open()
end

function RoomInfo.Load(RoomInfo, RoomID)
	print(RoomInfo)
	Info.OVERLAY.BackgroundTransparency = 0
	TweenService:Create(
		Info.OVERLAY,
		TweenInfo.new(0.2),
		{BackgroundTransparency = 1}):Play()
	Data = RoomInfo
	
	if RoomID then
		RoomGlobalID = RoomID
	end
	
	OCreationDate.TextLabel.Text = RoomInfo.CreationDate
	OFavorites.TextLabel.Text = RoomInfo.Favorites	
	OInQueue.TextLabel.Text = RoomInfo.InQueue
	OMaxPlayers.TextLabel.Text = RoomInfo.MaxPlayers
	OPlaying.TextLabel.Text = RoomInfo.Players
	OVisits.TextLabel.Text = RoomInfo.Visits
	OHostedBy.Text = ("Hosted by "..game.Players:GetNameFromUserIdAsync(RoomInfo.CreatorID)) or "null"
	OGenres.TextLabel.Text = table.concat(RoomInfo.Genres, ", ")
	OTitle.Text = RoomInfo.RoomName
	ODescription.TextLabel.Text = RoomInfo.RoomDescription
	ORoomIcon.Image = RoomInfo.RoomIcon
	
	RoomInfoWindow:Open("Slide")
	
	if game.Players.LocalPlayer.UserId == RoomInfo.CreatorID then
		SettingsButton.Visible = true	
	end
	return 
end

return RoomInfo
