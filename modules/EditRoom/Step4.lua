local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ModulesFolder = script.Parent.Parent
local PlayerGui = ModulesFolder.Parent
local MainGui = PlayerGui.Main
local CreateRoomGui = MainGui.EditRoom
local StepsGui = CreateRoomGui.Steps

local AlertModule = require(ModulesFolder.AlertModule)

local CurrentStep = StepsGui.Step4.Step4

local MapsFrame = CurrentStep.Maps
local UIPageLayout = MapsFrame.UIPageLayout
local Maps = {}
local focused 
for i,v in pairs(MapsFrame:GetChildren()) do
	if v:IsA("Frame") then
		table.insert(Maps, v) 
	end
end

local ScrollUpFunction 

local function SetFocused()
	focused = Maps[tonumber(UIPageLayout.CurrentPage.Name) + 2] or 
		(Maps[tonumber(UIPageLayout.CurrentPage.Name) + 1] and Maps[1]) or 
		(Maps[tonumber(UIPageLayout.CurrentPage.Name)] and Maps[2])
end

local function DeHightlightCurrent()
	SetFocused()
	TweenService:Create(focused.UIGradient, 
		TweenInfo.new(0.3),
		{Offset = Vector2.new(0, 0.5)}
	):Play()
	focused.Selected:TweenSize(UDim2.new(0, 0, 0, 0), 
		Enum.EasingDirection.Out, 
		Enum.EasingStyle.Quad, 0.3, true)	
end

local function MoveOneRight()
	DeHightlightCurrent()
	UIPageLayout:Next()
	SetFocused()

	TweenService:Create(focused.UIGradient, 	
		TweenInfo.new(0.3),	
		{Offset = Vector2.new(0, 0.3)}	
	):Play()

	focused.Selected:TweenSize(UDim2.new(1, 0, 0.085, 0), 
		Enum.EasingDirection.Out, 	
		Enum.EasingStyle.Quad, 0.3, true)
end

local function MoveOneLeft()
	DeHightlightCurrent()
	UIPageLayout:Previous()
	SetFocused()

	TweenService:Create(focused.UIGradient, 	
		TweenInfo.new(0.3),	
		{Offset = Vector2.new(0, 0.3)}	
	):Play()

	focused.Selected:TweenSize(UDim2.new(1, 0, 0.085, 0), 
		Enum.EasingDirection.Out, 	
		Enum.EasingStyle.Quad, 0.3, true)
end


MapsFrame.MouseEnter:Connect(function()
	ScrollUpFunction = UserInputService.InputChanged:Connect(function(Input, GameProcessedEvent)
		if Input.UserInputType == Enum.UserInputType.MouseWheel then
			if Input.Position.Z > 0 then
				MoveOneLeft()
			elseif Input.Position.Z < 0 then
				MoveOneRight()
			end
		end

	end)
end)

MapsFrame.MouseLeave:Connect(function()
	local result = ScrollUpFunction:Disconnect() or nil
end)

for i,v in pairs(MapsFrame:GetChildren()) do
	SetFocused()
	if v:IsA("Frame") then
		v.ClickAble.MouseButton1Down:Connect(function()
			local CurrentID = tonumber(focused.Name)
			local DesiredID = tonumber(v.Name)

			if CurrentID > DesiredID then
				while focused ~= v do
					MoveOneRight()
					SetFocused()
				end
			elseif CurrentID < DesiredID then
				while focused ~= v do
					MoveOneLeft()
					SetFocused()
				end
			end
		end)
	end
end

UIPageLayout:JumpTo(Maps[1])
MoveOneLeft()


local Step = {}

function Step.FillStep(Info)
	local Map = Maps[Info.RoomID]
	while focused ~= Map do
		MoveOneLeft()
		SetFocused()
	end
end

function Step.ResetStep()
	DeHightlightCurrent()
	UIPageLayout:JumpTo(Maps[1])
	MoveOneLeft()
end

function Step.FetchData()
	local Data = {
		["MapID"] = tonumber(focused.Name)
	}
	return Data
end

return Step
