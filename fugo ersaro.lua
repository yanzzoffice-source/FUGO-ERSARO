--// MIWAA HUB : SCRIPT ROUTER SYSTEM

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer

pcall(function()
    CoreGui:FindFirstChild("MIWAA_HUB"):Destroy()
end)

--// GAME DATABASE

local SupportedGames = {

    [2753915549] = {
        Name = "Blox Fruits",
        Link = "YOUR_GAME_SCRIPT"
    },

    [4442272183] = {
        Name = "Blox Fruits",
        Link = "YOUR_GAME_SCRIPT"
    }

}

--// UNIVERSAL MODULES

local Modules = {

    Universal = {
        Name = "UNIVERSAL HUB",
        Link = "YOUR_UNIVERSAL_LINK"
    },

    Tools = {
        Name = "TOOLS MODE",
        Link = "YOUR_TOOLS_LINK"
    },

    Shaders = {
        Name = "SHADERS MODE",
        Link = "YOUR_SHADERS_LINK"
    }

}

--// GAME INFO

local GameName = "Unknown"

pcall(function()
    GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local CurrentGame = SupportedGames[game.PlaceId]

--// GUI

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MIWAA_HUB"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

--// BACKGROUND

local BG = Instance.new("Frame")
BG.Parent = ScreenGui
BG.Size = UDim2.new(2,0,2,0)
BG.Position = UDim2.new(-0.5,0,-0.5,0)
BG.BackgroundColor3 = Color3.fromRGB(0,0,0)
BG.BorderSizePixel = 0

local Ambient = Instance.new("Frame")
Ambient.Parent = BG
Ambient.AnchorPoint = Vector2.new(0.5,0.5)
Ambient.Position = UDim2.new(0.5,0,0.5,0)
Ambient.Size = UDim2.new(0,1200,0,1200)
Ambient.BackgroundColor3 = Color3.fromRGB(255,0,0)
Ambient.BackgroundTransparency = 0.96
Ambient.BorderSizePixel = 0

local AmbientCorner = Instance.new("UICorner")
AmbientCorner.CornerRadius = UDim.new(1,0)
AmbientCorner.Parent = Ambient

--// INTRO

local Intro = Instance.new("Frame")
Intro.Parent = ScreenGui
Intro.Size = UDim2.new(2,0,2,0)
Intro.Position = UDim2.new(-0.5,0,-0.5,0)
Intro.BackgroundTransparency = 1

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Parent = Intro
IntroTitle.AnchorPoint = Vector2.new(0.5,0.5)
IntroTitle.Position = UDim2.new(0.5,0,0.45,50)
IntroTitle.Size = UDim2.new(1,0,0,140)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "MIWAA HUB"
IntroTitle.Font = Enum.Font.Arcade
IntroTitle.TextScaled = true
IntroTitle.TextColor3 = Color3.fromRGB(255,255,255)
IntroTitle.TextTransparency = 1

local Stroke = Instance.new("UIStroke")
Stroke.Parent = IntroTitle
Stroke.Color = Color3.fromRGB(255,0,0)
Stroke.Thickness = 2

TweenService:Create(
    IntroTitle,
    TweenInfo.new(1.2,Enum.EasingStyle.Quint),
    {
        TextTransparency = 0,
        Position = UDim2.new(0.5,0,0.45,0)
    }
):Play()

--// SPARKS

for i = 1,45 do

    local Spark = Instance.new("Frame")
    Spark.Parent = ScreenGui
    Spark.Size = UDim2.new(0,2,0,2)
    Spark.BackgroundColor3 = Color3.fromRGB(255,0,0)
    Spark.BorderSizePixel = 0
    Spark.Position = UDim2.new(math.random(),0,1.2,0)

    local SparkCorner = Instance.new("UICorner")
    SparkCorner.CornerRadius = UDim.new(1,0)
    SparkCorner.Parent = Spark

    task.spawn(function()

        while Spark.Parent do

            Spark.Position = UDim2.new(math.random(),0,1.2,0)
            Spark.BackgroundTransparency = 0

            TweenService:Create(
                Spark,
                TweenInfo.new(math.random(2,5),Enum.EasingStyle.Linear),
                {
                    Position = UDim2.new(math.random(),0,-0.2,0),
                    BackgroundTransparency = 1
                }
            ):Play()

            task.wait(5)

        end

    end)

end

task.wait(2.5)

TweenService:Create(
    IntroTitle,
    TweenInfo.new(1),
    {
        TextTransparency = 1
    }
):Play()

task.wait(1)

Intro:Destroy()

--// PANEL

local Panel = Instance.new("Frame")
Panel.Parent = ScreenGui
Panel.AnchorPoint = Vector2.new(0.5,0.5)
Panel.Position = UDim2.new(0.5,0,0.5,0)
Panel.Size = UDim2.new(0,0,0,0)
Panel.BackgroundColor3 = Color3.fromRGB(8,8,8)
Panel.BorderSizePixel = 0
Panel.ClipsDescendants = true

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0,8)
PanelCorner.Parent = Panel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Parent = Panel
PanelStroke.Color = Color3.fromRGB(180,180,180)

TweenService:Create(
    Panel,
    TweenInfo.new(1,Enum.EasingStyle.Back),
    {
        Size = UDim2.new(0,520,0,470)
    }
):Play()

--// TITLE

local Title = Instance.new("TextLabel")
Title.Parent = Panel
Title.Size = UDim2.new(1,0,0,60)
Title.BackgroundTransparency = 1
Title.Text = "MIWAA HUB"
Title.Font = Enum.Font.Arcade
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,255,255)

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Parent = Title
TitleStroke.Color = Color3.fromRGB(255,0,0)

--// CLOSE

local Close = Instance.new("TextButton")
Close.Parent = Panel
Close.Position = UDim2.new(1,-40,0,10)
Close.Size = UDim2.new(0,28,0,28)
Close.BackgroundColor3 = Color3.fromRGB(30,0,0)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,5)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()

    ScreenGui:Destroy()

end)

--// INFO

local Info = {

    {"PLAYER",Player.Name},
    {"USER ID",Player.UserId},
    {"GAME",GameName},
    {"PLACE ID",game.PlaceId}

}

for i,v in ipairs(Info) do

    local Box = Instance.new("Frame")
    Box.Parent = Panel
    Box.Position = UDim2.new(0.05 + ((i-1)%2)*0.47,0,0.18 + math.floor((i-1)/2)*0.16,0)
    Box.Size = UDim2.new(0.43,0,0,60)
    Box.BackgroundColor3 = Color3.fromRGB(15,15,15)

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0,6)
    BoxCorner.Parent = Box

    local Label = Instance.new("TextLabel")
    Label.Parent = Box
    Label.Position = UDim2.new(0,10,0,6)
    Label.Size = UDim2.new(1,-20,0,14)
    Label.BackgroundTransparency = 1
    Label.Text = "["..v[1].."]"
    Label.Font = Enum.Font.Code
    Label.TextColor3 = Color3.fromRGB(120,120,120)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextSize = 12

    local Value = Instance.new("TextLabel")
    Value.Parent = Box
    Value.Position = UDim2.new(0,10,0,22)
    Value.Size = UDim2.new(1,-20,1,-22)
    Value.BackgroundTransparency = 1
    Value.Text = tostring(v[2])
    Value.Font = Enum.Font.GothamBold
    Value.TextColor3 = Color3.fromRGB(255,255,255)
    Value.TextXAlignment = Enum.TextXAlignment.Left
    Value.TextSize = 16

end

--// EXECUTE FUNCTION

local function Execute(Link)

    TweenService:Create(
        Panel,
        TweenInfo.new(0.4,Enum.EasingStyle.Quint),
        {
            Size = UDim2.new(0,0,0,0)
        }
    ):Play()

    task.wait(0.4)

    ScreenGui:Destroy()

    loadstring(game:HttpGet(Link))()

end

--// BUTTON CREATOR

local function CreateButton(Text,Y,Callback)

    local Button = Instance.new("TextButton")
    Button.Parent = Panel
    Button.Position = UDim2.new(0.05,0,Y,0)
    Button.Size = UDim2.new(0.9,0,0,42)
    Button.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Button.Text = Text
    Button.Font = Enum.Font.GothamBold
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.TextSize = 15

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,6)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Button
    Stroke.Color = Color3.fromRGB(255,0,0)

    Button.MouseEnter:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Color3.fromRGB(40,0,0)
            }
        ):Play()

    end)

    Button.MouseLeave:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Color3.fromRGB(20,20,20)
            }
        ):Play()

    end)

    Button.MouseButton1Click:Connect(Callback)

end

--// AUTO GAME SCRIPT

CreateButton("AUTO GAME SCRIPT",0.56,function()

    if CurrentGame then

        Execute(CurrentGame.Link)

    else

        warn("SCRIPT COMING SOON")

    end

end)

--// UNIVERSAL

CreateButton("UNIVERSAL HUB",0.67,function()

    Execute(Modules.Universal.Link)

end)

--// TOOLS

CreateButton("TOOLS MODE",0.78,function()

    Execute(Modules.Tools.Link)

end)

--// SHADERS

CreateButton("SHADERS MODE",0.89,function()

    Execute(Modules.Shaders.Link)

end)
