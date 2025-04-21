local button = script.Parent
local numbers = {0, 1, 2}
local speed = 150
local TweenService = game:GetService("TweenService")

colors = {
	Color3.fromRGB(255),
	Color3.fromRGB(255, 127),
	Color3.fromRGB(255, 225),
	Color3.fromRGB(0, 255),
	Color3.fromRGB(0, 255, 255),
	Color3.fromRGB(0, 0, 255),
	Color3.fromRGB(127, 0, 225),
	Color3.fromRGB(255, 0, 255),
	Color3.fromRGB(225, 0, 127)
}

local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
local currentIndex = 1

local function createTween(targetColor)
	local goal = { BackgroundColor3 = targetColor }
	return TweenService:Create(button, tweenInfo, goal)
end

local function cycleColors()
	while true do
		local nextIndex = (currentIndex % #colors) + 1
		local tween = createTween(colors[nextIndex])
		tween:Play()
		
		tween.Completed:wait()
		currentIndex = nextIndex
	end
end

cycleColors()
