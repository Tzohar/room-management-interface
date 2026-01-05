local TweenService = game:GetService("TweenService")

local AlertModule = require(script.Parent.Parent.Modules.AlertModule)
local WindowsManagerModule = require(script.Parent.Parent.Modules.WindowsManager)
local StepsModules = {
	require(script.Step1),
	require(script.Step2),
	require(script.Step3),
	require(script.Step4)
}

local CreationGui = script.Parent.Parent.Main.CreateRoom
local StepsGui = CreationGui.Steps
local StepsSwitch = CreationGui.StepsSwitch
local CloseButton = CreationGui.CloseButton
local PageLayout = StepsGui.UIPageLayout 

local StepsGuiObjects = {
	StepsGui.Step1.Step1,
	StepsGui.Step2.Step2,
	StepsGui.Step3.Step3,
	StepsGui.Step4.Step4
}
local ButtonSteps = {
	StepsSwitch.Steps.Step1Bu,
	StepsSwitch.Steps.Step2Bu,
	StepsSwitch.Steps.Step3Bu,
	StepsSwitch.Steps.Step4Bu
}
local ConnectingStepFrames = {
	nil,
	StepsSwitch.Steps.Step2Frame,
	StepsSwitch.Steps.Step3Frame,
	StepsSwitch.Steps.Step4Frame
}
local RightButton = ButtonSteps[4].RightButton
local LeftButton = ButtonSteps[1].LeftButton
local CreateButton = StepsSwitch.CreateButton

local currentStep = 1
local information = {}
local clicked = false
local activatedColor = Color3.fromRGB(255, 255, 255)
local unactivatedColor = Color3.fromRGB(79, 79, 79)
local rightButtonSize = RightButton.Size
local leftButtonSize = LeftButton.Size
local originalSize = UDim2.new(0.2, 0, 0.8, 0)

local function ClearSteps()
	print("ClearSteps")
	for _,StepModule in pairs(StepsModules) do
		StepModule.ResetStep()
	end
end

local function ArrowButtonsMouseHover(Button, DefaultSize)
	print("ArrowsButtonMouseHover")
	if Button:GetAttribute("CurrentlyResizedForHover") then
		Button:SetAttribute("CurrentlyResizedForHover", false)
		Button:TweenSize(
			DefaultSize,
			Enum.EasingDirection.Out, 
			Enum.EasingStyle.Quint, 
			0.2)
	else
		Button:SetAttribute("CurrentlyResizedForHover", true)
		Button:TweenSize(
			UDim2.new(DefaultSize.X.Scale * 1.2, 0,
				DefaultSize.Y.Scale * 1.2, 0), 
			Enum.EasingDirection.Out, 
			Enum.EasingStyle.Quint, 
			0.2)
	end
end

local function OnRightArrowButtonClick()
	print("OnRightClickButton")
	local newStepNum = currentStep + 1
	if newStepNum <= 4 then
		LaunchStep(newStepNum)
		if newStepNum == 4 then
			RightButton.ImageColor3 = Color3.fromRGB(135, 135, 135)
		end
	end
end

local function OnLeftArrowButtonClick()
	print("OnLeftClickButton")
	local newStepNum = currentStep - 1
	if newStepNum >= 1 then
		LaunchStep(newStepNum)
		if newStepNum == 1 then
			LeftButton.ImageColor3 = Color3.fromRGB(135, 135, 135)
		end
	end
end

local function ArrowButtonsChangeColor()
	print("ArrowsChangeColor")
	local x = 0
	LeftButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	RightButton.ImageColor3 = Color3.fromRGB(255, 255, 255)

	if currentStep == 4 then
		RightButton.ImageColor3 = Color3.fromRGB(135, 135, 135)
	elseif currentStep == 1 then
		LeftButton.ImageColor3 = Color3.fromRGB(135, 135, 135)
	end	

	for ButtonNumber,ButtonStep in pairs(ButtonSteps) do
		x += 1
		
		if x > currentStep	 then
			ButtonStep.BackgroundColor3 = unactivatedColor
			
			if ConnectingStepFrames[ButtonNumber] then
				ConnectingStepFrames[ButtonNumber].BackgroundColor3 = unactivatedColor
			end
		else
			ButtonStep.BackgroundColor3 = activatedColor

			if ConnectingStepFrames[ButtonNumber] then
				ConnectingStepFrames[ButtonNumber].BackgroundColor3 = activatedColor
			end
		end

		if x == currentStep then
			ButtonSteps[ButtonNumber].TextLabel.TextColor3 = activatedColor
			ButtonSteps[ButtonNumber]:TweenSize(
				UDim2.new(originalSize.X.Scale * 1.2, 0, originalSize.Y.Scale * 1.2, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quint,
				0.5,
				true)

		else
			ButtonSteps[ButtonNumber].TextLabel.TextColor3 = unactivatedColor
			ButtonSteps[ButtonNumber]:TweenSize(
				UDim2.new(originalSize.X.Scale, 0, originalSize.Y.Scale, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Quint, 
				0.5, 
				true)

		end
	end
end

local function OverlayUp(Overlay)
	print("OverlayUp")
	TweenService:Create(
		Overlay,
		TweenInfo.new(0.2), 
		{BackgroundTransparency = 0}
	):Play()
end

local function OverlayDown(Overlay)
	print("OverlayDown")
	TweenService:Create(
		Overlay,
		TweenInfo.new(0.2), 
		{BackgroundTransparency = 1}
	):Play()
end

function LaunchStep(stepNum, bypass)
	print("LaunchStep")
	local stepGui = StepsGuiObjects[stepNum]
	currentStep = stepNum
	if bypass then
		PageLayout.Animated = false
		OverlayUp(stepGui.OVERLAY)
		OverlayDown(stepGui.OVERLAY)

		PageLayout:JumpTo(stepGui.Parent)
		ArrowButtonsChangeColor()
		PageLayout.Animated = true
	else
		OverlayUp(stepGui.OVERLAY)
		wait(0.1)
		OverlayDown(stepGui.OVERLAY)

		PageLayout:JumpTo(stepGui.Parent)
		ArrowButtonsChangeColor()
	end
end

local function LoadButtonClicks()
	print("LoadButtonsClick")
	for StepNum, Button in pairs(ButtonSteps) do
		Button.MouseButton1Click:Connect(function()
			LaunchStep(StepNum)
		end)
	end
end

local function LoadCloseButtonSetup()
	print("LoadCloseButtons")
	local CBSize = CloseButton.Size
	local CBColor = CloseButton.ImageColor3
	
	CloseButton.Activated:Connect(function()
		clicked = "QUIT"
		module.LeaveRoomCreation()
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
end

local function GatherStepsData()
	print("GatherStepsData")
	local StepsData = {}
	for _, Module in ipairs(StepsModules) do
		table.insert(StepsData, Module.FetchData())
	end
	return StepsData
end

local function LookForErrors(Data)
	print("LookForErrors")
	for i,v in pairs(Data) do
		if v.ERROR then
			return v.ERROR
		end 
	end
end

local function FormDataInformation(StepsData)
	print("FormData")
	for _, Data in pairs(StepsData) do
		for Name, Data in pairs(Data) do
			information[Name] = Data
		end
	end
end

local function OnCreateButtonClick()
	print("OnCreateButtonClick")
	local StepsData = GatherStepsData()
	local Errors = LookForErrors(StepsData) 	

	if Errors then
		print(Errors)
		local ErrorContent = Errors[1]
		local StepNum = Errors[2]
		AlertModule.Alert1("Error while creating room (Step "..StepNum..")", ErrorContent)
		LaunchStep(StepNum)
		return
	end
	FormDataInformation(StepsData)
	
	clicked = true
	module.LeaveRoomCreation()
end

local function LoadUI()
	CreateButton.MouseButton1Click:Connect(OnCreateButtonClick)
	LeftButton.MouseButton1Click:Connect(OnLeftArrowButtonClick)	
	RightButton.MouseButton1Click:Connect(OnRightArrowButtonClick)
	
	LeftButton.MouseEnter:Connect(function()
		ArrowButtonsMouseHover(LeftButton, leftButtonSize)
	end)
	LeftButton.MouseLeave:Connect(function()
		ArrowButtonsMouseHover(LeftButton, leftButtonSize)
	end)
	RightButton.MouseEnter:Connect(function()
		ArrowButtonsMouseHover(RightButton, rightButtonSize)
	end)
	RightButton.MouseLeave:Connect(function()
		ArrowButtonsMouseHover(RightButton, rightButtonSize)
	end)
end

LoadButtonClicks()
LoadCloseButtonSetup()
LoadUI()



module = {}

function module.EnterRoomCreation(Info)
	clicked = false
	print("Started")
	information = {}
	LaunchStep(1, true)
	WindowsManagerModule.FetchWindow("CreateRoom"):Open("Slide")

	repeat wait(0.1) until clicked or CreationGui.Visible == false 
	if clicked == "QUIT" and CreationGui.Visible == false then
		clicked = ""
		return("QUIT")
	else
		return(information)
	end
end

function module.LeaveRoomCreation()
	WindowsManagerModule.FetchWindow("Home"):Open()
	ClearSteps()
end

return module