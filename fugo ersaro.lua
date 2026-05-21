-- ============================================
-- TOOLS FUGO ERSARO v3.0 STANDALONE
-- GUI Tombol "F" | Fitur Penuh | Tanpa Pustaka Eksternal
-- ============================================

-- Layanan
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

-- Kondisi Awal
local speedHackOn, speedMult = false, 1.5
local jumpBoostOn, jumpPower = false, 100
local noclipOn, noclipConn = false, nil
local godOn, godConn = false, nil
local flyOn, flySpeed, flyBV, flyConn = false, 50, nil, nil
local antiAfkOn, afkConn = false, nil
local pingFpsOn, pingGui = true, nil
local savedLocs = {}

-- ============================================
-- MESIN FITUR
-- ============================================
-- Speed Hack
RunService.RenderStepped:Connect(function()
    if speedHackOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local vel = LocalPlayer.Character.HumanoidRootPart.Velocity
        if vel.Magnitude > 1 then LocalPlayer.Character.HumanoidRootPart.Velocity = vel * speedMult end
    end
end)

-- Ping & FPS
local function buatPingFps()
    local gui = Instance.new("ScreenGui"); gui.Name = "FugoPingFPS"; gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0, 160, 0, 40); frame.Position = UDim2.new(1, -170, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0); frame.BackgroundTransparency = 0.5; frame.BorderSizePixel = 0; frame.Parent = gui
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1
    label.Font = Enum.Font.Code; label.TextSize = 14; label.TextColor3 = Color3.fromRGB(0,255,255); label.Parent = frame
    pingGui = gui
    local fps, frames, last = 0, 0, tick()
    RunService.RenderStepped:Connect(function()
        frames += 1; if tick() - last >= 1 then fps = frames; frames = 0; last = tick() end
        if not pingFpsOn then gui.Enabled = false; return else gui.Enabled = true end
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        label.Text = string.format("FPS:%d | PING:%dms", fps, ping)
    end)
end
buatPingFps()

-- ============================================
-- PEMBANGUN GUI
-- ============================================
local screenGui = Instance.new("ScreenGui"); screenGui.Name = "FUGO_TOOLS"; screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function buatElemen(kelas, properti)
    local el = Instance.new(kelas)
    for prop, nilai in pairs(properti) do el[prop] = nilai end
    return el
end

-- TOMBOL UTAMA "F"
local tombolUtama = buatElemen("TextButton", {
    Parent = screenGui,
    Size = UDim2.new(0, 45, 0, 45),
    Position = UDim2.new(0.5, -22, 0.5, -22),
    BackgroundColor3 = Color3.fromRGB(220, 20, 20),
    Text = "F",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BorderSizePixel = 0,
    ZIndex = 10
})
buatElemen("UICorner", {Parent = tombolUtama, CornerRadius = UDim.new(0, 12)})
buatElemen("UIStroke", {Parent = tombolUtama, Color = Color3.fromRGB(255,255,255), Thickness = 2})

-- PANEL UTAMA
local panelUtama = buatElemen("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 300, 0, 350),
    Position = UDim2.new(0.5, -150, 0.5, -175),
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    Visible = false,
    ZIndex = 9,
    BorderSizePixel = 0
})
buatElemen("UICorner", {Parent = panelUtama, CornerRadius = UDim.new(0, 14)})
buatElemen("UIStroke", {Parent = panelUtama, Color = Color3.fromRGB(255,60,60), Thickness = 1.5})

-- JUDUL PANEL
buatElemen("TextLabel", {
    Parent = panelUtama,
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = Color3.fromRGB(220, 20, 20),
    Text = "TOOLS FUGO ERSARO v3.0",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BorderSizePixel = 0,
    ZIndex = 9
})

-- TAB
local tabAktif = "MOBILITY"
local tombolTab = {}
local function buatTombolTab(teks, kunci, urutan)
    local btn = buatElemen("TextButton", {
        Parent = panelUtama,
        Size = UDim2.new(0, 50, 0, 35),
        Position = UDim2.new(0, 10 + (urutan-1)*55, 0, 40),
        BackgroundColor3 = Color3.fromRGB(40,40,50),
        Text = teks,
        TextSize = 20,
        BorderSizePixel = 0,
        ZIndex = 9
    })
    btn.MouseButton1Click:Connect(function()
        tabAktif = kunci
        for _, b in ipairs(tombolTab) do b.BackgroundColor3 = Color3.fromRGB(40,40,50) end
        btn.BackgroundColor3 = Color3.fromRGB(220,20,20)
        perbaruiKonten()
    end)
    table.insert(tombolTab, btn)
end
buatTombolTab("👟", "MOBILITY", 1)
buatTombolTab("📍", "LOCATION", 2)
buatTombolTab("🔴", "EXPLOIT", 3)
buatTombolTab("👁️", "VISUAL", 4)
buatTombolTab("🛡️", "GUARD", 5)

-- AREA KONTEN
local areaKonten = buatElemen("ScrollingFrame", {
    Parent = panelUtama,
    Size = UDim2.new(1, 0, 1, -80),
    Position = UDim2.new(0, 5, 0, 80),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(255,60,60),
    CanvasSize = UDim2.new(0, 0, 0, 400),
    ZIndex = 9,
    BorderSizePixel = 0
})

-- FUNGSI UNTUK MENGISI KONTEN
local elemenKonten = {}
function perbaruiKonten()
    for _, el in ipairs(elemenKonten) do el:Destroy() end
    elemenKonten = {}
    local y = 5

    local function tambahSakelar(nama, callback)
        local frame = buatElemen("Frame", {
            Parent = areaKonten, Size = UDim2.new(1, -10, 0, 35), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = Color3.fromRGB(30,30,40), BorderSizePixel = 0
        })
        buatElemen("TextLabel", {
            Parent = frame, Size = UDim2.new(0.7, 0, 1, 0), BackgroundTransparency = 1,
            Text = nama, TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Gotham, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local btn = buatElemen("TextButton", {
            Parent = frame, Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(1, -55, 0, 0),
            BackgroundColor3 = Color3.fromRGB(60,60,68), Text = "OFF", TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0
        })
        local aktif = false
        btn.MouseButton1Click:Connect(function()
            aktif = not aktif
            btn.Text = aktif and "ON" or "OFF"
            btn.BackgroundColor3 = aktif and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(60,60,68)
            callback(aktif)
        end)
        table.insert(elemenKonten, frame)
        y = y + 40
    end

    local function tambahSlider(nama, min, maks, default, callback)
        local frame = buatElemen("Frame", {
            Parent = areaKonten, Size = UDim2.new(1, -10, 0, 55), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = Color3.fromRGB(30,30,40), BorderSizePixel = 0
        })
        buatElemen("TextLabel", {
            Parent = frame, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
            Text = nama .. ": " .. default, TextColor3 = Color3.fromRGB(200,200,200), Font = Enum.Font.Gotham, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local val = default
        local slider = buatElemen("TextBox", {
            Parent = frame, Size = UDim2.new(1, -10, 0, 25), Position = UDim2.new(0, 5, 0, 22),
            BackgroundColor3 = Color3.fromRGB(50,50,60), Text = tostring(default), TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.Code, TextSize = 12, BorderSizePixel = 0
        })
        slider.FocusLost:Connect(function()
            local n = tonumber(slider.Text)
            if n then n = math.clamp(n, min, maks); slider.Text = tostring(n); val = n; callback(n) end
        end)
        table.insert(elemenKonten, frame)
        y = y + 60
    end

    -- ISI TIAP TAB
    if tabAktif == "MOBILITY" then
        tambahSakelar("Speed Hack", function(v) speedHackOn = v end)
        tambahSlider("Speed Multiplier", 1, 5, 1.5, function(v) speedMult = v end)
        tambahSakelar("Jump Boost", function(v)
            jumpBoostOn = v
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = v and jumpPower or 50
            end
        end)
        tambahSlider("Jump Power", 50, 300, 100, function(v)
            jumpPower = v
            if jumpBoostOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = v
            end
        end)
    elseif tabAktif == "LOCATION" then
        tambahSakelar("Show Coords", function(v) end)
        local btnRekam = buatElemen("TextButton", {
            Parent = areaKonten, Size = UDim2.new(1, -10, 0, 35), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = Color3.fromRGB(40,40,50), Text = "Record Location", TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.Gotham, TextSize = 13, BorderSizePixel = 0
        })
        btnRekam.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local p = char.HumanoidRootPart.Position
                table.insert(savedLocs, {Name = "Loc " .. #savedLocs + 1, Pos = p})
            end
        end)
        table.insert(elemenKonten, btnRekam)
        y = y + 40
        local btnTele = buatElemen("TextButton", {
            Parent = areaKonten, Size = UDim2.new(1, -10, 0, 35), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = Color3.fromRGB(40,40,50), Text = "Teleport Last", TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.Gotham, TextSize = 13, BorderSizePixel = 0
        })
        btnTele.MouseButton1Click:Connect(function()
            if #savedLocs > 0 then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(savedLocs[#savedLocs].Pos)
                end
            end
        end)
        table.insert(elemenKonten, btnTele)
    elseif tabAktif == "EXPLOIT" then
        tambahSakelar("Noclip", function(v)
            noclipOn = v
            if v then
                noclipConn = RunService.Stepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                    end
                end)
            else
                if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
                end
            end
        end)
        tambahSakelar("God Mode", function(v)
            godOn = v
            if v then
                godConn = RunService.RenderStepped:Connect(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then char.Humanoid.Health = char.Humanoid.MaxHealth end
                end)
            else
                if godConn then godConn:Disconnect(); godConn = nil end
            end
        end)
        tambahSakelar("Fly Mode", function(v)
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
        end)
        tambahSlider("Fly Speed", 1, 100, 50, function(v) flySpeed = v end)
    elseif tabAktif == "VISUAL" then
        tambahSakelar("Ping & FPS", function(v) pingFpsOn = v end)
        local shaders = {
            {"Aesthetic RTX", function()
                for _, v in pairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") then v:Destroy() end end
                Lighting.Technology = Enum.Technology.Future; Lighting.GlobalShadows = true
                Lighting.Brightness = 2.5; Lighting.ClockTime = 17.4; Lighting.Ambient = Color3.fromRGB(255,220,200)
                local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.28; bloom.Size = 24; bloom.Threshold = 1.5
            end},
            {"Neon Aqua", function()
                for _, v in pairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") then v:Destroy() end end
                Lighting.Technology = Enum.Technology.Future; Lighting.GlobalShadows = true
                Lighting.Brightness = 2.2; Lighting.ClockTime = 14; Lighting.Ambient = Color3.fromRGB(120,220,255)
                local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.35; bloom.Size = 28; bloom.Threshold = 1.2
            end}
        }
        for _, sh in ipairs(shaders) do
            local btn = buatElemen("TextButton", {
                Parent = areaKonten, Size = UDim2.new(1, -10, 0, 35), Position = UDim2.new(0, 0, 0, y),
                BackgroundColor3 = Color3.fromRGB(40,40,50), Text = sh[1], TextColor3 = Color3.fromRGB(255,255,255),
                Font = Enum.Font.Gotham, TextSize = 13, BorderSizePixel = 0
            })
            btn.MouseButton1Click:Connect(sh[2])
            table.insert(elemenKonten, btn)
            y = y + 40
        end
    elseif tabAktif == "GUARD" then
        tambahSakelar("Anti-AFK", function(v)
            antiAfkOn = v
            if v then
                afkConn = RunService.RenderStepped:Connect(function()
                    if antiAfkOn then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()); task.wait(10) end
                end)
            else
                if afkConn then afkConn:Disconnect(); afkConn = nil end
            end
        end)
    end
    areaKonten.CanvasSize = UDim2.new(0, 0, 0, y + 20)
end
perbaruiKonten()

-- LOGIKA GESER DAN TAMPILKAN
local menggeser, mulaiGeser, posisiAwal
tombolUtama.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        menggeser = true; mulaiGeser = input.Position; posisiAwal = tombolUtama.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then menggeser = false end end)
    end
end)
tombolUtama.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and menggeser then
        local delta = input.Position - mulaiGeser
        tombolUtama.Position = UDim2.new(posisiAwal.X.Scale, posisiAwal.X.Offset + delta.X, posisiAwal.Y.Scale, posisiAwal.Y.Offset + delta.Y)
    end
end)

tombolUtama.MouseButton1Click:Connect(function()
    if not menggeser then panelUtama.Visible = not panelUtama.Visible end
end)

print("✅ TOOLS FUGO ERSARO STANDALONE AKTIF!")
