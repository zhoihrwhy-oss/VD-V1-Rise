-- [[ FLUENT UI - ROBLOX VD EDITION ]] --
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Inisialisasi Window Utama dengan Nama "Setting hub by Zhoihr"
local Window = Fluent:CreateWindow({
    Title = "Setting hub by Zhoihr",
    SubTitle = "VD Gameplay Remastered",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- [[ SELECTION TABS WITH LUCIDE ICONS ]]
local Tabs = {
    Gerald = Window:AddTab({ Title = "Gerald Menu", Icon = "user" }),
    Killer = Window:AddTab({ Title = "Killer Menu", Icon = "skull" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ GLOBAL STATE CONTROLLER ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local runService = game:GetService("RunService")

_G.AutoSlash = false
_G.AnchorToPlayer = false
_G.HitboxPlayer = false
_G.AntiStun = false

_G.AutoHanging = false
_G.AutoCrashEngine = false
_G.AutoCarry = false
_G.SpeedHack = false

local function GetClosestPlayer()
    local target = nil
    local distance = math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then return nil end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
            if dist < distance then
                distance = dist
                target = p
            end
        end
    end
    return target
end

-- [[ ASSET FLOATING TOGGLE BUTTON ENGINE (ID: 7059346373) ]]
local CoreGui = game:GetService("CoreGui")
local ToggleGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local ToggleCorner = Instance.new("UICorner")
local ToggleStroke = Instance.new("UIStroke")

ToggleGui.Name = "FluentToggleHub_VD"
ToggleGui.Parent = CoreGui
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "CustomSettingGear"
ToggleButton.Parent = ToggleGui
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.Image = "rbxassetid://7059346373"
ToggleButton.ZIndex = 99999

ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

ToggleStroke.Thickness = 1.5
ToggleStroke.Color = Color3.fromRGB(255, 65, 65)
ToggleStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    if Window then
        Window:Minimize()
    end
    
    ToggleButton:TweenSize(UDim2.new(0, 42, 0, 42), "Out", "Quad", 0.1, true, function()
        ToggleButton:TweenSize(UDim2.new(0, 48, 0, 48), "In", "Quad", 0.1, true)
    end)
end)


-- [[ TAB 1: GERALD FEATURES ]]
local ToggleSlash = Tabs.Gerald:AddToggle("AutoSlash", {Title = "Auto Slash", Default = false})
ToggleSlash:OnChanged(function(v)
    _G.AutoSlash = v
end)

local ToggleAnchor = Tabs.Gerald:AddToggle("AnchorPlayer", {Title = "Anchor to Player", Default = false})
ToggleAnchor:OnChanged(function(v)
    _G.AnchorToPlayer = v
end)

local ToggleHitbox = Tabs.Gerald:AddToggle("HitboxPlayer", {Title = "Hitbox Player (25 Studs)", Default = false})
ToggleHitbox:OnChanged(function(v)
    _G.HitboxPlayer = v
end)

local ToggleAntiStun = Tabs.Gerald:AddToggle("AntiStun", {Title = "Anti Stun / Ragdoll", Default = false})
ToggleAntiStun:OnChanged(function(v)
    _G.AntiStun = v
end)

Tabs.Gerald:AddButton({
    Title = "Fling Player",
    Description = "Fling closest target player",
    Callback = function()
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local origCFrame = myRoot.CFrame
                myRoot.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.5, 0)
                local bV = Instance.new("BodyAngularVelocity")
                bV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bV.AngularVelocity = Vector3.new(0, 99999, 0)
                bV.Parent = myRoot
                task.wait(0.1)
                bV:Destroy()
                myRoot.CFrame = origCFrame
            end
        end
    end
})

Tabs.Gerald:AddButton({
    Title = "Auto Get Killer",
    Description = "Collect weapons or killer interactables",
    Callback = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ClickDetector") and (v.Parent.Name:lower():find("killer") or v.Parent.Name:lower():find("weapon")) then
                fireclickdetector(v)
            end
        end
    end
})


-- [[ TAB 2: KILLER FEATURES ]]
local ToggleHanging = Tabs.Killer:AddToggle("AutoHanging", {Title = "Auto Hanging", Default = false})
ToggleHanging:OnChanged(function(v)
    _G.AutoHanging = v
end)

local ToggleCrash = Tabs.Killer:AddToggle("AutoCrash", {Title = "Auto Crash Engine", Default = false})
ToggleCrash:OnChanged(function(v)
    _G.AutoCrashEngine = v
end)

local ToggleCarry = Tabs.Killer:AddToggle("AutoCarry", {Title = "Auto Carry Target", Default = false})
ToggleCarry:OnChanged(function(v)
    _G.AutoCarry = v
end)

local ToggleSpeed = Tabs.Killer:AddToggle("SpeedHack", {Title = "Speed 100", Default = false})
ToggleSpeed:OnChanged(function(v)
    _G.SpeedHack = v
end)

Tabs.Killer:AddParagraph({
    Title = "CREDITS Project",
    Content = "Zhoihr Zenns • andepzai • maru • happy • gasal • shizou"
})


-- [[ THE CONTROL LOOP CORES ENGINE ]]
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local target = GetClosestPlayer()
            
            -- HITBOX INJECTION EXPANDER
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = p.Character.HumanoidRootPart
                    if _G.HitboxPlayer then
                        rootPart.Size = Vector3.new(25, 25, 25)
                        rootPart.Transparency = 0.7
                        rootPart.Color = Color3.fromRGB(255, 65, 65)
                        rootPart.Material = Enum.Material.Neon
                        rootPart.CanCollide = false
                    else
                        rootPart.Size = Vector3.new(2, 2, 1)
                        rootPart.Transparency = 1
                        rootPart.CanCollide = true
                    end
                end
            end
            
            -- ANTI STUN MECHANIC RUNNER
            if _G.AntiStun and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.PlatformStand = false
                    if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
                
                for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if child:IsA("BoolValue") or child:IsA("StringValue") then
                        if child.Name:lower():find("stun") or child.Name:lower():find("ragdoll") or child.Name:lower():find("freeze") then
                            child:Destroy()
                        end
                    end
                end
            end

            if not target or not target.Character then return end
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if not myRoot or not targetRoot then return end
            
            if _G.AutoSlash then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and (targetRoot.Position - myRoot.Position).Magnitude < 28 then
                    tool:Activate()
                end
            end
            
            if _G.AnchorToPlayer then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                myRoot.Velocity = Vector3.new(0, 0, 0)
            end
            
            if _G.AutoHanging then
                targetRoot.CFrame = CFrame.new(targetRoot.Position.X, 60, targetRoot.Position.Z)
                targetRoot.Velocity = Vector3.new(0, 0, 0)
            end
            
            if _G.AutoCarry then
                targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3)
            end
        end)
    end
end)

runService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if _G.SpeedHack then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
            
            if _G.AutoCrashEngine then
                for i = 1, 300 do
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(50, 50, 50)
                    p.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    p.Parent = workspace
                end
            end
        end
    end)
end)

-- [[ SAVE MANAGERS HANDOVER ]]
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("MoonHubVD")
SaveManager:SetFolder("MoonHubVD/config")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Setting hub by Zhoihr",
    Content = "Script successfully executed!",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
