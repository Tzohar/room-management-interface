local TweenService = game:GetService("TweenService")

local ModulesFolder = script.Parent.Parent
local PlayerGui = ModulesFolder.Parent
local MainGui = PlayerGui.Main
local GenresFolder = ModulesFolder.Genres
local CreateRoomGui = MainGui.EditRoom
local StepsGui = CreateRoomGui.Steps

local AlertModule = require(ModulesFolder.AlertModule)

local CurrentStep = StepsGui.Step2.Step2

local LocalObject_Amount = CurrentStep.Amount
local LocalObject_GenresChosenPlace = CurrentStep.Genres.Frame.Lines.LINE
local LocalObject_Bar = CurrentStep.AvailableGenres.Frame.Bar
local LocalObject_Search = LocalObject_Bar.Search
local LocalObject_SearchBar = LocalObject_Search.TextBox
local LocalObject_GenresPlace = CurrentStep.AvailableGenres.Frame.Lines
local LocalObject_GenreTemplate = LocalObject_GenresPlace.UIListLayout.Genre
local LocalObject_Lines = {LocalObject_GenresPlace.LINE0, LocalObject_GenresPlace.LINE1, LocalObject_GenresPlace.LINE2, LocalObject_GenresPlace.LINE3, 
	LocalObject_GenresPlace.LINE4, LocalObject_GenresPlace.LINE5, LocalObject_GenresPlace.LINE6, LocalObject_GenresPlace.LINE7, LocalObject_GenresPlace.LINE8}

local linesIndex = 1
local selectedGenres = {}
local shownGenres = {}

local function LoadGenresInPlace()
	local TotalLength = 0
	for _, Genre in pairs(GenresFolder:GetChildren()) do
		local GenreObject = LocalObject_GenreTemplate:Clone()
		GenreObject.Text = "     "..Genre.Name.."     "
		GenreObject.BackgroundColor3 = Genre.Value
		GenreObject.Parent = LocalObject_Lines[linesIndex]
		GenreObject.Name = Genre.Name

		TotalLength = TotalLength + string.len(GenreObject.Text) * 0.005 + 0.007

		if TotalLength >= 1 then
			linesIndex += 1
			TotalLength = string.len(GenreObject.Text) * 0.005 + 0.007
			GenreObject.Parent = LocalObject_Lines[linesIndex]
		end			
		print(GenreObject.Parent)
		GenreObject:SetAttribute("Parented", GenreObject.Parent.Name)
	end
end


function Select(genre)
	if #selectedGenres >= 8 then
		AlertModule.Alert2("Too many genres", "You can't pick more than 8 genres.")
		return
	else
		local genreClone = genre:Clone()
		genreClone.Parent = LocalObject_GenresChosenPlace
		selectedGenres[#selectedGenres + 1] = genreClone
		genre:Destroy()

		genreClone.MouseButton1Click:Connect(function()
			table.remove(selectedGenres, table.find(selectedGenres, genreClone))
			UnSelect(genreClone)
		end)
		LocalObject_Amount.Text = #selectedGenres.."/8"
		genreClone.BackgroundTransparency = 0
	end	
end

function UnSelect(genre)
	local genreClone = genre:Clone()	
	print(genre:GetAttribute("Parented"))

	genreClone.Parent = GenresFolder:FindFirstChild(genre:GetAttribute("Parented"))
	genre:Destroy()

	genreClone.MouseButton1Click:Connect(function()
		Select(genreClone)
	end)
	LocalObject_Amount.Text = #selectedGenres.."/8"
	genreClone.BackgroundTransparency = 0
end

local function SearchOff()
	for i,v in pairs(LocalObject_GenresPlace:GetDescendants()) do
		if v:GetAttribute("IsGenre") then
			table.remove(shownGenres, i)
			v.BackgroundTransparency = 0
		end
	end	
end

local function Search(text)
	SearchOff()
	for _, Genre in pairs(LocalObject_GenresPlace:GetDescendants()) do
		if Genre:GetAttribute("IsGenre") then
			if string.find(string.lower(Genre.Name), text) then
				table.insert(shownGenres, Genre)
				Genre.BackgroundTransparency = 0
			else
				Genre.BackgroundTransparency = 0.9
			end
		end
	end	
end

function SearchBarOnChange()
	local text = LocalObject_SearchBar.Text
	if #text == 0 then
		SearchOff()
	else
		Search(string.lower(text))
	end
end

LoadGenresInPlace()

LocalObject_SearchBar.Changed:Connect(SearchBarOnChange)
for _, Genre in pairs(LocalObject_GenresPlace:GetDescendants()) do
	if Genre:GetAttribute("IsGenre") then
		Genre.MouseButton1Click:Connect(function()
			Select(Genre)
		end)
	end	
end



local Step = {}

function Step.FillStep(Info)
	for i,v in ipairs(Info.Genres) do
		for i,e in pairs(LocalObject_GenresPlace:GetDescendants()) do
			if v == e.Name then
				print("Gotcha")
				Select(e)
			end
		end
	end
end

function Step.ResetStep()
	for _,Genre in ipairs(selectedGenres) do
		UnSelect(Genre)
	end
	SearchOff()
	LocalObject_SearchBar.Text = ""
	selectedGenres = {}
end

function Step.FetchData()
	local Genres = {}
	for i,v in ipairs(selectedGenres) do
		Genres[#Genres + 1] = v.Name
	end
	
	local Data = {
		["Genres"] = Genres
	}
	return Data
end

return Step
