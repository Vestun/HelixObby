local marketplaceService = game:GetService("MarketplaceService")
local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character
local SpeedEquippedEvent = game.ReplicatedStorage:FindFirstChild("SpeedEquippedEvent")

character.ChildAdded:Connect(function (child)
	if child:IsA('Tool') and child.Name == "Speed" then
		SpeedEquippedEvent:FireServer(true)
	end
end)

character.ChildRemoved:Connect(function (child)
	if child:IsA('Tool') and child.Name == "Speed" then
		SpeedEquippedEvent:FireServer(false)
	end
end)