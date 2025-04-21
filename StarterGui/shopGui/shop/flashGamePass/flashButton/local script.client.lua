--Initializelocalvariables
local players = game:GetService("Players")
local marketplaceService = game:GetService("MarketplaceService")
local player = players.LocalPlayer

--Logtoconsolethatscriptisrunning
print("script running")

--flashIdistheidfortheflashitem(makesyoufaster)
local flashId = 84526064

-
local function promptPurchase()
	local hasFlash = false

	local success, errorMsg = pcall(function()
		hasFlash = marketplaceService:UserOwnsGamePassAsync(player.UserId, flashId)
		print("Has flash gamepass:", hasFlash)
	end)

	if not success then
		warn(errorMsg)
		return
	end

	if hasFlash then
		print("you already own this gamepass")
	else
		marketplaceService:PromptGamePassPurchase(player, flashId)
	end
end


script.Parent.MouseButton1Click:Connect(function()
	print("Button was clicked!") -- Should print this when the button is clicked
	promptPurchase()
end)