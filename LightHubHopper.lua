-- LightHub Ultra Stable Server Hop

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local ts = game:GetService("TeleportService")
local hs = game:GetService("HttpService")
local uis = game:GetService("UserInputService")

if not _G.HopBlacklist then
_G.HopBlacklist = {}
end

table.insert(_G.HopBlacklist,game.JobId)

-------------------------------------------------
-- UI
-------------------------------------------------

local sg = Instance.new("ScreenGui",player.PlayerGui)
sg.Name = "LightHub_System"

local main = Instance.new("Frame",sg)
main.Size = UDim2.new(0,200,0,230)
main.Position = UDim2.new(0.05,0,0.35,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

local header = Instance.new("Frame",main)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",header)

local title = Instance.new("TextLabel",header)
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "LIGHTHUB"
title.Font = Enum.Font.FredokaOne
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,200,0)
title.TextXAlignment = Enum.TextXAlignment.Left

-------------------------------------------------
-- MINIMIZE / CLOSE BUTTONS
-------------------------------------------------

local minimize = Instance.new("TextButton",header)
minimize.Size = UDim2.new(0,20,0,20)
minimize.Position = UDim2.new(1,-45,0.5,-10)
minimize.Text = "-"
minimize.Font = Enum.Font.FredokaOne
minimize.TextSize = 18
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",minimize)

local close = Instance.new("TextButton",header)
close.Size = UDim2.new(0,20,0,20)
close.Position = UDim2.new(1,-20,0.5,-10)
close.Text = "X"
close.Font = Enum.Font.FredokaOne
close.TextSize = 14
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",close)

-------------------------------------------------
-- LN LOGO
-------------------------------------------------

local logo = Instance.new("TextButton",sg)
logo.Size = UDim2.new(0,60,0,60)
logo.Position = UDim2.new(0.05,0,0.35,0)
logo.Text = "LN"
logo.Font = Enum.Font.FredokaOne
logo.TextSize = 24
logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
logo.TextColor3 = Color3.fromRGB(255,200,0)
logo.Visible = false
logo.Active = true
logo.Draggable = true
Instance.new("UICorner",logo)

-------------------------------------------------
-- DISCORD TEXT
-------------------------------------------------

local discord = Instance.new("TextButton",main)
discord.Size = UDim2.new(1,0,0,18)
discord.Position = UDim2.new(0,0,1,-20)
discord.BackgroundTransparency = 1
discord.Text = "discord.gg/yokatemz"
discord.Font = Enum.Font.FredokaOne
discord.TextSize = 11
discord.TextColor3 = Color3.fromRGB(255,200,0)

discord.MouseButton1Click:Connect(function()
if setclipboard then
setclipboard("https://discord.gg/lightnw")
discord.Text = "COPIED!"
task.wait(1.5)
discord.Text = "discord.gg/lightnw"
end
end)

-------------------------------------------------
-- BUTTON CREATOR
-------------------------------------------------

local function btn(t,c,y,f)

local b = Instance.new("TextButton",main)
b.Size = UDim2.new(0,170,0,35)
b.Position = UDim2.new(0.5,-85,0,y)
b.BackgroundColor3 = c
b.Text = t
b.Font = Enum.Font.FredokaOne
b.TextSize = 13
b.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",b)

b.MouseButton1Click:Connect(f)

end

-------------------------------------------------
-- SERVER HOP SYSTEM
-------------------------------------------------

local hopping = false
local servers = {}
local index = 1

local function loadServers()

servers = {}
local cursor = ""

repeat

local url =
"https://games.roblox.com/v1/games/"..
game.PlaceId..
"/servers/Public?sortOrder=Desc&limit=100&cursor="..
cursor

local success,res = pcall(function()
return hs:JSONDecode(game:HttpGet(url))
end)

if success and res and res.data then

for _,s in pairs(res.data) do

if s.id ~= game.JobId and not table.find(_G.HopBlacklist,s.id) then

local fullness = s.playing / s.maxPlayers

if fullness >= 0.6 then
table.insert(servers,s.id)
end

end

end

cursor = res.nextPageCursor or ""

end

task.wait(0.3)

until cursor == "" or #servers > 40

end

ts.TeleportInitFailed:Connect(function(plr,result)

if plr ~= player then return end

task.wait(1)

index += 1

if servers[index] then
ts:TeleportToPlaceInstance(game.PlaceId,servers[index],player)
end

end)

btn("SERVER HOP",Color3.fromRGB(130,0,255),45,function()

if hopping then return end
hopping = true

loadServers()

index = 1

if servers[index] then

table.insert(_G.HopBlacklist,servers[index])

ts:TeleportToPlaceInstance(game.PlaceId,servers[index],player)

end

task.wait(2)
hopping = false

end)

-------------------------------------------------
-- REJOIN
-------------------------------------------------

btn("REJOIN",Color3.fromRGB(0,170,120),85,function()

ts:TeleportToPlaceInstance(game.PlaceId,game.JobId,player)

end)

-------------------------------------------------
-- RESET
-------------------------------------------------

btn("RESET (F4)",Color3.fromRGB(200,120,0),125,function()

if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.Health = 0
end

end)

-------------------------------------------------
-- EXIT
-------------------------------------------------

btn("EXIT (F5)",Color3.fromRGB(220,0,0),165,function()

game:Shutdown()

end)

-------------------------------------------------
-- MINIMIZE / CLOSE FUNCTIONS
-------------------------------------------------

minimize.MouseButton1Click:Connect(function()

main.Visible = false
logo.Visible = true

end)

close.MouseButton1Click:Connect(function()

sg:Destroy()

end)

logo.MouseButton1Click:Connect(function()

main.Visible = true
logo.Visible = false

end)

-------------------------------------------------
-- HOTKEYS
-------------------------------------------------

uis.InputBegan:Connect(function(i,g)

if not g then

if i.KeyCode == Enum.KeyCode.F4 then
if player.Character then
player.Character.Humanoid.Health = 0
end
end

if i.KeyCode == Enum.KeyCode.F5 then
game:Shutdown()
end

end

end)
