-- // game loaded \\ --
while true do
    if game:IsLoaded() then
        break;
    end
end

--// Wally v3 Remake
local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))(); -- original source is deleted idk why
local w = library:CreateWindow("Tapping Simulator")
--// service
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()

--// script
do
    getgenv().Auto_Tap = false;
    local main = w:CreateFolder("Main")
    local module = require(game:GetService("ReplicatedStorage").Classes.Player).players
    local vGay = module[lp]
    main:Toggle("Auto tap", function(v)
        getgenv().Auto_Tap = v;
    end)
    main:Button("Inf doublejump",function()
        vGay.data.jumps = 99999999;
    end)

    local l_RefreshEquipsAndStorage_l = game:GetService("ReplicatedStorage").Events.RefreshEquipsAndStorage;
    main:Button("Inf petequip",function()
        vGay.data.maxEquips = 999999;
        l_RefreshEquipsAndStorage_l:Fire()
    end)
    main:Button("Inf petstorage",function()
        vGay.data.storage = 999999;
        l_RefreshEquipsAndStorage_l:Fire()
    end)

    module.TAP_COOLDOWN = 0.1;
    task.spawn(function()
        while true do
            if getgenv().Auto_Tap == true then
                local tap_remote = game:GetService("ReplicatedStorage").Events:FindFirstChild("Tap",true)
                tap_remote:InvokeServer()
            end
            wait(.05)
        end
    end)
end

do
    local misc = w:CreateFolder("Misc")
    misc:Button("Copy Discord Invite",function() if setclipboard then setclipboard("https://discord.gg/TFUeFEESVv") end end)
    misc:DestroyGui()
end
