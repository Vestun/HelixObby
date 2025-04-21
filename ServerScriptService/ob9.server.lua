local left = workspace.KillBricks.ob9["moving left"]
local right = workspace.KillBricks.ob9["moving right"]
local RunService = game:GetService("RunService")
local speed = 5
local x = 0 -- 6
local y = 0 -- 7

local z = 0 -- 6
local w = 0 -- 6

local r = 0 -- 7
local t = 0 -- 7

RunService.Heartbeat:Connect(function(time)
	for _, killer in pairs(left:GetChildren()) do
		if x == 0 then
			if killer.Position.Z >= 162.557 then
				killer.Position = killer.Position + Vector3.new(0, 0, -time * speed)
			else
				z += 1
			end
			if z >= 6 then
				x = 1
				z = 0
			end
		elseif x == 1 then
			if killer.Position.Z <= 174.557 then
				killer.Position = killer.Position + Vector3.new(0, 0, time * (speed))
			else
				w += 1
			end
			if w >= 6 then
				w = 0
				x = 0
			end
		end
	end
	
	for _, killer in pairs(right:GetChildren()) do
		if y == 0 then
			if killer.Position.Z >= 162.557 then
				killer.Position = killer.Position + Vector3.new(0, 0, -time * (speed + 2))
			else
				r += 1
			end
			if r >= 7 then
				y = 1
				r = 0
			end
		elseif y == 1 then
			if killer.Position.Z <= 174.557 then
				killer.Position = killer.Position + Vector3.new(0, 0, time * (speed + 2))
			else
				t += 1
			end
			if t >= 7 then
				y = 0
				t = 0
			end
		end
	end
end)