local button = script.Parent
local player = game.Players.LocalPlayer
local shop = player:WaitForChild("PlayerGui"):WaitForChild("shopGui"):WaitForChild("shop")
local quit = shop:WaitForChild("quit")

local function mouseOver()
	button.TextSize = 2
end

local function mouseOut()
	button.TextSize = 1
end

button.MouseEnter:Connect(mouseOver)
button.MouseLeave:Connect(mouseOut)

button.MouseButton1Click:Connect(function()
	shop.Visible = true
end)

quit.MouseButton1Click:Connect(function()
	shop.Visible = false
end)

