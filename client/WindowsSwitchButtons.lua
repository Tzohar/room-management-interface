local StarterGui = script.Parent.Parent
local TweenService = game:GetService("TweenService")

local Modules = StarterGui:WaitForChild("Modules")
local SwitchModule = require(Modules.WindowsManager)

local Menu = script.Parent.Parent.LeftListMenu.Menu
local ButtonsFrame = Menu["1Buttons"]

local HomeButton = ButtonsFrame["0Home"]
local DiscoverButton = ButtonsFrame["1Discover"]
local Buttons = {HomeButton, DiscoverButton}

local Active = HomeButton
local ActiveColor = Color3.fromRGB(255, 255, 255)
local InactiveColor = Color3.fromRGB(180, 180, 180)

function Enable(Button)
	Button.ImageLabel.ImageColor3 = ActiveColor
	Button.TextLabel.TextColor3 = ActiveColor
	Button.BackgroundTransparency = 0.8
	TweenService:Create(Button.Frame, TweenInfo.new(0.35), 
		{BackgroundTransparency = 0}):Play()
	
	if Button == HomeButton then
		print("HOHOMO")
		SwitchModule.FetchWindow("Home"):Open()
	end
	if Button == DiscoverButton then
		SwitchModule.FetchWindow("Discover"):Open()
	end
end

function Disable(Button)
	Button.ImageLabel.ImageColor3 = InactiveColor
	Button.TextLabel.TextColor3 = InactiveColor
	Button.BackgroundTransparency = 1
	TweenService:Create(Button.Frame, TweenInfo.new(0.35), 
		{BackgroundTransparency = 1}):Play()
end

function Hover(Button)
	Button.ImageLabel.ImageColor3 = ActiveColor
	Button.TextLabel.TextColor3 = ActiveColor

end

function UnHover(Button)
	Button.ImageLabel.ImageColor3 = InactiveColor
	Button.TextLabel.TextColor3 = InactiveColor
end



for i,v in pairs(Buttons) do
	v.MouseEnter:Connect(function()
		Hover(v)
		print("Hovered")
	end)
	
	v.MouseLeave:Connect(function()
		if Active ~= v then
			UnHover(v)
		end
	end)
	
	v.MouseButton1Click:Connect(function()
		if IsCreatingRoom() then
			return
		end
		Disable(Active)
		Active = v
		Enable(Active)
	end)
end

for i,v in pairs(Buttons) do
	UnHover(v)
end
Enable(HomeButton)

--Specific settings:
local Windows = {
	StarterGui.Main["CreateRoom"],
	StarterGui.Main["EditRoom"],
	StarterGui.Main["Info"]
}
--[

for i,v in pairs(Windows) do 
	v:GetPropertyChangedSignal("Visible"):Connect(function()
		if not v.Visible then
			local allClosed = true
			for i,v in pairs(Windows) do
				if v.Visible then
					allClosed = false
				end
			end
			
			if allClosed then
				Disable(Active)
				Active = HomeButton
				Active.ImageLabel.ImageColor3 = ActiveColor
				Active.TextLabel.TextColor3 = ActiveColor
				Active.BackgroundTransparency = 0.8
				TweenService:Create(Active.Frame, TweenInfo.new(0.35), 
					{BackgroundTransparency = 0}):Play()		
			end
		end
	end)
end
--

--Specific restrictions:
function IsCreatingRoom()
	if StarterGui.Main["CreateRoom"].Visible == true then
		return true
	end
	return false
end
