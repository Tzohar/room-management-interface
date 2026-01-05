local module = {}

local TweenService = game:GetService("TweenService")
local StarterGui = script.Parent.Parent
local AlertGui = StarterGui:WaitForChild("Alert").Frame
local GUI = StarterGui.Alert

local Alert1 = AlertGui.UIListLayout.Alert1
local Alert2 = AlertGui.UIListLayout.Alert2
local Alert3 = AlertGui.UIListLayout.Alert3

local ActiveAlerts = {}

local OriginalSize = Alert1.Size
local StartingSize = UDim2.new(OriginalSize.X.Scale * 0.6, 0, OriginalSize.Y.Scale * 0.6, 0)

local Duration = 0.2
local Info = TweenInfo.new(Duration)

function FadeIn(AC)
	AC.BackgroundTransparency = 1
	AC.Frame.BackgroundTransparency = 1
	AC.CloseButton.TextTransparency = 1
	AC.Icon.ImageTransparency = 1
	AC.Title.TextTransparency = 1
	AC.Description.TextTransparency = 1
	
	AC.Parent = AlertGui
	
	TweenService:Create(AC, Info, {BackgroundTransparency = 0}):Play()
	TweenService:Create(AC.Frame, Info, {BackgroundTransparency = 0}):Play()
	TweenService:Create(AC.CloseButton, Info, {TextTransparency = 0}):Play()
	TweenService:Create(AC.Icon, Info, {ImageTransparency = 0}):Play()
	TweenService:Create(AC.Title, Info, {TextTransparency = 0}):Play()
	TweenService:Create(AC.Description, Info, {TextTransparency = 0}):Play()
	
	AC.Size = StartingSize
	AC:TweenSize(OriginalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5)
	
end

function FadeOut(AC)
	TweenService:Create(AC, Info, {BackgroundTransparency = 1}):Play()
	TweenService:Create(AC.Frame, Info, {BackgroundTransparency = 1}):Play()
	TweenService:Create(AC.CloseButton, Info, {TextTransparency = 1}):Play()
	TweenService:Create(AC.Icon, Info, {ImageTransparency = 1}):Play()
	TweenService:Create(AC.Title, Info, {TextTransparency = 1}):Play()
	TweenService:Create(AC.Description, Info, {TextTransparency = 1}):Play()
	
	wait(Duration)
	AC:Destroy()
end

function Timeout(AC, Seconds)
	coroutine.resume(coroutine.create(function()
		wait(Seconds)
		if AC and AC:FindFirstChild("Frame") then
			FadeOut(AC)
		end
	end))
end

function Setup(Alert, Title, Description)
	Alert.Title.Text = Title
	Alert.Description.Text = Description
	ActiveAlerts[#ActiveAlerts + 1] = Alert
	FadeIn(Alert)
	Timeout(Alert, 15)
	
	Alert.CloseButton.MouseButton1Click:Connect(function()
		FadeOut(Alert)
	end)
	Alert.MouseButton1Click:Connect(function()
		FadeOut(Alert)
	end)
	Alert.MouseEnter:Connect(function()
		Alert.BackgroundColor3 = Color3.fromRGB(243, 243, 243)
	end)
	Alert.MouseLeave:Connect(function()
		Alert.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

function module.Alert1(Title, Description)
	local AC = Alert1:Clone()
	Setup(AC, Title, Description)
end

function module.Alert2(Title, Description)
	local AC = Alert2:Clone()
	Setup(AC, Title, Description)
end

function module.Alert3(Title, Description)
	local AC = Alert3:Clone()
	Setup(AC, Title, Description)
end


return module
