local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local ModulesFolder = script.Parent.Parent
local PlayerGui = ModulesFolder.Parent
local MainGui = PlayerGui.Main
local CreateRoomGui = MainGui.EditRoom
local StepsGui = CreateRoomGui.Steps

local CurrentStep = StepsGui.Step1.Step1

local LocalObject_RoomName = CurrentStep.RoomName.InputBox
local LocalObject_RoomDescription = CurrentStep.RoomDescription.InputBox
local LocalObject_RoomIcon = CurrentStep.RoomIcon.InputBox
local LocalObject_Preview = CurrentStep.Preview
local LocalObject_RoomIconImages = CurrentStep.Images

local chosenImage = nil
local validIcon = false

local function CheckForErrors()
	if not string.match(LocalObject_RoomName.Text, ".") then
		return {"Room name must include at least one valid character.", 1}
	end
	if not string.match(LocalObject_RoomDescription.Text, ".") then
		return {"Room description must include at least one valid character.", 1}
	end
	if not validIcon then
		return {"Room icon ID is invalid.", 1}
	end
	if LocalObject_RoomName.TextColor3 == Color3.fromRGB(255, 0, 0) then
		return {"Room name is longer than allowed.", 1}
	end
	if LocalObject_RoomDescription.TextColor3 == Color3.fromRGB(255, 0, 0) then
		return {"Room description is longer than allowed.", 1}
	end
end

local function CheckMax(Object, MaxObject, MaxNumber)
	local text = Object.Text
	if #text > MaxNumber then
		MaxObject.Text = tostring(#text - MaxNumber)
		Object.TextColor3 = Color3.fromRGB(255, 0, 0)
	else
		MaxObject.Text = ""
		Object.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
end

local function ToggleImageSelect(Image)
	if chosenImage then
		chosenImage.Cover.ImageColor3 = Color3.fromRGB(0, 0, 0)	
	end
	Image.Cover.ImageColor3 = Color3.fromRGB(0, 200, 0)
	chosenImage = Image
	
	LocalObject_RoomIcon.Text = string.gsub(chosenImage.Image, "%D", "")
	LocalObject_RoomIcon.CoverOpt.Visible = true
end

local function LoadImageEvents(Image)
	Image.MouseEnter:Connect(function()
		TweenService:Create(Image, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(83, 83, 83)}):Play()
	end)
	Image.MouseLeave:Connect(function()
		TweenService:Create(Image, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
end

local function LoadImageToPreview()
	print("Testing...")
	local ID = "rbxassetid://"..string.gsub(LocalObject_RoomIcon.Text, "%D", "")
	print(ID)
	ContentProvider:PreloadAsync({ID}, function(ContentID, Status)
		validIcon = false
		if Status == Enum.AssetFetchStatus.Success then
			LocalObject_Preview.Visible = true
			LocalObject_Preview.Image = ID
			validIcon = true
		elseif LocalObject_Preview.Visible then
			LocalObject_Preview.Visible = false
			LocalObject_Preview.Image = ""
		end
	end)
end

local function RoomIconFocus()
	if chosenImage then
		chosenImage.Cover.ImageColor3 = Color3.fromRGB(0, 0, 0)	
		LocalObject_RoomIcon.CoverOpt.Visible = false
		chosenImage = nil
	end
end



LocalObject_RoomName.Changed:Connect(function()
	CheckMax(LocalObject_RoomName, LocalObject_RoomName.Max, 30)
end)
LocalObject_RoomDescription.Changed:Connect(function() 
	CheckMax(LocalObject_RoomDescription, LocalObject_RoomDescription.Max, 500) 	
end)

for _,IMG in pairs(LocalObject_RoomIconImages:GetChildren()) do
	if IMG:IsA("ImageButton") then
		LoadImageEvents(IMG)
		IMG.MouseButton1Click:Connect(function()
			ToggleImageSelect(IMG)
		end)
	end
end

LocalObject_RoomIcon:GetPropertyChangedSignal("Text"):Connect(LoadImageToPreview)
LocalObject_RoomIcon.Focused:Connect(RoomIconFocus)



local Step = {}

function Step.FillStep(Info)
	LocalObject_RoomName.Text = Info.RoomName
	LocalObject_RoomDescription.Text = Info.RoomDescription
	LocalObject_RoomIcon.Text = Info.RoomIcon
	validIcon = true
	
	LocalObject_RoomIcon.CoverOpt.Visible = false
end

function Step.ResetStep()
	LocalObject_RoomName.Text = ""
	LocalObject_RoomDescription.Text = ""
	LocalObject_RoomIcon.Text = ""
	validIcon = false
	
	if chosenImage then
		chosenImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
		chosenImage.Cover.ImageColor3 = Color3.fromRGB(0, 0, 0)	
		chosenImage = nil
	end
	LocalObject_RoomIcon.CoverOpt.Visible = false
end

function Step.FetchData()
	local Data = {
		["RoomName"] = LocalObject_RoomName.Text,
		["RoomDescription"] = LocalObject_RoomDescription.Text,
		["RoomIcon"] = "rbxassetid://"..string.gsub(LocalObject_RoomIcon.Text, "%D", ""),
		["ERROR"] = CheckForErrors()
	}
	return Data
end

return Step
