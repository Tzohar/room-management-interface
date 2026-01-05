local Room = {}
Room.__index = Room

function Room.new(CREATORID, DATA)
	print(DATA)
	local Object = {
		CreatorID = 0,
		RoomID = 0,
		RoomName = "NULL",
		RoomDescription = "NULL",
		RoomIcon = "",
		Players = 0,
		Favorites = 0,
		MaxPlayers = 100,
		Visits = 0,
		InQueue = 0,
		CreationDate = "00/00/0000",
		AccessCode = "",
		Genres = {},
		Map = 0,
		SettingsLayoutID = 0,
		Status = "PUBLIC",
		Permissions = {
			["Players"] = {"VOTE_SKIP", "VOTE_KICK", "QUEUE_SONGS"},
			["Staff"] = {"VOTE_SKIP", "VOTE_KICK", "QUEUE_SONGS", "FORCE_SKIP", "FORCE_KICK"}
		}
	}
	
	setmetatable(Object, Room)
	Object.CreatorID = CREATORID
	Object.RoomID = DATA.RoomID
	Object.RoomName = DATA.RoomName
	Object.RoomDescription = DATA.RoomDescription
	Object.RoomIcon = DATA.RoomIcon
	Object.Favorites = DATA.Favorites or 0
	Object.Map = DATA.MapID or 0	
	Object.CreationDate = os.date("%d/%m/%Y")
	Object.Genres = DATA.Genres
	Object.SettingsLayoutID = DATA.SettingsLayoutID
	
	Object:LayoutSet()
	return Object
end

function Room:LayoutSet()
	local LayoutID = self.SettingsLayoutID
	if LayoutID == 1 then
		self.Status = "PUBLIC"
		self.Permissions = {
			["Players"] = {"VOTE_SKIP", "VOTE_KICK", "QUEUE_SONGS"},
			["Staff"] = {"VOTE_SKIP", "VOTE_KICK", "QUEUE_SONGS", "FORCE_SKIP", "FORCE_KICK"}
		}
	elseif LayoutID == 2 then
		self.Status = "PRIVATE"
		self.Permissions = {
			["Players"] = {},
			["Staff"] = {"VOTE_SKIP", "VOTE_KICK", "QUEUE_SONGS", "FORCE_SKIP", "FORCE_KICK"}
		}
	elseif LayoutID == 3 then
		self.Status = "PRIVATE"
		self.Permissions = {
			["Players"] = {"VOTE_SKIP", "VOTE_KICK", "QUEUE_SONGS"},
			["Staff"] = {"VOTE_SKIP", "VOTE_KICK", "QUEUE_SONGS", "FORCE_SKIP", "FORCE_KICK"}
		}
	end
end

function Room:UpdateRoomEditing(DATA)
	self.RoomName = DATA.RoomName
	self.RoomDescription = DATA.RoomDescription
	self.RoomIcon = DATA.RoomIcon
	self.Map = DATA.MapID or 0	
	self.Genres = DATA.Genres
	self.SettingsLayoutID = DATA.SettingsLayoutID
end

function Room:GenerateID()
	local TeleportService = game:GetService("TeleportService")
	--self.AccessCode = TeleportService:ReserveServer(6451627372)
end

local DataStoreService = game:GetService("DataStoreService")
local ActiveRoomsDataStore = DataStoreService:GetDataStore("ActiveRooms")

function Room:Activate()
	local CreatorID = self.CreatorID
	local RoomID = self.RoomID
	ActiveRoomsDataStore:UpdateAsync("ActiveRooms", function(OldTable)
		if not OldTable[CreatorID] then
			OldTable[CreatorID] = {}
		end
		OldTable[CreatorID][RoomID] = self
		return OldTable
	end)
end

function Room:DeActivate()
	local CreatorID = self.CreatorID
	local RoomID = self.RoomID
	ActiveRoomsDataStore:UpdateAsync("ActiveRooms", function(OldTable)
		OldTable[CreatorID][RoomID] = nil
		return OldTable
	end)
end

function Room:AddPlayer()
	self.Players += 1
	local PlayersAmount = self.Players
	if PlayersAmount == 1 then
		self:Activate()
	end
end

function Room:RemovePlayer()
	self.Players -= 1
	local PlayersAmount = self.Players
	if PlayersAmount == 0 then
		self:DeActivate()
	end
end

return Room
