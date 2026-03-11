-- BorsaCat V11 Premium UI
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local ts = game:GetService("TeleportService")
local http = game:GetService("HttpService")

-- Temizlik
if pGui:FindFirstChild("BorsaCatPremium") then pGui.BorsaCatPremium:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "BorsaCatPremium"
sg.Parent = pGui
sg.ResetOnSpawn = false

-- ANA PANEL (Daha geniş ve şık)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 230, 0, 190)
main.Position = UDim2.new(1, -240, 0.5, -95)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Gece siyahı
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true 
main.Parent = sg

-- Köşeleri yumuşat
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

-- Üst Başlık Çizgisi (Neon Mavi)
local line = Instance.new("Frame")
line.Size = UDim2.new(1, 0, 0, 3)
line.Position = UDim2.new(0, 0, 0, 0)
line.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
line.BorderSizePixel = 0
line.Parent = main
local lineCorner = Instance.new("UICorner")
lineCorner.Parent = line

-- BUTON TASARIMI FONKSİYONU
local function styleBtn(btn, text, pos, color)
    btn.Size = UDim2.new(1, -30, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.Parent = main
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    -- Hafif şeffaflık
    btn.BackgroundTransparency = 0.1
end

local b1 = Instance.new("TextButton")
styleBtn(b1, "REJOIN SERVER", UDim2.new(0, 15, 0, 25), Color3.fromRGB(35, 35, 35))

local b2 = Instance.new("TextButton")
styleBtn(b2, "SERVER HOP", UDim2.new(0, 15, 0, 80), Color3.fromRGB(0, 85, 180))

-- IMZA: MADE IN BORSACAT (Estetik Font)
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 1, -45)
footer.Text = "made in borsacat"
footer.TextColor3 = Color3.fromRGB(0, 162, 255) -- Neon mavi başla
footer.BackgroundTransparency = 1
footer.TextSize = 18
footer.Font = Enum.Font.Code -- Yazılımcı tipi font
footer.Parent = main

-- Gökkuşağı Efekti (Sadece İmzada)
spawn(function()
    local h = 0
    while wait() do
        h = h + 1
        footer.TextColor3 = Color3.fromHSV(h % 360 / 360, 0.7, 1)
    end
end)

-- FONKSİYONLAR
b1.MouseButton1Click:Connect(function() 
    b1.Text = "Bağlanılıyor..."
    ts:Teleport(game.PlaceId, player) 
end)

b2.MouseButton1Click:Connect(function()
    b2.Text = "Aranıyor..."
    local success, s = pcall(function() 
        return http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100")) 
    end)
    
    if success and s then
        for _,v in pairs(s.data) do
            if v.playing < (v.maxPlayers - 1) and v.id ~= game.JobId then
                ts:TeleportToPlaceInstance(game.PlaceId, v.id)
                return
            end
        end
    end
    b2.Text = "Hata!"
    wait(1)
    b2.Text = "SERVER HOP"
end)
