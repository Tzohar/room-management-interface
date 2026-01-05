local TweenService = game:GetService("TweenService")

local ModulesFolder = script.Parent.Parent
local PlayerGui = ModulesFolder.Parent
local MainGui = PlayerGui.Main
local CreateRoomGui = MainGui.CreateRoom
local StepsGui = CreateRoomGui.Steps

local AlertModule = require(ModulesFolder.AlertModule)

local CurrentStep = StepsGui.Step3.Step3

local LocalObject_Types1 = CurrentStep.Types1
local LocalObject_Types2 = CurrentStep.Types2
local LocalObject_RoomType1 = LocalObject_Types1.Type1
local LocalObject_RoomType2 = LocalObject_Types1.Type2
local LocalObject_RoomType3 = LocalObject_Types2.Type3
local LocalObject_RoomType4 = LocalObject_Types2.Type4
local LocalObject_RoomTypes = {
	LocalObject_RoomType1, 
	LocalObject_RoomType2, 
	LocalObject_RoomType3, 
	--LocalObject_RoomType4
}

local CurrentlyActive = LocalObject_RoomType1

local function LoadHoverEffect()
	for _,Type in pairs(LocalObject_RoomTypes) do
		Type.MouseEnter:Connect(function()
			TweenService:Create(Type, 
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(49, 49, 49)}
			):Play()
		end)
		Type.MouseLeave:Connect(function()
			TweenService:Create(Type, 
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(34, 34, 34)}
			):Play()
		end)
	end
end

local function OnClick(Type)
	if Type == CurrentlyActive then
		return
	end
	TweenService:Create(Type.UIStroke,
		TweenInfo.new(0.2),
		{Thickness = 3}
	):Play()
	TweenService:Create(CurrentlyActive.UIStroke,
		TweenInfo.new(0.2),
		{Thickness = 0}
	):Play()
	
	CurrentlyActive = Type
end

local function LoadClickEffects()
	for _,Type in pairs(LocalObject_RoomTypes) do
		Type.MouseButton1Click:Connect(function()
			OnClick(Type)
		end)
	end
end

LoadHoverEffect()
LoadClickEffects()
TweenService:Create(CurrentlyActive.UIStroke,
	TweenInfo.new(0.2),
	{Thickness = 3}
):Play()


local Step = {}

function Step.ResetStep()
	OnClick(LocalObject_RoomType1)
end

function Step.FetchData()
	local TypeID = table.find(LocalObject_RoomTypes, CurrentlyActive)
	local Data = {SettingsLayoutID = TypeID}
	return Data
end

return Step
