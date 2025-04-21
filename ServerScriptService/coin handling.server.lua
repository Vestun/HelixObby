local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local coinParts = workspace.Coins

-- Initialize the DataStore
local playersData = DataStoreService:GetDataStore("PlayerDataStore")

local function getPlayerData(player)
	local retries = 3
	
	for i = 1, retries do
		local success, data = pcall(function()
			return playersData:GetAsync(tostring(player.UserId))
		end)

		if success then
			return data
		else
			wait(1)
		end
	end
	
	return {leaderstats = {stage = 1, coins = 0} }
end

local function savePlayerData(player, data)
	local success, errorMessage = pcall(function()
		playersData:SetAsync(tostring(player.UserId), data)
	end)

	if success then
		print("Player data saved successfully for", player.Name)
	else
		warn("Failed to save player data for", player.Name, ":", errorMessage)
	end
end

local function coinUpdate(player, playerData, coinTouched)

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local coins = leaderstats:FindFirstChild("coins")
	if not coins then
		coins = Instance.new("IntValue")
		coins.Name = "coins"
		coins.Parent = leaderstats
		coins.Value = 0
	end
	
	local playerKey = player.Name .. "coin" .. coinTouched.Name
	
	print("Checking attribute for playerKey:", playerKey)
	print("Current attribute value:", coinTouched:GetAttribute(playerKey))
	
	if not coinTouched:GetAttribute(playerKey) then
		coinTouched:SetAttribute(playerKey, true)
		coinTouched.Transparency = 1
		coinTouched.CanCollide = false
		
		coins.Value = coins.Value + 1
		playerData.leaderstats.coins = coins.Value
		savePlayerData(player, playerData)
		
		print("Attribute set for playerKey:", playerKey)

		delay(300, function()
			if coinTouched then
				coinTouched.Transparency = 0
				coinTouched.CanCollide = true

				print("Resetting attribute for playerKey:", playerKey)
				coinTouched:SetAttribute(playerKey, nil)
			end
		end)
	end
end

for _, coin in coinParts:GetChildren() do
	if coin then
		coin.Touched:Connect(function(hit)
			local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
			if humanoid then
				local player = Players:GetPlayerFromCharacter(hit.Parent)
				if player then
					local coinTouched = coin
					local playerData = getPlayerData(player)
					if playerData then
						coinUpdate(player, playerData, coinTouched)
					end
				end
			end
		end)
	end
end
