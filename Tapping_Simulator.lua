-- wait game loded
repeat
	wait(.05)
until game:IsLoaded() and game.PlaceId == 9498006165

--// library
local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local w = library:CreateWindow("Tapping Simulator")

--// Service
local players = game:GetService("Players")
local lp = players.LocalPlayer
local plrModule = require(game:GetService("ReplicatedStorage").Classes.Player).players
local plrData = plrModule[lp].data

--// Exploit Service
getgenv().Auto_Tap = false;

--// script
local main = w:CreateFolder("Main")
local misc = w:CreateFolder("Misc")

main:Toggle("Auto Tap", function(v)
	getgenv().Auto_Tap = v;
end)
spawn(function()
	local tap_remote = game:GetService("ReplicatedStorage").Events.Tap
	while true do
		if getgenv().Auto_Tap then
			if tap_remote ~= nil then
				-- This script was generated by Hydroxide's RemoteSpy: https://github.com/Upbolt/Hydroxide
				tap_remote:FireServer()
			else
				tap_remote = game:GetService("ReplicatedStorage").Events:FindFirstChild("Tap")
			end
		end
		task.wait(.1)
	end
end)
main:Button("Inf jump", function()
	plrData.jumps = tonumber(10e9)
end)

main:Button("Inf petequip",function()
	plrData.maxEquips = 10e9;
	wait(.1)
	game:GetService("ReplicatedStorage").Events.RefreshEquipsAndStorage:Fire()
end)

-- Misc
do
    misc:Button("Copy Discord Invite",function() if setclipboard then setclipboard("https://discord.gg/TFUeFEESVv") end end)
    misc:DestroyGui()
end
