local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteFolder = ReplicatedStorage.RemoteFolder
local GetActiveServers = RemoteFolder.GetActiveServers

local ActiveRoomsDataStore = DataStoreService:GetDataStore("ActiveRooms")
local ActiveRooms = {}

local function LoadActiveRooms()
    ActiveRooms = ActiveRoomsDataStore:GetAsync(ActiveRooms) 
end

GetActiveServers.OnServerInvoke = function(Player)
    return ActiveRooms
end

while wait(10) do
    LoadActiveRooms()
end



