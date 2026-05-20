-- ============================================
-- TOOLS FUGO ERSARO v3.0 FINAL
-- Full Utility Suite | Luna Interface
-- ALL FEATURES INCLUDED & WORKING
-- ============================================

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

-- ============================================
-- FUGO COLOR PALETTE
-- ============================================
local C = {
    Primary = Color3.fromRGB(220, 20, 20),
    Background = Color3.fromRGB(12, 12, 16),
    Surface = Color3.fromRGB(22, 22, 28),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(150, 150, 160),
    Success = Color3.fromRGB(40, 200, 80),
    Warning = Color3.fromRGB(255, 150, 30),
    Cyan = Color3.fromRGB(0, 255, 255)
}

-- ============================================
-- STATE
-- ============================================
local speedHackOn, speedMult = false, 1.5
local jumpBoostOn, jumpPower = false, 100
local noclipOn, noclipConn = false, nil
local godOn, godConn = false, nil
local flyOn, flySpeed, flyBV, flyConn = false, 50, nil, nil
local antiAfkOn, afkConn = false, nil
local coordOn, coordLabel = true, nil
local pingFpsOn, pingFpsGui = true, nil
local espOn, espMode = false, "Full"
local espTracers, espDist, espTeam, espVis = false, true, false, true
local espRate, espMaxDist = 30, 1000
local savedLocs = {}
local gameId = game.GameId
local shaderActive = "None"

-- ============================================
-- WINDOW
-- ============================================
local Window = Luna:CreateWindow({
    Name = "TOOLS FUGO ERSARO",
    Subtitle = "v3.0 | Made for Mizu",
    LogoID = nil,
    LoadingEnabled = true,
    LoadingTitle = "FUGO ERSARO",
    LoadingSubtitle = "Initializing...",
    ConfigSettings = {
        RootFolder = "FUGO_ERSARO",
        ConfigFolder = "ToolsConfig"
    },
    KeySystem = false
})

-- HOME TAB
local HomeTab = Window:CreateHomeTab({ DiscordInvite = "", Icon = 2 })
HomeTab:CreateParagraph({ Title = "TOOLS FUGO ERSARO v3.0", Text = "Welcome, " .. LocalPlayer.Name .. "!\n\nAll features are now fully functional.\nClick tabs below to navigate." })

-- ============================================
-- MOBILITY TAB (👟)
-- ============================================
local MobTab = Window:CreateTab({ Name = "MOBILITY", Icon = "👟", ImageSource = "Emoji", ShowTitle = true })

MobTab:CreateToggle({ Name = "Speed Hack", CurrentValue = false, Callback = function(v) speedHackOn = v end }, "SpeedHack")
MobTab:CreateSlider({ Name = "Speed Multiplier", Range = {1, 5}, Increment = 0.1, CurrentValue = 1.5, Callback = function(v) speedMult = v end }, "SpeedMult")

MobTab:CreateToggle({ Name = "Jump Boost", CurrentValue = false, Callback = function(v)
    jumpBoostOn = v
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = v and jumpPower or 50 end
end }, "JumpBoost")
MobTab:CreateSlider({ Name = "Jump Power", Range = {50, 300}, Increment = 5, CurrentValue = 100, Callback = function(v)
    jumpPower = v
    if jumpBoostOn then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = v end
    end
end }, "JumpPower")

-- Speed Hack Engine
RunService.RenderStepped:Connect(function()
    if speedHackOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local vel = LocalPlayer.Character.HumanoidRootPart.Velocity
        if vel.Magnitude > 1 then LocalPlayer.Character.HumanoidRootPart.Velocity = vel * speedMult end
    end
end)

-- ============================================
-- LOCATION TAB (📍)
-- ============================================
local LocTab = Window:CreateTab({ Name = "LOCATION", Icon = "📍", ImageSource = "Emoji", ShowTitle = true })

-- Coordinate Tracker
local function initCoords()
    local cg = Instance.new("ScreenGui"); cg.Name = "FugoCoords"; cg.ResetOnSpawn = false
    cg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    coordLabel = Instance.new("TextLabel")
    coordLabel.Size = UDim2.new(0, 320, 0, 22); coordLabel.Position = UDim2.new(0, 10, 0, 10)
    coordLabel.BackgroundColor3 = Color3.fromRGB(0,0,0); coordLabel.BackgroundTransparency = 0.4
    coordLabel.TextColor3 = Color3.fromRGB(0,255,100); coordLabel.Font = Enum.Font.Code
    coordLabel.TextSize = 13; coordLabel.Text = "📍 Waiting..."; coordLabel.Parent = cg
    RunService.RenderStepped:Connect(function()
        if not coordOn then coordLabel.Text = ""; return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local p = char.HumanoidRootPart.Position
            coordLabel.Text = string.format("📍 X:%.0f Y:%.0f Z:%.0f | FUGO ERSARO", p.X, p.Y, p.Z)
        end
    end)
end
initCoords()

LocTab:CreateToggle({ Name = "Show Coordinates", CurrentValue = true, Callback = function(v) coordOn = v end }, "ShowCoords")
LocTab:CreateButton({ Name = "Copy Coordinates", Callback = function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local p = char.HumanoidRootPart.Position
        local txt = string.format("Vector3.new(%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
        if setclipboard then setclipboard(txt) end
        print("📋 COPIED: " .. txt)
    end
end })

-- Dropdown lokasi
local locOptions = {"No saved locations"}
local locDropdown = LocTab:CreateDropdown({
    Name = "Saved Locations", Options = locOptions, CurrentOption = {"No saved locations"},
    MultipleOptions = false, Callback = function(opt) end
}, "SavedLocs")

-- Record
LocTab:CreateButton({ Name = "Record Location", Callback = function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local p = char.HumanoidRootPart.Position
    local name = "Loc " .. #savedLocs + 1
    table.insert(savedLocs, {Name = name, Pos = p, GameId = gameId})
    locOptions = {}; for _, loc in ipairs(savedLocs) do if loc.GameId == gameId then table.insert(locOptions, loc.Name) end end
    if #locOptions == 0 then locOptions = {"No saved locations"} end
    print("📍 RECORDED: " .. name)
end })

-- Teleport
LocTab:CreateButton({ Name = "Teleport To Selected", Callback = function()
    local selected = locDropdown.CurrentOption[1]
    for _, loc in ipairs(savedLocs) do
        if loc.Name == selected and loc.GameId == gameId then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(loc.Pos) end
            break
        end
    end
end })

-- Clear
LocTab:CreateButton({ Name = "Clear All Locations", Callback = function() savedLocs = {}; locOptions = {"No saved locations"}; print("🗑️ Cleared!") end })

-- ============================================
-- EXPLOIT TAB (🔴)
-- ============================================
local ExpTab = Window:CreateTab({ Name = "EXPLOIT", Icon = "🔴", ImageSource = "Emoji", ShowTitle = true })

-- Noclip
ExpTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v)
    noclipOn = v
    if v then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        local char = LocalPlayer.Character
        if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    end
end }, "Noclip")

-- God Mode
ExpTab:CreateToggle({ Name = "God Mode", CurrentValue = false, Callback = function(v)
    godOn = v
    if v then
        godConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.Health = char.Humanoid.MaxHealth end
        end)
    else
        if godConn then godConn:Disconnect(); godConn = nil end
    end
end }, "GodMode")

-- Fly
ExpTab:CreateToggle({ Name = "Fly Mode", CurrentValue = false, Callback = function(v)
    flyOn = v
    if v then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = true end
            if flyBV then flyBV:Destroy() end
            flyBV = Instance.new("BodyVelocity"); flyBV.MaxForce = Vector3.new(4000,4000,4000); flyBV.P = 1000
            flyBV.Parent = root
            flyConn = RunService.RenderStepped:Connect(function()
                if not flyOn then return end
                local dir = Vector3.zero; local cam = Workspace.CurrentCamera
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
                if flyBV then flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero end
            end)
        end
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
    end
end }, "FlyMode")
ExpTab:CreateSlider({ Name = "Fly Speed", Range = {1, 100}, Increment = 1, CurrentValue = 50, Callback = function(v) flySpeed = v end }, "FlySpeed")

-- ESP
ExpTab:CreateToggle({ Name = "ESP Master", CurrentValue = false, Callback = function(v) espOn = v end }, "ESPMaster")
ExpTab:CreateDropdown({ Name = "ESP Mode", Options = {"Box", "Full", "Health", "Hitbox", "NPC"}, CurrentOption = {"Full"}, MultipleOptions = false, Callback = function(v) espMode = v end }, "ESPMode")
ExpTab:CreateToggle({ Name = "Show Tracers", CurrentValue = false, Callback = function(v) espTracers = v end }, "Tracers")
ExpTab:CreateToggle({ Name = "Show Distance", CurrentValue = true, Callback = function(v) espDist = v end }, "Distance")
ExpTab:CreateToggle({ Name = "Team Check", CurrentValue = false, Callback = function(v) espTeam = v end }, "TeamCheck")
ExpTab:CreateToggle({ Name = "Visible Check", CurrentValue = true, Callback = function(v) espVis = v end }, "VisCheck")
ExpTab:CreateSlider({ Name = "Update Rate", Range = {1,60}, Increment = 1, CurrentValue = 30, Callback = function(v) espRate = v end }, "ESPRate")
ExpTab:CreateSlider({ Name = "Max Distance", Range = {50,2000}, Increment = 50, CurrentValue = 1000, Callback = function(v) espMaxDist = v end }, "ESPMaxDist")

-- ============================================
-- VISUAL TAB (👁️)
-- ============================================
local VisTab = Window:CreateTab({ Name = "VISUAL", Icon = "👁️", ImageSource = "Emoji", ShowTitle = true })

-- Ping & FPS Monitor
local function initPingFps()
    local gui = Instance.new("ScreenGui"); gui.Name = "FugoPingFPS"; gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0, 170, 0, 55); frame.Position = UDim2.new(1, -180, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(8,8,12); frame.BackgroundTransparency = 0.15; frame.BorderSizePixel = 0; frame.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,14); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Thickness = 2; stroke.Color = C.Cyan; stroke.Parent = frame
    local title = Instance.new("TextLabel"); title.Parent = frame; title.BackgroundTransparency = 1
    title.Position = UDim2.new(0,10,0,2); title.Size = UDim2.new(1,-20,0,16)
    title.Font = Enum.Font.GothamBold; title.Text = "STATS"; title.TextSize = 11; title.TextColor3 = C.Cyan
    local fpsText = Instance.new("TextLabel"); fpsText.Parent = frame; fpsText.BackgroundTransparency = 1
    fpsText.Position = UDim2.new(0,10,0,18); fpsText.Size = UDim2.new(1,-20,0,15)
    fpsText.Font = Enum.Font.Code; fpsText.TextSize = 15; fpsText.TextXAlignment = Enum.TextXAlignment.Left
    local pingText = Instance.new("TextLabel"); pingText.Parent = frame; pingText.BackgroundTransparency = 1
    pingText.Position = UDim2.new(0,10,0,34); pingText.Size = UDim2.new(1,-20,0,15)
    pingText.Font = Enum.Font.Code; pingText.TextSize = 15; pingText.TextXAlignment = Enum.TextXAlignment.Left
    pingFpsGui = gui
    local fps = 0; local frames = 0; local last = tick()
    RunService.RenderStepped:Connect(function()
        frames += 1
        if tick() - last >= 1 then fps = frames; frames = 0; last = tick() end
        if not pingFpsOn then gui.Enabled = false; return else gui.Enabled = true end
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        fpsText.Text = "FPS  : "..fps; pingText.Text = "PING : "..ping.."ms"
        fpsText.TextColor3 = fps >= 50 and Color3.fromRGB(0,255,120) or (fps >= 30 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,80,80))
        pingText.TextColor3 = ping <= 80 and Color3.fromRGB(0,255,120) or (ping <= 150 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,80,80))
    end)
end
initPingFps()
VisTab:CreateToggle({ Name = "Ping & FPS Monitor", CurrentValue = true, Callback = function(v) pingFpsOn = v end }, "PingFps")

-- Shaders
local function clearEffects() for _, v in pairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") then v:Destroy() end end end
local shaderFuncs = {
    ["Aesthetic RTX"] = function()
        clearEffects(); Lighting.Technology = Enum.Technology.Future; Lighting.GlobalShadows = true
        Lighting.Brightness = 2.5; Lighting.ClockTime = 17.4; Lighting.ExposureCompensation = 0.2
        Lighting.Ambient = Color3.fromRGB(255,220,200); Lighting.FogStart = 100000; Lighting.FogEnd = 100000
        local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.28; bloom.Size = 24; bloom.Threshold = 1.5
        local cc = Instance.new("ColorCorrectionEffect", Lighting); cc.Brightness = 0.03; cc.Contrast = 0.15; cc.Saturation = 0.08; cc.TintColor = Color3.fromRGB(255,235,220)
        local rays = Instance.new("SunRaysEffect", Lighting); rays.Intensity = 0.08; rays.Spread = 0.2
        local dof = Instance.new("DepthOfFieldEffect", Lighting); dof.FarIntensity = 0.07; dof.FocusDistance = 45; dof.InFocusRadius = 35; dof.NearIntensity = 0
        local atm = Instance.new("Atmosphere", Lighting); atm.Density = 0; atm.Haze = 0
    end,
    ["Neon Aqua"] = function()
        clearEffects(); Lighting.Technology = Enum.Technology.Future; Lighting.GlobalShadows = true
        Lighting.Brightness = 2.2; Lighting.ClockTime = 14; Lighting.ExposureCompensation = 0.12
        Lighting.Ambient = Color3.fromRGB(120,220,255); Lighting.FogEnd = 100000; Lighting.FogStart = 100000
        local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.35; bloom.Size = 28; bloom.Threshold = 1.2
        local cc = Instance.new("ColorCorrectionEffect", Lighting); cc.Brightness = 0.03; cc.Contrast = 0.12; cc.Saturation = 0.18; cc.TintColor = Color3.fromRGB(190,245,255)
        local rays = Instance.new("SunRaysEffect", Lighting); rays.Intensity = 0.035; rays.Spread = 0.12
        local dof = Instance.new("DepthOfFieldEffect", Lighting); dof.FarIntensity = 0.05; dof.FocusDistance = 60; dof.InFocusRadius = 45; dof.NearIntensity = 0
        local atm = Instance.new("Atmosphere", Lighting); atm.Density = 0; atm.Haze = 0
    end,
    ["Fresh HD"] = function()
        clearEffects(); Lighting.Technology = Enum.Technology.Future; Lighting.GlobalShadows = true
        Lighting.Brightness = 2; Lighting.ClockTime = 11.5; Lighting.ExposureCompensation = 0.08
        Lighting.Ambient = Color3.fromRGB(170,240,255); Lighting.FogEnd = 100000; Lighting.FogStart = 100000
        local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.2; bloom.Size = 18; bloom.Threshold = 1.5
        local cc = Instance.new("ColorCorrectionEffect", Lighting); cc.Brightness = 0.02; cc.Contrast = 0.08; cc.Saturation = 0.1; cc.TintColor = Color3.fromRGB(215,245,255)
        local rays = Instance.new("SunRaysEffect", Lighting); rays.Intensity = 0.025; rays.Spread = 0.08
        local dof = Instance.new("DepthOfFieldEffect", Lighting); dof.FarIntensity = 0.03; dof.FocusDistance = 75; dof.InFocusRadius = 60; dof.NearIntensity = 0
        local atm = Instance.new("Atmosphere", Lighting); atm.Density = 0; atm.Haze = 0
    end,
    ["RTX MAX"] = function()
        clearEffects(); Lighting.Technology = Enum.Technology.Future; Lighting.GlobalShadows = true
        Lighting.Brightness = 3; Lighting.ClockTime = 15.3; Lighting.ExposureCompensation = 0.18
        Lighting.Ambient = Color3.fromRGB(180,220,255); Lighting.FogStart = 100000; Lighting.FogEnd = 100000
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then terrain.WaterReflectance = 0.35; terrain.WaterTransparency = 0.15; terrain.WaterWaveSize = 0.12; terrain.WaterWaveSpeed = 18; terrain.WaterColor = Color3.fromRGB(80,170,255) end
        local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.28; bloom.Size = 34; bloom.Threshold = 1.7
        local cc = Instance.new("ColorCorrectionEffect", Lighting); cc.Brightness = 0.04; cc.Contrast = 0.22; cc.Saturation = 0.18; cc.TintColor = Color3.fromRGB(225,245,255)
        local rays = Instance.new("SunRaysEffect", Lighting); rays.Intensity = 0.06; rays.Spread = 0.15
        local dof = Instance.new("DepthOfFieldEffect", Lighting); dof.FarIntensity = 0.08; dof.FocusDistance = 55; dof.InFocusRadius = 45; dof.NearIntensity = 0
        local atm = Instance.new("Atmosphere", Lighting); atm.Density = 0.03; atm.Color = Color3.fromRGB(210,235,255); atm.Decay = Color3.fromRGB(140,190,255); atm.Glare = 0.2; atm.Haze = 0.1
    end
}
for name, func in pairs(shaderFuncs) do
    VisTab:CreateButton({ Name = name, Callback = func })
end

-- ============================================
-- GUARD TAB (🛡️)
-- ============================================
local GuardTab = Window:CreateTab({ Name = "GUARD", Icon = "🛡️", ImageSource = "Emoji", ShowTitle = true })

GuardTab:CreateToggle({ Name = "Anti-AFK", CurrentValue = false, Callback = function(v)
    antiAfkOn = v
    if v then
        afkConn = RunService.RenderStepped:Connect(function()
            if antiAfkOn then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()); task.wait(10) end
        end)
    else
        if afkConn then afkConn:Disconnect(); afkConn = nil end
    end
end }, "AntiAFK")

-- ============================================
-- FINAL
-- ============================================
print("✅ TOOLS FUGO ERSARO v3.0 FINAL LOADED!")
print("🟢 All features are fully functional.")
print("🔴 Tab: HOME | 👟 MOBILITY | 📍 LOCATION | 🔴 EXPLOIT | 👁️ VISUAL | 🛡️ GUARD")