-- Orion library
local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))();
local Esplibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiriot22/ESP-Lib/main/ESP.lua"))()
local idex = identifyexecutor or nil;
local w = library:MakeWindow({Name = tostring("["..idex().."]".." Duckyy - Blox Fruit"), HidePremium = false, SaveConfig = false, ConfigFolder = nil})

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local VU = game:GetService('VirtualUser')
local TS = game:GetService('TweenService')
local camera = game:GetService('Workspace').CurrentCamera
local mouse = Players.LocalPlayer:GetMouse()
local Pathfinding = game:GetService("PathfindingService")

local World_Type = nil;

repeat
    if World_Type == nil then
        if game.PlaceId == 2753915549 then
            World_Type = 1;
        elseif game.PlaceId == 4442272183 then
            World_Type = 2;
        elseif game.PlaceId == 7449423635 then
            World_Type = 3;
        else
            World_Type = 0;
        end
    end
    task.wait(.1)
until World_Type == 0 or World_Type ~= nil

local auto = w:MakeTab({
    Name = "Automation",
	Icon = nil,
	PremiumOnly = false
})
do
    -- tool
    auto:AddLabel("Tools")
    local SelectedTools;
    local ToolsTable = {};
    for i,v in pairs(lp.Backpack:GetDescendants()) do
        if v ~= nil and v:IsA("Tool") then
            local vName = v.Name
            table.insert(ToolsTable, tostring(vName))
        end
    end

    local ToolsDrop = auto:AddDropdown({
        Name = "Select Tools",
        Default = nil,
        Options = ToolsTable,
        Callback = function(v)
            SelectedTools = v;
        end
    })
    auto:AddButton({
        Name = "Refresh",
        Callback = function()
            table.clear(ToolsTable)
            for i,v in pairs(lp.Backpack:GetDescendants()) do
                if v ~= nil and v:IsA("Tool") then
                    local vName = v.Name
                    table.insert(ToolsTable, tostring(vName))
                end
            end
            wait(.2)
            ToolsDrop:Refresh({table.unpack(ToolsTable)}, true)
        end
    })

    do
        local boolean = false;
        getgenv().AutoAccessory = false;
        auto:AddToggle({
            Name = "Auto wear Accessory",
            Default = false,
            Callback = function(x)
                getgenv().AutoAccessory = x
            end
        })
        spawn(function()
            while getgenv().AutoAccessory == true do
                if lp.Character ~= nil and lp.Character:FindFirstChild("Humanoid") then
                    for i,v in pairs(lp.Character:GetChildren()) do
                        if v ~= nil and v:IsA("Accessory") and v:FindFirstChild("Handle") then
                            if v:FindFirstChild("IsAccessory") and v["IsAccessory"]:IsA("BoolValue") then
                                boolean = true;
                            else
                                boolean = false;
                            end
                        end
                    end

                    if boolean == false then
                        if lp.Character:FindFirstChildOfClass("Tool") and lp.Character[lp.Character:FindFirstChildOfClass("Tool").Name].ToolTip == "Wear" then
                            if lp.Character[lp.Character:FindFirstChildOfClass("Tool").Name]:FindFirstChildOfClass("RemoteFunction") then
                                lp.Character[lp.Character:FindFirstChildOfClass("Tool").Name]:FindFirstChildOfClass("RemoteFunction"):InvokeServer()
                                wait(0.3)
                                lp.Character.Humanoid:UnequipTools()
                            end
                        end

                        for i,v in pairs(lp.Backpack:GetChildren()) do
                            if v ~= nil and v.ToolTip == "Wear" then
                                lp.Character.Humanoid:EquipTool(v)
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    end

    -- Farm
    auto:AddParagraph("Farm","Farm mobs & boss")

    auto:AddToggle({
        Name = "Auto use Enchant/Buso Haki",
        Default = false,
        Callback = function(v)
            spawn(function()
                while v == true do
                    if lp.Character and lp.Character:FindFirstChild("HasBuso") == nil then
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_") then
                            game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("Buso");
                        end
                    end
                    wait(.1)
                end
            end)
        end
    })
    auto:AddToggle({
        Name = "Auto Set Spawnpoint",
        Default = false,
        Callback = function(v)
            spawn(function()
                while v == true do
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_") then
                        -- This script was generated by Hydroxide's RemoteSpy: https://github.com/Upbolt/Hydroxide
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    end
                    wait(.1)
                end
            end)
        end
    })

    --hitbox
    do
        local zColor;
        auto:AddToggle({
            Name = "Mobs Hitbox Expander",
            Default = false,
            Callback = function(v)
                while v == true do
                    if workspace:FindFirstChild("Enemies") then
                        for i,z in pairs(workspace.Enemies:GetDescendants()) do
                            if z ~= nil and z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") and z["HumanoidRootPart"].Transparency ~= .5 then
                                z["HumanoidRootPart"].Transparency = .5
                                z["HumanoidRootPart"].Size = Vector3.new(38,18,38)
                                if z["HumanoidRootPart"]:FindFirstChildOfClass("Vector3Value") then
                                    z["HumanoidRootPart"]:FindFirstChildOfClass("Vector3Value").Value = Vector3.new(38,18,38)
                                end
                            end
                            if z ~= nil and z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") then
                                z["HumanoidRootPart"].Color = zColor
                            end
                        end
                    end
                    task.wait()
                end
            end
        })
        auto:AddColorpicker({
            Name = "Mobs Hitbox Color",
            Default = Color3.fromRGB(163, 162, 165),
            Callback = function(v)
                zColor = v;
            end
        })
    end
end

local chr = w:MakeTab({
    Name = "Character",
	Icon = nil,
	PremiumOnly = false
})

do
    chr:AddButton({
        Name = "Dash without enegry",
        Callback = function()
            local mt = getrawmetatable(game)
            local old = mt.__namecall
            setreadonly(mt,false)
            mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            if getnamecallmethod() == 'FireServer' and self.Name == 'CommE' then
                if tostring(args[1]):lower() == "dodge" then
                    print("Used Dodge")
                args[3] = 0;
                end
            end
            return old(self, unpack(args))
            end)
            setreadonly(mt,true)
        end
    })
    -- Data
    if lp:FindFirstChild("Data") then
        do
            chr:AddLabel("Data")
            for _,v in pairs(lp.Data:GetChildren()) do
                if v:IsA("IntValue") then
                    if v.Name == "Fragments" then
                        chr:AddButton({
                            Name = tostring("Check "..v.Name),
                            Callback = function()
                                makenotif("Data", tostring(v.Name..": "..v.Value), 3)
                            end
                        })
                    end
                end

                if v:IsA("StringValue") and v.Name == "SpawnPoint" or v.Name == "Race" then
                    chr:AddButton({
                        Name = tostring("Check "..v.Name),
                        Callback = function()
                            makenotif("Data", tostring(v.Name..": "..v.Value), 3)
                        end
                    })
                end
            end
        end
    end

    -- Ken haki
    do
        chr:AddLabel("Observe / Ken Haki")
        chr:AddSlider({
            Name = "Vision Range",
            Min = 1000,
            Max = 10000,
            Default = 1000,
            Increment = 500,
            ValueName = "distance",
            Callback = function(num)
                if lp:FindFirstChild("VisionRadius") ~= nil and lp.VisionRadius:IsA("NumberValue") then
                    lp.VisionRadius.Value = num;
                end
            end
        })
    end

    -- Menu
    do
        chr:AddLabel("Open GUI")
        -- fruit shop
        chr:AddButton({
            Name = "Fruit Shop",
            Callback = function()
                local uiName = "FruitShop"
                for i,ui in pairs(lp.PlayerGui:GetDescendants()) do
                    if ui ~= nil and ui:IsA("Frame") and ui.Name == uiName then
                        if ui.Visible == false then ui.Visible = true end
                    end
                end
            end
        })
        -- fruit inventory
        chr:AddButton({
            Name = "Fruit Inventory",
            Callback = function()
                local uiName = "FruitInventory"
                for i,ui in pairs(lp.PlayerGui:GetDescendants()) do
                    if ui ~= nil and ui:IsA("Frame") and ui.Name == uiName then
                        if ui.Visible == false then ui.Visible = true end
                    end
                end
            end
        })
        -- inventory ( not working )
        --[[chr:AddButton({
            Name = "Inventory",
            Callback = function()
                local uiName = "Inventory"
                for i,ui in pairs(lp.PlayerGui:GetDescendants()) do
                    if ui ~= nil and ui:IsA("Frame") and ui.Name == uiName then
                        if ui.Visible == false then ui.Visible = true end
                    end
                end
            end
        })]]
        -- awakening toggler
        chr:AddButton({
            Name = "Awakening Toggler",
            Callback = function()
                local uiName = "AwakeningToggler"
                for i,ui in pairs(lp.PlayerGui:GetDescendants()) do
                    if ui ~= nil and ui:IsA("Frame") and ui.Name == uiName then
                        if ui.Visible == false then ui.Visible = true end
                    end
                end
            end
        })
        -- enchant colors
        chr:AddButton({
            Name = "Enchant/Buso colors",
            Callback = function()
                local uiName = "Colors"
                for i,ui in pairs(lp.PlayerGui:GetDescendants()) do
                    if ui ~= nil and ui:IsA("Frame") and ui.Name == uiName then
                        if ui.Visible == false then ui.Visible = true end
                    end
                end
            end
        })
    end

end

local visual = w:MakeTab({
    Name = "Visual",
    Icon = nil,
    PremiumOnly = false
})

do
    Esplibrary.AutoRemove = true;
    Esplibrary.TeamColor = true;

    Esplibrary:AddObjectListener(workspace, {
        Name = "Chest1",
        Type = "Part",
        CustomName = "Sliver Chest",
        Color = Color3.fromRGB(192,192,192),
        IsEnabled = "Chest1",
    })
    Esplibrary:AddObjectListener(workspace, {
        Name = "Chest2",
        Type = "Part",
        CustomName = "Gold Chest",
        Color = Color3.fromRGB(218,165,32),
        IsEnabled = "Chest2",
    })
    Esplibrary:AddObjectListener(workspace, {
        Name = "Chest3",
        Type = "Part",
        CustomName = "Diamond Chest",
        Color = Color3.fromRGB(185,242,255),
        IsEnabled = "Chest3",
    })
    Esplibrary:AddObjectListener(workspace, {
        Type = "Tool",
        PrimaryPart = function(v)
            if v:FindFirstChild("Handle") then
                return v.Handle
            end
        end,
        CustomName = function(obj)
            return tostring(obj.Name)
        end,
        Color = Color3.new(1,1,1),
        IsEnabled = "Fruit1"
    })
    Esplibrary:AddObjectListener(workspace, {
        Name = "Fruit",
        Type = "Model",
        PrimaryPart = function(v)
            if v:FindFirstChild("Handle") then
                return v.Handle
            end
        end,
        CustomName = "Fruit",
        Color = Color3.new(1,1,1),
        IsEnabled = "Fruit2"
    })

    visual:AddToggle({
        Name = "Enabled esp",
        Default = false,
        Callback = function(z)
            Esplibrary:Toggle(z)
        end
    })
    visual:AddToggle({
        Name = "Fruit esp",
        Default = false,
        Callback = function(z)
            Esplibrary["Fruit1"] = z
            Esplibrary["Fruit2"] = z
        end
    })
    Esplibrary:AddObjectListener(workspace, {
        Name = "Flower1",
        Type = "Part",
        CustomName = "Blue Flower",
        Color = Color3.fromRGB(33, 84, 185),
        IsEnabled = "F1"
    })
    Esplibrary:AddObjectListener(workspace, {
        Name = "Flower2",
        Type = "Part",
        CustomName = "Red Flower",
        Color = Color3.fromRGB(163, 75, 75),
        IsEnabled = "F2"
    })
    visual:AddToggle({
        Name = "Flower esp",
        Default = false,
        Callback = function(z)
            Esplibrary["F1"] = z
            Esplibrary["F2"] = z
        end
    })
    visual:AddToggle({
        Name = "Chest esp",
        Default = false,
        Callback = function(z)
            Esplibrary["Chest1"] = z
            Esplibrary["Chest2"] = z
            Esplibrary["Chest3"] = z
        end
    })
    visual:AddParagraph("Esp Options", "Setting of the esp")
    visual:AddToggle({
        Name = "Name",
        Default = true,
        Callback = function(z)
            Esplibrary.Names = z
        end
    })
    visual:AddToggle({
        Name = "Box",
        Default = true,
        Callback = function(z)
            Esplibrary.Boxes = z
        end
    })
    visual:AddToggle({
        Name = "Tracer",
        Default = false,
        Callback = function(z)
            Esplibrary.Tracers = z
        end
    })
end

local F_more = w:MakeTab({
    Name = "Fruit & More",
    Icon = nil,
    PremiumOnly = false
})

do
    -- bring stuff
    do
        F_more:AddLabel("Bring Stuff")
        F_more:AddButton({
            Name = "Bring All Fruit",
            Callback = function()
                if lp ~= nil and lp.Character ~= nil and lp.Character.PrimaryPart ~= nil then
                    if firetouchinterest then
                        for i,v in pairs(workspace:GetDescendants()) do
                            if v and v:IsA("Tool") and v:FindFirstChild("Fruit") and v:FindFirstChild("Handle") then
                                firetouchinterest(lp.Character.PrimaryPart, v:FindFirstChild("Handle"), 0)
                                wait(0.2)
                                firetouchinterest(lp.Character.PrimaryPart, v:FindFirstChild("Handle"), 1)
                            end

                            if v and v:IsA("Tool") and v:FindFirstChild("EatRemote") and v:FindFirstChild("Fruit") == nil and v:FindFirstChild("Handle") then
                                firetouchinterest(lp.Character.PrimaryPart, v:FindFirstChild("Handle"), 0)
                                wait(0.2)
                                firetouchinterest(lp.Character.PrimaryPart, v:FindFirstChild("Handle"), 1)
                            end
                        end
                    else
                        makenotif("Error","Unable: firetouchinterest", 5)
                        for i,v in pairs(workspace:GetDescendants()) do
                            if v and v:IsA("Tool") and v:FindFirstChild("Fruit") and v:FindFirstChild("Handle") then
                                local cf = lp.Character.PrimaryPart.CFrame * CFrame.new(0,1.5,.1)
                                v.Fruit.CFrame = cf
                                v.Handle.CFrame = cf
                            end

                            if v and v:IsA("Tool") and v:FindFirstChild("EatRemote") and v:FindFirstChild("Fruit") == nil and v:FindFirstChild("Handle") then
                                local cf = lp.Character.PrimaryPart.CFrame * CFrame.new(0,1.5,.1)
                                v.Handle.CFrame = cf
                            end
                        end
                    end
                end
            end
        })

        F_more:AddButton({
            Name = "Bring Flower",
            Callback = function()
                if lp ~= nil and lp.Chracter ~= nil and lp.Character.PrimaryPart ~= nil then
                    if firetouchinterest then
                        for _,v in pairs(workspace:GetChildren()) do
                            if v and v:IsA("Part") and v:FindFirstChildOfClass("TouchTransmitter") then
                                if v.Name == "Flower1" or v.Name == "Flower2" then
                                    firetouchinterest(lp.Character.PrimaryPart, v, 0)
                                    wait(.2)
                                    firetouchinterest(lp.Character.PrimaryPart, v, 1)
                                end
                            end
                        end
                    else
                        makenotif("Error","Unable: firetouchinterest", 5)
                        for _,v in pairs(workspace:GetChildren()) do
                            if v and v:IsA("Part") and v:FindFirstChildOfClass("TouchTransmitter") then
                                if v.Name == "Flower1" or v.Name == "Flower2" then
                                    local cf = lp.Chracter.PrimaryPart.CFrame * CFrame.new(0,1.5,.1)
                                    v.CFrame = cf
                                end
                            end
                        end
                    end
                end
            end
        })
    end

    -- Raids
    do
        F_more:AddLabel("Raids")

        do
            -- Kill aura
            getgenv().Killaura = false;
            F_more:AddToggle({
                Name = "Kill Aura",
                Default = false,
                Callback = function(x)
                    getgenv().Killaura = x
                end
            })
        end
        game:GetService("RunService").RenderStepped:Connect(function()
            if workspace:FindFirstChild("Enemies") and getgenv().Killaura == true then
                for i,mob in pairs(workspace.Enemies:GetDescendants()) do
                    if mob ~= nil and mob:FindFirstChild("Humanoid") and mob["Humanoid"].Health > 0 or mob["Humanoid"].Health ~= 0.1 then
                        mob.Humanoid.Health = 0.1;
                        wait(.5)
                        mob.Humanoid.Health = 0;
                    end
                end
            end
        end)
    end

end

local waypoint = w:MakeTab({
    Name = "Waypoint",
    Icon = nil,
    PremiumOnly = false
})
do
    waypoint:AddButton({
        Name = "Teleport To Nearest Boat Dealer",
        Callback = function()
            if workspace["NPCs"] and workspace["NPCs"]:FindFirstChild("Boat Dealer") and lp.Character ~= nil and lp.Character.PrimaryPart ~= nil then
                local dealer_part;
                local cframe;
                if workspace["NPCs"]:FindFirstChild("Boat Dealer") then
                    dealer_part = workspace["NPCs"]:FindFirstChild("Boat Dealer").HumanoidRootPart;
                    wait(.1)
                    if dealer_part ~= nil then
                        cframe = dealer_part.CFrame * CFrame.new(0,.2,-2.5)
                    end
                    wait(.1)
                    local Tween =TS:Create(lp.Character.PrimaryPart, TweenInfo.new(5), {CFrame = cframe})
                    Tween:Play()
                end
            else
                makenotif("Error","boat dealer nil", 2)
            end
        end
    })
end
local misc = w:MakeTab({
    Name = "Misc",
    Icon = nil,
    PremiumOnly = false
})

do
    -- Other Player Stuff
    do
        misc:AddLabel("Other Player")
        local Selected;
        local t = {};
        for i,v in pairs(Players:GetPlayers()) do
            if v ~= nil --[[and v ~= lp]] then
                if v.DisplayName then
                    table.insert(t,v.DisplayName)
                elseif v.Name then
                    table.insert(t, v.Name)
                end
            end
        end
        Players.PlayerAdded:Connect(function(player)
            if player ~= nil --[[and player ~= lp]] then
                if player.DisplayName then
                    table.insert(t, player.DisplayName)
                elseif player.Name then
                    table.insert(t, player.Name)
                end
            end
        end)
        Players.PlayerRemoving:Connect(function(player)
            if player.DisplayName then
                if table.find(t, player.DisplayName) then
                    table.remove(t, table.find(t, player.DisplayName))
                end
            elseif player.Name then
                if table.find(t, player.Name) then
                    table.remove(t, table.find(t, player.Name))
                end
            end
        end)
            local plrDrop = misc:AddDropdown({
                Name = "Player List",
                Default = nil,
                Options = nil,
                Callback = function(v)
                    Selected = v;
                end
            })
        misc:AddButton({
            Name = "Refresh",
            Callback = function()
                plrDrop:Refresh({table.unpack(t)}, true)
            end
        })
        misc:AddToggle({
            Name = "Spectate Player",
            Default = false,
            Callback = function(v)
                if v then
                    local plr = nil;
                    for i,z in pairs(Players:GetPlayers()) do
                        if z ~= nil and z.DisplayName == Selected or z.Name == Selected then
                            plr = z
                        end
                    end
                    if plr and plr.Character and plr.Character.PrimaryPart and plr.Character.Humanoid then
                        camera.CameraSubject = plr.Character.Humanoid
                    end
                else
                    if lp and lp.Character ~= nil and lp.Character and lp.Character.PrimaryPart and lp.Character.Humanoid then
                        camera.CameraSubject = lp.Character.Humanoid
                    end
                end
            end
        })
        misc:AddButton({
            Name = "Check Player All Data",
            Callback = function()
                local plr = nil;
                for i,z in pairs(Players:GetPlayers()) do
                    if z ~= nil and z.DisplayName == Selected or z.Name == Selected then
                        plr = z
                    end
                end
                if plr and plr:FindFirstChild("Data") and plr["Data"]:IsA("Folder") then
                    for _,v in pairs(plr.Data:GetChildren()) do
                        if v:IsA("IntValue") then
                            makenotif("Data", tostring(v.Name..": "..v.Value), 5)
                        end

                        if v:IsA("StringValue") then
                            makenotif("Data", tostring(v.Name..": "..v.Value), 5)
                        end
                    end
                end
            end
        })
        misc:AddButton({
            Name = "Check Player Backpack",
            Callback = function()
                local plr = nil;
                for i,z in pairs(Players:GetPlayers()) do
                    if z ~= nil and z.DisplayName == Selected or z.Name == Selected then
                        plr = z
                    end
                end

                if plr and plr:FindFirstChild("Backpack") then
                    for i,v in pairs(plr.Backpack:GetDescendants()) do
                        if v:IsA("Tool") and v.ToolTip ~= "Blox Fruit" then
                            makenotif(tostring("Tools: "..v.Name), tostring(v.ToolTip), 5)
                        end

                        if v:IsA("Tool") and v.ToolTip == "Blox Fruit" and v:FindFirstChild("AwakenedMoves") then
                            if v.AwakenedMoves:FindFirstChild("Z") and v.AwakenedMoves.Z:IsA("Folder") then
                                makenotif(tostring("Fruit: "..v.Name), tostring("Awakened Fruit"), 5)
                            end
                        elseif v:IsA("Tool") and v.ToolTip == "Blox Fruit" and v:FindFirstChild("AwakenedMoves") == nil then
                            makenotif(tostring("Fruits: "..v.Name), tostring(v.ToolTip), 5)
                        end
                    end
                end
            end
        })
        misc:AddButton({
            Name = "Teleport to Selected Player",
            Callback = function()
                local p=nil;
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr and plr.DisplayName == Selected then
                        p = plr
                    elseif plr and plr.Name == Selected then
                        p = plr
                    end
                end
                warn("haven't done")
            end
        })
    end
    -- misc
    do
        misc:AddLabel("Misc")
        misc:AddButton({
            Name = "Always Day",
            Callback = function()
                game:GetService("RunService").RenderStepped:Connect(function()
                    if game:WaitForChild("Lighting") then
                        game:GetService("Lighting").ClockTime = 8;
                    end
                end)
            end
        })

        -- walk on water
        do
            getgenv().WalkOnWater = false
            misc:AddToggle({
                Name = "Walk on water",
                Default = false,
                Callback = function(x)
                    getgenv().WalkOnWater = x
                end
            })
            game:GetService("RunService").RenderStepped:Connect(function()
                if getgenv().WalkOnWater == false then
                    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WaterBase-Plane") and workspace.Map["WaterBase-Plane"]:FindFirstChild("airPart") ~= nil then workspace.Map["WaterBase-Plane"]:FindFirstChild("airPart"):Destroy() end
                end
                if getgenv().WalkOnWater == true then
                    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WaterBase-Plane") then
                        if workspace.Map["WaterBase-Plane"]:FindFirstChild("airPart") ~= nil then
                            local cf = game:GetService("Workspace").Map["WaterBase-Plane"].CFrame * CFrame.new(0,16.1,0)
                            workspace.Map["WaterBase-Plane"]:FindFirstChild("airPart").CFrame = cf
                        else
                            local part = Instance.new("Part", workspace.Map:FindFirstChild("WaterBase-Plane"))
                            part.Name = "airPart"
                            part.Anchored = true
                            part.Transparency = 1
                            part.Color = Color3.new(1,0,0)
                            part.CanCollide = true
                            part.Size = game:GetService("Workspace").Map["WaterBase-Plane"].Size
                            local cf = game:GetService("Workspace").Map["WaterBase-Plane"].CFrame * CFrame.new(0,16.1,0)
                            part.CFrame = cf
                        end
                    end
                end
            end)
        end


        misc:AddButton({
            Name = "Remove Lava",
            Callback = function()
                if workspace:FindFirstChild("Map") then
                    for i,v in pairs(workspace.Map:GetDescendants()) do
                        if v ~= nil and v:IsA("Part") and v.Name == "Lava" and v:FindFirstChild("TouchInterest") then
                            v:Destroy()
                        end
                    end
                end
            end
        })
    end
    -- Server
    do
        misc:AddLabel("Server")
        misc:AddButton({
            Name = "Rejoin same server",
            Callback = function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
            end
        })
        misc:AddButton({
            Name = "Server hop",
            Callback = function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
            end
        })
    end
end

local credit = w:MakeTab({
    Name = "Credit",
	Icon = nil,
	PremiumOnly = false
})
credit:AddParagraph("Infomation","This script is free & open source, ofc there no premiun stuff")
credit:AddParagraph("Scripting","Ghost-Ducky#7698")
credit:AddParagraph("UI Library","Orion Library - Shlex")
credit:AddParagraph("Esp Library", "Kiriot22")
credit:AddButton({
    Name = "Copy Discord Invite",
    Callback = function()
        pcall(function()
            if setclipboard then
                setclipboard("discord.gg/TFUeFEESVv")
            end
        end)
    end
})

function makenotif(title,content,times,decal)
    library:MakeNotification({
        Name = tostring(title),
        Content = tostring(content),
        Image = decal or "rbxassetid://4483345998",
        Time = tonumber(times) or 3
    })
end

-- setup
library:Init()
