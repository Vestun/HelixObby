local players = game:GetService("Players")
local premodel = workspace.Checkpoints["8"]
local postmodel = workspace.Checkpoints["9"]
local precheckpoint = premodel:FindFirstChild("part")
local postcheckpoint = postmodel:FindFirstChild("part") 
local special = workspace.ObbyStructure:FindFirstChild("special")
local disappearing = workspace.KillBricks.disappearing
local onScreen = false

precheckpoint.Touched:Connect(function(hit)
	if onScreen == false then
		onScreen = true
		local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local player = players:GetPlayerFromCharacter(hit.Parent)
			local character = hit.Parent
			local playerGui = player:WaitForChild("PlayerGui")
			local rootPart = character:FindFirstChild("HumanoidRootPart")
		
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "highView"
			screenGui.Parent = playerGui
			
			for _, killer in disappearing:GetChildren() do
				killer.Transparency = 0
			end
		
			local textLabel = Instance.new("TextLabel")
			textLabel.Name = "textLabel"
			textLabel.Parent = screenGui
			textLabel.Size = UDim2.new(0, 200, 0, 50) -- Width, Height
			textLabel.Position = UDim2.new(0.5, -100, 0.5, -25) -- Centered
			textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White background
			textLabel.BackgroundTransparency = 1
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Black text
			textLabel.Text = "Zoom out and remember the placement of the red blocks!" -- Text to display
			textLabel.TextSize = 30
			textLabel.Font = Enum.Font.Bangers
		
			delay(5, function()
				screenGui:Destroy()
				onScreen = false
			end)
		end
	end
end)

postcheckpoint.Touched:Connect(function()
	for _, killer in disappearing:GetChildren() do
		killer.Transparency = 0
	end
end)

special.Touched:Connect(function()
	for _, killer in disappearing:GetChildren() do
		killer.Transparency = 1
	end
end)
