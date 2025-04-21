
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local coinParts = workspace.Coins
local checkpoints = workspace.Checkpoints
local MarketPlayerService = game:GetService("MarketplaceService")

local speedId = 84526064
local speed = game.ReplicatedStorage:FindFirstChild("Speed")

-- Initialize the DataStore
local playersData = DataStoreService:GetDataStore("PlayerDataStore")

-- Function to get player data
local function getPlayerData(player)
	local success, data = pcall(function()
		return playersData:GetAsync(tostring(player.UserId))
	end)

	if success then
		return data
	else
		warn("Failed to retrieve player data for", player.Name, ":", tostring(data)) -- `data` contains the error message
		return nil
	end
end

local function deletePlayerData(player) -- testing
	local success, errorMessage = pcall(function()
		playersData:RemoveAsync(tostring(player.UserId))
	end)

	if success then
		print("Player data deleted successfully for", player.Name)
	else
		warn("Failed to delete player data for", player.Name, ":", errorMessage)
	end
end

-- Function to save player data
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

local function leaderstatsUpdate(player, playerData)
	
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local stage = leaderstats:FindFirstChild("stage")
	if not stage then
		stage = Instance.new("IntValue")
		stage.Name = "stage"
		stage.Value = 1 -- testing
		stage.Parent = leaderstats
	end
	
	local coins = leaderstats:FindFirstChild("coins")
	if not coins then
		coins = Instance.new("IntValue")
		coins.Name = "coins"
		coins.Value = 0
		coins.Parent = leaderstats
	end
	
	if stage.Value ~= playerData.leaderstats.stage then
		if playerData.leaderstats.stage < 1 then
			playerData.leaderstats.stage = 1
			savePlayerData(player, playerData)
		end	
		stage.Value = playerData.leaderstats.stage 
	end
end

-- Initialize player data if not already present
local function initializePlayerData(player)
	local playerData = getPlayerData(player)

	if not playerData then
		-- Default data if no data exists
		playerData = {
			leaderstats = {
				stage = 1, -- testing
				coins = 1
			}
		}

		savePlayerData(player, playerData)
	end
	leaderstatsUpdate(player, playerData)
end

local function teleportToCheckpoint(player, character)
	local playerData = getPlayerData(player)
	if playerData and playerData.leaderstats then
		local stage = playerData.leaderstats.stage
		local checkpoint = checkpoints:FindFirstChild(tostring(stage))
		if checkpoint and checkpoint.PrimaryPart then
			character:SetPrimaryPartCFrame(checkpoint.PrimaryPart.CFrame * CFrame.new(0, 8, 0))
		end
	end
end

for _, checkpointModel in checkpoints:GetChildren() do
	if checkpointModel:IsA("Model") then
		local checkpoint = checkpointModel:FindFirstChildWhichIsA("BasePart")
		if checkpoint then
			checkpoint.Touched:Connect(function(hit)
				local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local player = Players:GetPlayerFromCharacter(hit.Parent)
					if player then
						local playerData = getPlayerData(player)
						if playerData and playerData.leaderstats then
							if humanoid.Health > 0 then
								local stage = playerData.leaderstats.stage
								local checkpointStage = tonumber(checkpointModel.Name)
								if checkpointStage and (stage + 1) <= checkpointStage then
									playerData.leaderstats.stage = checkpointStage
									savePlayerData(player, playerData)
									leaderstatsUpdate(player, playerData)
								end
							end
						end
					end
				end
			end)
		end
	end
end

-- Connect to PlayerAdded event
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
		initializePlayerData(player)
		teleportToCheckpoint(player, character)
		
		local hasFlash = false
		
		local success, errorMsg = pcall(function()
			hasFlash = MarketPlayerService:UserOwnsGamePassAsync(player.UserId, speedId)
		end)
		
		if not success then
			warn(errorMsg)
		end
		
		if hasFlash then
			local backpack = player:FindFirstChild("Backpack")
			local cloneFlash = speed:Clone()
			cloneFlash.Parent = backpack
		else
			warn("player doesnt have gamepass")
		end
	end)
end)

Players.PlayerRemoving:Connect(deletePlayerData) -- testing