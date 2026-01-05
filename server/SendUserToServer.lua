local TeleportService = game:GetService("TeleportService")

local ReplicatedStorage = game.ReplicatedStorage
local SendUserToServer = ReplicatedStorage.Remote.SendUserToServer

SendUserToServer.OnServerInvoke = function(Player, AccessCode)
	TeleportService:TeleportToPrivateServer(6451627372, AccessCode, {Player})
end
