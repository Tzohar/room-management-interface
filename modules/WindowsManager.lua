local PlayerGui = game.Players.LocalPlayer.PlayerGui
local Main = PlayerGui.Main

local Windows = {}
local CurrentlyOpen = Main["Home"]
local Opening = false
Windows.__index = Windows

function Windows:Open(Effect)			
	local Window = self.SelectedWindow
	print("Gothca")
	
	if not Effect then
		Window.Visible = true
		if CurrentlyOpen ~= Window then
			Window.Position = UDim2.new(0.15, 0, 0.074, 0)
			CurrentlyOpen.Visible = false 
			CurrentlyOpen = Window
			print("Change done")
		end
	elseif Effect == "Slide" then
		if CurrentlyOpen ~= Window and not Opening then
			Opening = true
			
			Window.Position = UDim2.new(0.15, 0, -0.85, 0)
			Window.Visible = true
			print(CurrentlyOpen)
			print(Window)
			Window:TweenPosition(UDim2.new(0.15, 0, 0.074, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.8)
			CurrentlyOpen:TweenPosition(UDim2.new(0.15, 0, 0.998, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.8)
			wait(0.8)
			CurrentlyOpen.Visible = false 
			CurrentlyOpen = Window
			print(CurrentlyOpen)
			
			Opening = false
		end
	end
end

local module = {}

function module.FetchWindow(WindowName)
	local window = {}
	setmetatable(window, Windows)
	
	window.SelectedWindow = Main:FindFirstChild(WindowName)
	
	return window
end

return module
