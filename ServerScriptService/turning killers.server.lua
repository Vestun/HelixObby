local killers = workspace.KillBricks.turning
local RunService = game:GetService("RunService")
local speed = 150
local x = 0

RunService.Heartbeat:Connect(function(time)
	for _, killer in pairs(killers:GetChildren()) do
		if x == 0 then
			if killer.Orientation.X >= 0 then
				killer.Orientation = killer.Orientation + Vector3.new(0, time * speed, 0)
			 else
				killer.Orientation = killer.Orientation - Vector3.new(0, time * speed, 0)
			end
		else
			if killer.Orientation.X >= 0 then
				killer.Orientation = killer.Orientation - Vector3.new(0, time * speed, 0)
			else
				killer.Orientation = killer.Orientation + Vector3.new(0, time * speed, 0)
			end
		end
	end
end)

while true do
	if x == 0 then
		x = 1
	else
		x = 0
	end
	wait(10)
end

