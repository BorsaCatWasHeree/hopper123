-- LightHub V95: 10-16 Player Focused Server Hop
repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local ts = game:GetService("TeleportService")
local hs = game:GetService("HttpService")

-- TEMİZLİK
if player.PlayerGui:FindFirstChild("LightHub_Final") then player.PlayerGui.LightHub_Final:Destroy() end

local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "LightHub_Final"
sg.ResetOnSpawn = false

-- ANA PANEL
local main = Instance.new("Frame", sg)
main.Name = "Main"
main.Size = UDim2.new(0, 200, 0, 245)
main.Position = UDim2.new(0.02, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true; main.Draggable = true 
Instance.new("UICorner", main)

-- GERİ AÇMA (LN - SÜRÜKLENEBİLİR)
local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 45, 0, 45); openBtn.Position = UDim2.new(0, 5, 0.5, -22)
openBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); openBtn.Text = "LN"
openBtn.TextColor3 = Color3.fromRGB(255, 200, 0); openBtn.Font = "FredokaOne"
openBtn.TextSize = 22; openBtn.Visible = false; openBtn.Active = true; openBtn.Draggable = true
Instance.new("UICorner", openBtn)
openBtn.MouseButton1Click:Connect(function() main.Visible = true; openBtn.Visible = false end)

-- BAŞLIK
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40); header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", header)

local mainTitle = Instance.new("TextLabel", header)
mainTitle.Size = UDim2.new(1, 0, 1, 0); mainTitle.Position = UDim2.new(0.1, 0, 0, 0)
mainTitle.Text = "LIGHTHUB"; mainTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
mainTitle.Font = "FredokaOne"; mainTitle.TextSize = 14; mainTitle.BackgroundTransparency = 1
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- KONTROLLER
local function createCtrl(txt, posX, color, callback)
    local b = Instance.new("TextButton", header)
    b.Size = UDim2.new(0, 22, 0, 22); b.Position = UDim2.new(1, posX, 0.5, -11)
    b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = "FredokaOne"; b.TextSize = 14; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

createCtrl("-", -55, Color3.fromRGB(45, 45, 45), function() main.Visible = false; openBtn.Visible = true end)
createCtrl("X", -28, Color3.fromRGB(200, 50, 50), function() sg:Destroy() end)

-- BUTONLAR
local function addBtn(txt, color, y, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0, 180, 0, 38); b.Position = UDim2.new(0.5, -90, 0, y)
    b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = "FredokaOne"; b.TextSize = 13; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

-- SERVER HOP (CROWD HUNTER - MIN 10 PLAYER)
addBtn("SERVER HOP", Color3.fromRGB(120, 0, 255), 50, function()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
    local success, response = pcall(function() return hs:JSONDecode(game:HttpGet(url)) end)
    
    if success and response.data then
        local validServers = {}
        for _, v in pairs(response.data) do
            -- Filtre: 10 kişiden fazla, sunucu full değil ve şu anki sunucu değil
            if v.playing >= 10 and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(validServers, v.id)
            end
        end
        
        -- Eğer 10+ kişi olan sunucu bulamazsa, en azından 5+ olanlara bak
        if #validServers == 0 then
            for _, v in pairs(response.data) do
                if v.playing >= 5 and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(validServers, v.id)
                end
            end
        end

        if #validServers > 0 then
            ts:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)], player)
        else
            ts:Teleport(game.PlaceId, player) -- Hiç bulamazsa rastgele at
        end
    else
        ts:Teleport(game.PlaceId, player)
    end
end)

-- REJOIN
addBtn("REJOIN", Color3.fromRGB(0, 150, 100), 95, function()
    ts:SetTeleportGui(Instance.new("ScreenGui"))
    pcall(function() ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
    task.delay(0.5, function() ts:Teleport(game.PlaceId, player) end)
end)

addBtn("INSTANT RESET (F4)", Color3.fromRGB(180, 80, 0), 140, function()
    if player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.Health = 0 end
end)

addBtn("INSTANT EXIT (F5)", Color3.fromRGB(200, 0, 0), 185, function()
    game:Shutdown()
end)

-- DISCORD
local dc = Instance.new("TextLabel", main)
dc.Size = UDim2.new(1, 0, 0, 20); dc.Position = UDim2.new(0, 0, 1, -22)
dc.BackgroundTransparency = 1; dc.Text = "discord.gg/lightnw"
dc.TextColor3 = Color3.new(1,1,1); dc.Font = "FredokaOne"; dc.TextSize = 12

-- KISAYOLLAR
uis.InputBegan:Connect(function(i, g)
    if not g then
        if i.KeyCode == Enum.KeyCode.F4 then player.Character.Humanoid.Health = 0
        elseif i.KeyCode == Enum.KeyCode.F5 then game:Shutdown() end
    end
end)
