local module = {}

local DataStoreService = game:GetService("DataStoreService")
local SavingDataStore = DataStoreService:GetDataStore("UserDataSavingSystddemmdmmmdsemgeddmdmdmmmmmm")

local UsersData = {}

function module.Set(Player, Data, ...)
	local PlayerID = Player.UserId
	local Indexes = {...}
	
	local tab = UsersData[PlayerID]
	for i = 1, #Indexes, 1 do
		if not tab[Indexes[i]] then 
			tab[Indexes[i]] = {} 
		end
		tab = tab[Indexes[i]]
	end
	
	local current = UsersData[PlayerID]
	for i = 1, #Indexes - 1, 1 do
		current = current[Indexes[i]]
	end
	
	current[Indexes[#Indexes]] = Data 
	print(Indexes)
	print(current)
	print(Data)
end

function module.Get(Player, ...)
	local PlayerID = Player.UserId
	local Indexes = {...}
	
	print(Indexes)
	print(UsersData)
	
	while not UsersData[PlayerID] do
		wait()
	end	
	
	local current = UsersData[PlayerID]
	for i = 1, #Indexes, 1 do
		current = current[Indexes[i]]
	end

	return current
end

game.Players.PlayerRemoving:Connect(function(Player)
	local PlayerId = Player.UserId
	SavingDataStore:SetAsync(PlayerId, UsersData[PlayerId])	

	UsersData[PlayerId] = nil
end)

game.Players.PlayerAdded:Connect(function(Player)
	local PlayerId = Player.UserId
	local Data = SavingDataStore:GetAsync(PlayerId)
	UsersData[PlayerId] = Data or {}
end)


local GetRemote = game.ReplicatedStorage.Remote.GetRemote

GetRemote.OnServerInvoke = function(Player, ...)
	return module.Get(Player, ...)
end


return module