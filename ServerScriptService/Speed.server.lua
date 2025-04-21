local gamePassId = 84526064
local players = game:GetService("Players")
local marketplaceService = game:GetService("MarketplaceService")
local speedTool = game.ReplicatedStorage:FindFirstChild("Speed")
local SpeedEquippedEvent = game.ReplicatedStorage:WaitForChild("SpeedEquippedEvent")

local function hasPass(player)
	local hasFlash = false
	local success, errorMsg = pcall(function()
		hasFlash = marketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId)
	end)

	if not success then
		warn(errorMsg)
		return false
	end

	print("hasflash: ", hasFlash)
	return hasFlash
end

SpeedEquippedEvent.OnServerEvent:Connect(function (player, equipped)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	if equipped == true then
		humanoid.WalkSpeed = 24
		print("speedBoost for", player.Name)
	else
		humanoid.WalkSpeed = 16
		print("normalSpeed for", player.Name)
	end
end)

marketplaceService.PromptGamePassPurchaseFinished:Connect(function(playerWhoBought, gamePassIdBought, wasPurchased)
	if gamePassIdBought == gamePassId and wasPurchased then
		print(playerWhoBought.Name .. " purchased the Game Pass") -- Debugging statement
		local speedToolClone = speedTool:Clone()
		speedToolClone.Parent = playerWhoBought:FindFirstChild("Backpack")
	end
end)

