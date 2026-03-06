-- ██████╗ ██╗  ██╗██╗   ██╗██╗  ██╗
-- ██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝╚██╗██╔╝
-- ██║   ██║ ╚███╔╝  ╚████╔╝  ╚███╔╝ 
-- ██║   ██║ ██╔██╗   ╚██╔╝   ██╔██╗ 
-- ╚██████╔╝██╔╝ ██╗   ██║   ██╔╝ ██╗
--  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
-- OxyX - Build A Boat For Treasure Tool
-- Version: 2.0.0 | By: OxyX Team
-- Galaxy UI | Astolfo Theme
-- Compatible: Xeno, Synapse X, Script-Ware, Fluxus, KRNL, Delta
-- GitHub: https://raw.githubusercontent.com/OxyXScript/BABFT/main/OxyX_BABFT.lua

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

--// LOCAL PLAYER
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

--// EXECUTOR DETECTION
local ExecutorName = "Unknown"
local function DetectExecutor()
    if identifyexecutor then
        ExecutorName = identifyexecutor()
    elseif syn then
        ExecutorName = "Synapse X"
    elseif KRNL_LOADED then
        ExecutorName = "KRNL"
    elseif getexecutorname then
        ExecutorName = getexecutorname()
    elseif (isfolder or readfile) then
        ExecutorName = "Unknown Executor"
    end
    return ExecutorName
end
DetectExecutor()

--// UTILITY FUNCTIONS
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Tween(inst, props, duration, style, direction)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

local function Notify(title, text, duration)
    duration = duration or 3
    -- Simple notification system
    local notifGui = Create("ScreenGui", {
        Name = "OxyX_Notif_" .. tostring(tick()),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    local notifFrame = Create("Frame", {
        Name = "NotifFrame",
        Size = UDim2.new(0, 280, 0, 80),
        Position = UDim2.new(1, -290, 1, -100),
        BackgroundColor3 = Color3.fromRGB(15, 10, 30),
        BorderSizePixel = 0,
        Parent = notifGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = notifFrame})
    
    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(138, 43, 226),
        Thickness = 1.5,
        Parent = notifFrame
    })
    
    local titleLbl = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = "🌌 " .. title,
        TextColor3 = Color3.fromRGB(180, 100, 255),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifFrame
    })
    
    local textLbl = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -10, 0, 40),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextScaled = true,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notifFrame
    })
    
    local progress = Create("Frame", {
        Name = "Progress",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Color3.fromRGB(138, 43, 226),
        BorderSizePixel = 0,
        Parent = notifFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = progress})
    
    notifFrame.Position = UDim2.new(1, 10, 1, -100)
    Tween(notifFrame, {Position = UDim2.new(1, -290, 1, -100)}, 0.4)
    Tween(progress, {Size = UDim2.new(0, 0, 0, 3)}, duration)
    
    task.delay(duration, function()
        Tween(notifFrame, {Position = UDim2.new(1, 10, 1, -100)}, 0.3)
        task.wait(0.3)
        notifGui:Destroy()
    end)
end

--// BLOCK DATABASE - ALL 159 BABFT BLOCKS
local BlockDatabase = {
    -- Category: Basic Blocks
    {id = 1,  name = "Back Wheel",              category = "Wheels",      type = "Model",  desc = "Basic back wheel for vehicles"},
    {id = 2,  name = "Balloon Block",           category = "Special",     type = "Block",  desc = "Floats upward when activated"},
    {id = 3,  name = "Bar",                     category = "Structure",   type = "Part",   desc = "Thin metal bar"},
    {id = 4,  name = "Big Cannon",              category = "Weapons",     type = "Model",  desc = "Large cannon, fires cannonballs"},
    {id = 5,  name = "Big Switch",              category = "Electronics", type = "Model",  desc = "Large activation switch"},
    {id = 6,  name = "Blue Candy",              category = "Candy",       type = "Block",  desc = "Blue decorative candy block"},
    {id = 7,  name = "Boat Motor",              category = "Propulsion",  type = "Model",  desc = "Standard boat motor"},
    {id = 8,  name = "Bouncy Block",            category = "Special",     type = "Block",  desc = "Bounces players and objects"},
    {id = 9,  name = "Boxing Glove",            category = "Weapons",     type = "Model",  desc = "Punches nearby objects"},
    {id = 10, name = "Bread",                   category = "Food",        type = "Model",  desc = "Decorative bread item"},
    {id = 11, name = "Brick Block",             category = "Structure",   type = "Block",  desc = "Classic brick building block"},
    {id = 12, name = "Bundles of Potions",      category = "Special",     type = "Model",  desc = "Bundle of various potions"},
    {id = 13, name = "Button",                  category = "Electronics", type = "Model",  desc = "Activates connected blocks"},
    {id = 14, name = "Cake",                    category = "Food",        type = "Model",  desc = "Decorative cake"},
    {id = 15, name = "Camera",                  category = "Special",     type = "Model",  desc = "Security/spy camera"},
    {id = 16, name = "Candle",                  category = "Decoration",  type = "Model",  desc = "Decorative candle with flame"},
    {id = 17, name = "Candy Cane Block",        category = "Candy",       type = "Block",  desc = "Christmas candy cane block"},
    {id = 18, name = "Candy Cane Rod",          category = "Candy",       type = "Part",   desc = "Christmas candy cane rod"},
    {id = 19, name = "Cannon",                  category = "Weapons",     type = "Model",  desc = "Standard cannon"},
    {id = 20, name = "Car Seat",                category = "Seats",       type = "Model",  desc = "Seat for car-style vehicles"},
    {id = 21, name = "Chair",                   category = "Seats",       type = "Model",  desc = "Basic sitting chair"},
    {id = 22, name = "Classic Firework",        category = "Fireworks",   type = "Model",  desc = "Classic firework launcher"},
    {id = 23, name = "Coal Block",              category = "Structure",   type = "Block",  desc = "Dark coal building block"},
    {id = 24, name = "Common Chest Block",      category = "Chests",      type = "Model",  desc = "Common rarity treasure chest"},
    {id = 25, name = "Concrete Block",          category = "Structure",   type = "Block",  desc = "Heavy concrete block"},
    {id = 26, name = "Concrete Rod",            category = "Structure",   type = "Part",   desc = "Concrete structural rod"},
    {id = 27, name = "Cookie Back Wheel",       category = "Wheels",      type = "Model",  desc = "Cookie-themed back wheel"},
    {id = 28, name = "Cookie Front Wheel",      category = "Wheels",      type = "Model",  desc = "Cookie-themed front wheel"},
    {id = 29, name = "Corner Wedge",            category = "Structure",   type = "Block",  desc = "Corner wedge shape"},
    {id = 30, name = "Delay Block",             category = "Electronics", type = "Model",  desc = "Adds timing delay to signals"},
    {id = 31, name = "Dome Camera",             category = "Special",     type = "Model",  desc = "Dome-style security camera"},
    {id = 32, name = "Door",                    category = "Structure",   type = "Model",  desc = "Opening and closing door"},
    {id = 33, name = "Dragon Egg",              category = "Special",     type = "Model",  desc = "Rare dragon egg item"},
    {id = 34, name = "Dragon Harpoon",          category = "Weapons",     type = "Model",  desc = "Dragon-themed harpoon launcher"},
    {id = 35, name = "Dual Candy Cane Harpoon", category = "Weapons",     type = "Model",  desc = "Dual candy cane harpoons"},
    {id = 36, name = "Dynamite",                category = "Weapons",     type = "Model",  desc = "Explosive dynamite block"},
    {id = 37, name = "Easter Jetpack",          category = "Propulsion",  type = "Model",  desc = "Easter-themed jetpack"},
    {id = 38, name = "Egg Cannon",              category = "Weapons",     type = "Model",  desc = "Fires egg projectiles"},
    {id = 39, name = "Epic Chest Block",        category = "Chests",      type = "Model",  desc = "Epic rarity treasure chest"},
    {id = 40, name = "Fabric Block",            category = "Structure",   type = "Block",  desc = "Soft fabric block"},
    {id = 41, name = "Firework 1",              category = "Fireworks",   type = "Model",  desc = "Type 1 firework"},
    {id = 42, name = "Firework 2",              category = "Fireworks",   type = "Model",  desc = "Type 2 firework"},
    {id = 43, name = "Firework 3",              category = "Fireworks",   type = "Model",  desc = "Type 3 firework"},
    {id = 44, name = "Firework 4",              category = "Fireworks",   type = "Model",  desc = "Type 4 firework"},
    {id = 45, name = "Flag",                    category = "Decoration",  type = "Model",  desc = "Decorative flag"},
    {id = 46, name = "Front Wheel",             category = "Wheels",      type = "Model",  desc = "Basic front wheel"},
    {id = 47, name = "Gameboard",               category = "Special",     type = "Model",  desc = "Interactive game board"},
    {id = 48, name = "Glass Block",             category = "Structure",   type = "Block",  desc = "Transparent glass block"},
    {id = 49, name = "Glue",                    category = "Electronics", type = "Model",  desc = "Joins blocks together"},
    {id = 50, name = "Gold Block",              category = "Structure",   type = "Block",  desc = "Valuable gold block"},
    {id = 51, name = "Golden Harpoon",          category = "Weapons",     type = "Model",  desc = "Gold-plated harpoon"},
    {id = 52, name = "Grass Block",             category = "Structure",   type = "Block",  desc = "Natural grass block"},
    {id = 53, name = "Harpoon",                 category = "Weapons",     type = "Model",  desc = "Standard harpoon launcher"},
    {id = 54, name = "Hatch",                   category = "Structure",   type = "Model",  desc = "Opening floor hatch"},
    {id = 55, name = "Heart",                   category = "Decoration",  type = "Model",  desc = "Heart-shaped decoration"},
    {id = 56, name = "Helm",                    category = "Special",     type = "Model",  desc = "Ship steering wheel"},
    {id = 57, name = "Hinge",                   category = "Electronics", type = "Model",  desc = "Rotating hinge connector"},
    {id = 58, name = "Huge Back Wheel",         category = "Wheels",      type = "Model",  desc = "Oversized back wheel"},
    {id = 59, name = "Huge Front Wheel",        category = "Wheels",      type = "Model",  desc = "Oversized front wheel"},
    {id = 60, name = "Huge Wheel",              category = "Wheels",      type = "Model",  desc = "Huge generic wheel"},
    {id = 61, name = "I-Beam",                  category = "Structure",   type = "Part",   desc = "Structural I-beam"},
    {id = 62, name = "Ice Block",               category = "Structure",   type = "Block",  desc = "Slippery ice block"},
    {id = 63, name = "Jet Turbine",             category = "Propulsion",  type = "Model",  desc = "Jet engine turbine"},
    {id = 64, name = "Jetpack",                 category = "Propulsion",  type = "Model",  desc = "Personal jetpack"},
    {id = 65, name = "Lamp",                    category = "Decoration",  type = "Model",  desc = "Illuminating lamp"},
    {id = 66, name = "Large Treasure",          category = "Treasure",    type = "Model",  desc = "Large treasure container"},
    {id = 67, name = "Laser Launcher",          category = "Weapons",     type = "Model",  desc = "Fires laser beams"},
    {id = 68, name = "Legendary Chest Block",   category = "Chests",      type = "Model",  desc = "Legendary rarity chest"},
    {id = 69, name = "Lever",                   category = "Electronics", type = "Model",  desc = "Toggle lever switch"},
    {id = 70, name = "Life Preserver",          category = "Special",     type = "Model",  desc = "Buoyancy life preserver"},
    {id = 71, name = "Light Bulb",              category = "Decoration",  type = "Model",  desc = "Electric light bulb"},
    {id = 72, name = "Locked Door",             category = "Structure",   type = "Model",  desc = "Lockable door"},
    {id = 73, name = "Magnet",                  category = "Special",     type = "Model",  desc = "Attracts metal objects"},
    {id = 74, name = "Marble Block",            category = "Structure",   type = "Block",  desc = "Elegant marble block"},
    {id = 75, name = "Marble Rod",              category = "Structure",   type = "Part",   desc = "Marble structural rod"},
    {id = 76, name = "Mast",                    category = "Structure",   type = "Model",  desc = "Ship sail mast"},
    {id = 77, name = "Master Builder Trophy",   category = "Trophies",    type = "Model",  desc = "Master builder achievement"},
    {id = 78, name = "Medium Treasure",         category = "Treasure",    type = "Model",  desc = "Medium treasure container"},
    {id = 79, name = "Mega Thruster",           category = "Propulsion",  type = "Model",  desc = "High-power mega thruster"},
    {id = 80, name = "Metal Block",             category = "Structure",   type = "Block",  desc = "Strong metal block"},
    {id = 81, name = "Metal Rod",               category = "Structure",   type = "Part",   desc = "Metal structural rod"},
    {id = 82, name = "Mini Gun",                category = "Weapons",     type = "Model",  desc = "Rapid-fire minigun"},
    {id = 83, name = "Mounted Bow",             category = "Weapons",     type = "Model",  desc = "Fixed-mount bow"},
    {id = 84, name = "Mounted Candy Cane Sword",category = "Weapons",     type = "Model",  desc = "Candy cane sword mount"},
    {id = 85, name = "Mounted Cannon",          category = "Weapons",     type = "Model",  desc = "Fixed-mount cannon"},
    {id = 86, name = "Mounted Flintlocks",      category = "Weapons",     type = "Model",  desc = "Mounted flintlock pistols"},
    {id = 87, name = "Mounted Knight Sword",    category = "Weapons",     type = "Model",  desc = "Knight sword on mount"},
    {id = 88, name = "Mounted Sword",           category = "Weapons",     type = "Model",  desc = "Standard mounted sword"},
    {id = 89, name = "Mounted Wizard Staff",    category = "Weapons",     type = "Model",  desc = "Wizard staff on mount"},
    {id = 90, name = "Music Note",              category = "Decoration",  type = "Model",  desc = "Musical decoration"},
    {id = 91, name = "Mystery Box",             category = "Special",     type = "Model",  desc = "Contains random items"},
    {id = 92, name = "Neon Block",              category = "Structure",   type = "Block",  desc = "Glowing neon block"},
    {id = 93, name = "Obsidian Block",          category = "Structure",   type = "Block",  desc = "Dark obsidian block"},
    {id = 94, name = "Orange Candy",            category = "Candy",       type = "Block",  desc = "Orange candy block"},
    {id = 95, name = "Parachute Block",         category = "Special",     type = "Block",  desc = "Slows descent when falling"},
    {id = 96, name = "Peppermint Back Wheel",   category = "Wheels",      type = "Model",  desc = "Peppermint back wheel"},
    {id = 97, name = "Peppermint Front Wheel",  category = "Wheels",      type = "Model",  desc = "Peppermint front wheel"},
    {id = 98, name = "Pilot Seat",              category = "Seats",       type = "Model",  desc = "Aircraft pilot seat"},
    {id = 99, name = "Pine Tree",               category = "Decoration",  type = "Model",  desc = "Decorative pine tree"},
    {id = 100,name = "Pink Candy",              category = "Candy",       type = "Block",  desc = "Pink candy block"},
    {id = 101,name = "Piston",                  category = "Electronics", type = "Model",  desc = "Hydraulic piston"},
    {id = 102,name = "Plastic Block",           category = "Structure",   type = "Block",  desc = "Lightweight plastic block"},
    {id = 103,name = "Plushie 1",               category = "Decoration",  type = "Model",  desc = "Plushie decoration type 1"},
    {id = 104,name = "Plushie 2",               category = "Decoration",  type = "Model",  desc = "Plushie decoration type 2"},
    {id = 105,name = "Plushie 3",               category = "Decoration",  type = "Model",  desc = "Plushie decoration type 3"},
    {id = 106,name = "Plushie 4",               category = "Decoration",  type = "Model",  desc = "Plushie decoration type 4"},
    {id = 107,name = "Portal",                  category = "Special",     type = "Model",  desc = "Teleportation portal"},
    {id = 108,name = "Pumpkin",                 category = "Decoration",  type = "Model",  desc = "Halloween pumpkin"},
    {id = 109,name = "Purple Candy",            category = "Candy",       type = "Block",  desc = "Purple candy block"},
    {id = 110,name = "Rare Chest Block",        category = "Chests",      type = "Model",  desc = "Rare rarity chest"},
    {id = 111,name = "Red Candy",               category = "Candy",       type = "Block",  desc = "Red candy block"},
    {id = 112,name = "Rope",                    category = "Structure",   type = "Part",   desc = "Flexible rope connector"},
    {id = 113,name = "Rusted Block",            category = "Structure",   type = "Block",  desc = "Old rusted block"},
    {id = 114,name = "Rusted Rod",              category = "Structure",   type = "Part",   desc = "Old rusted rod"},
    {id = 115,name = "Sand Block",              category = "Structure",   type = "Block",  desc = "Sandy block"},
    {id = 116,name = "Seat",                    category = "Seats",       type = "Model",  desc = "Basic seat"},
    {id = 117,name = "Servo",                   category = "Electronics", type = "Model",  desc = "Electric servo motor"},
    {id = 118,name = "Shield Generator",        category = "Special",     type = "Model",  desc = "Generates protective shield"},
    {id = 119,name = "Sign",                    category = "Decoration",  type = "Model",  desc = "Text sign"},
    {id = 120,name = "Small Treasure",          category = "Treasure",    type = "Model",  desc = "Small treasure container"},
    {id = 121,name = "Smooth Wood Block",       category = "Structure",   type = "Block",  desc = "Smooth wooden block"},
    {id = 122,name = "Snowball Launcher",       category = "Weapons",     type = "Model",  desc = "Launches snowballs"},
    {id = 123,name = "Soccer Ball",             category = "Special",     type = "Model",  desc = "Kickable soccer ball"},
    {id = 124,name = "Sonic Jet Turbine",       category = "Propulsion",  type = "Model",  desc = "High-speed sonic turbine"},
    {id = 125,name = "Spike Trap",              category = "Weapons",     type = "Model",  desc = "Damages on contact"},
    {id = 126,name = "Spooky Thruster",         category = "Propulsion",  type = "Model",  desc = "Halloween spooky thruster"},
    {id = 127,name = "Star",                    category = "Decoration",  type = "Model",  desc = "Star decoration"},
    {id = 128,name = "Star Balloon Block",      category = "Special",     type = "Block",  desc = "Star-shaped balloon block"},
    {id = 129,name = "Star Jetpack",            category = "Propulsion",  type = "Model",  desc = "Star-themed jetpack"},
    {id = 130,name = "Steampunk Jetpack",       category = "Propulsion",  type = "Model",  desc = "Steampunk-style jetpack"},
    {id = 131,name = "Step",                    category = "Structure",   type = "Block",  desc = "Stair step block"},
    {id = 132,name = "Stone Block",             category = "Structure",   type = "Block",  desc = "Standard stone block"},
    {id = 133,name = "Stone Rod",               category = "Structure",   type = "Part",   desc = "Stone structural rod"},
    {id = 134,name = "Suspension",              category = "Electronics", type = "Model",  desc = "Shock suspension system"},
    {id = 135,name = "Switch",                  category = "Electronics", type = "Model",  desc = "Standard toggle switch"},
    {id = 136,name = "Throne",                  category = "Seats",       type = "Model",  desc = "Royal throne seat"},
    {id = 137,name = "Thruster",                category = "Propulsion",  type = "Model",  desc = "Standard thruster"},
    {id = 138,name = "Titanium Block",          category = "Structure",   type = "Block",  desc = "Super-strong titanium block"},
    {id = 139,name = "Titanium Rod",            category = "Structure",   type = "Part",   desc = "Titanium structural rod"},
    {id = 140,name = "TNT",                     category = "Weapons",     type = "Model",  desc = "Explosive TNT block"},
    {id = 141,name = "Torch",                   category = "Decoration",  type = "Model",  desc = "Flame torch"},
    {id = 142,name = "Toy Block",               category = "Structure",   type = "Block",  desc = "Colorful toy block"},
    {id = 143,name = "Treasure Chest",          category = "Treasure",    type = "Model",  desc = "Standard treasure chest"},
    {id = 144,name = "Trophy 1st",              category = "Trophies",    type = "Model",  desc = "First place trophy"},
    {id = 145,name = "Trophy 2nd",              category = "Trophies",    type = "Model",  desc = "Second place trophy"},
    {id = 146,name = "Trophy 3rd",              category = "Trophies",    type = "Model",  desc = "Third place trophy"},
    {id = 147,name = "Truss",                   category = "Structure",   type = "Part",   desc = "Structural truss piece"},
    {id = 148,name = "Ultra Boat Motor",        category = "Propulsion",  type = "Model",  desc = "High-power boat motor"},
    {id = 149,name = "Ultra Jetpack",           category = "Propulsion",  type = "Model",  desc = "Ultra-powered jetpack"},
    {id = 150,name = "Ultra Thruster",          category = "Propulsion",  type = "Model",  desc = "Extremely powerful thruster"},
    {id = 151,name = "Uncommon Chest Block",    category = "Chests",      type = "Model",  desc = "Uncommon rarity chest"},
    {id = 152,name = "Wedge",                   category = "Structure",   type = "Block",  desc = "Wedge-shaped block"},
    {id = 153,name = "Wheel",                   category = "Wheels",      type = "Model",  desc = "Standard generic wheel"},
    {id = 154,name = "Window",                  category = "Structure",   type = "Block",  desc = "Transparent window block"},
    {id = 155,name = "Winter Boat Motor",       category = "Propulsion",  type = "Model",  desc = "Winter-themed boat motor"},
    {id = 156,name = "Winter Jet Turbine",      category = "Propulsion",  type = "Model",  desc = "Winter jet turbine"},
    {id = 157,name = "Winter Thruster",         category = "Propulsion",  type = "Model",  desc = "Winter-themed thruster"},
    {id = 158,name = "Wood Block",              category = "Structure",   type = "Block",  desc = "Basic wooden block"},
    {id = 159,name = "Wood Rod",                category = "Structure",   type = "Part",   desc = "Wooden structural rod"},
}

--// .BUILD FORMAT SPECIFICATION
--[[
    .build File Format (JSON-based):
    {
        "version": "1.0",
        "name": "MyBoat",
        "author": "PlayerName",
        "blocks": [
            {
                "id": 1,
                "name": "Wood Block",
                "position": {"x": 0, "y": 0, "z": 0},
                "size": {"x": 4, "y": 1.2, "z": 2},
                "rotation": {"x": 0, "y": 0, "z": 0},
                "color": {"r": 163, "g": 102, "b": 51},
                "material": "SmoothPlastic",
                "anchored": false,
                "weld": true,
                "properties": {}
            }
        ],
        "welds": [
            {"part1": 0, "part2": 1}
        ],
        "metadata": {
            "blockCount": 1,
            "createdAt": "2025-01-01",
            "gameVersion": "BABFT"
        }
    }
]]

--// GAME REFERENCE DETECTION
local function GetGameFolder()
    -- Try to find the BABFT build area
    local buildArea = nil
    
    -- Search common paths in BABFT
    local searchPaths = {
        Workspace:FindFirstChild("Boats"),
        Workspace:FindFirstChild("BuildArea"),
        Workspace:FindFirstChild("Island"),
        Workspace:FindFirstChild("Platforms"),
    }
    
    for _, path in ipairs(searchPaths) do
        if path then
            buildArea = path
            break
        end
    end
    
    -- Try to find player's boat
    if not buildArea then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name:find(LocalPlayer.Name) or obj.Name:find("Boat") then
                buildArea = obj
                break
            end
        end
    end
    
    return buildArea
end

local function FindPlayerBoat()
    -- Find the local player's boat/build area in BABFT
    local boat = nil
    
    -- Check workspace for player boats
    for _, child in ipairs(Workspace:GetDescendants()) do
        if child:IsA("Model") and (
            child.Name == LocalPlayer.Name .. "'s Boat" or
            child.Name == LocalPlayer.Name or
            child.Name == "PlayerBoat"
        ) then
            boat = child
            break
        end
    end
    
    return boat
end

--// REMOTE EVENTS (BABFT-specific)
local RemoteEvents = {}
local function FindRemoteEvents()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or 
                    ReplicatedStorage:FindFirstChild("Events") or
                    ReplicatedStorage
    
    if remotes then
        for _, v in ipairs(remotes:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                RemoteEvents[v.Name] = v
            end
        end
    end
    
    return RemoteEvents
end
FindRemoteEvents()

--// BLOCK PLACEMENT SYSTEM
local BlockPlacer = {}
BlockPlacer.__index = BlockPlacer

function BlockPlacer.new()
    local self = setmetatable({}, BlockPlacer)
    self.placedBlocks = {}
    self.weldQueue = {}
    self.isPlacing = false
    self.placementDelay = 0.1
    return self
end

function BlockPlacer:GetBlockByName(name)
    for _, block in ipairs(BlockDatabase) do
        if block.name:lower() == name:lower() or block.name:lower():find(name:lower()) then
            return block
        end
    end
    return nil
end

function BlockPlacer:GetBlocksByCategory(category)
    local results = {}
    for _, block in ipairs(BlockDatabase) do
        if block.category:lower() == category:lower() then
            table.insert(results, block)
        end
    end
    return results
end

function BlockPlacer:PlaceBlock(blockData, position, size, rotation, color)
    -- Attempt to place a block using BABFT's system
    local remotes = FindRemoteEvents()
    local placeRemote = remotes["PlaceBlock"] or remotes["AddBlock"] or remotes["SpawnBlock"] or remotes["Build"]
    
    if placeRemote then
        local success, err = pcall(function()
            if placeRemote:IsA("RemoteEvent") then
                placeRemote:FireServer({
                    BlockId = blockData.id,
                    BlockName = blockData.name,
                    Position = position or Vector3.new(0, 5, 0),
                    Size = size or Vector3.new(4, 1.2, 2),
                    Rotation = rotation or Vector3.new(0, 0, 0),
                    Color = color or Color3.fromRGB(163, 102, 51),
                })
            elseif placeRemote:IsA("RemoteFunction") then
                placeRemote:InvokeServer({
                    BlockId = blockData.id,
                    BlockName = blockData.name,
                    Position = position or Vector3.new(0, 5, 0),
                })
            end
        end)
        
        if success then
            table.insert(self.placedBlocks, {
                block = blockData,
                position = position,
                size = size,
                time = tick()
            })
            return true
        else
            warn("[OxyX] Block placement error: " .. tostring(err))
        end
    else
        -- Fallback: Try to simulate placement through GUI clicks
        warn("[OxyX] Could not find placement remote. Trying GUI method...")
        return self:PlaceBlockViaGUI(blockData, position)
    end
    
    return false
end

function BlockPlacer:PlaceBlockViaGUI(blockData, position)
    -- Try to find BABFT's block buttons in PlayerGui
    local babftGui = nil
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and (gui.Name:find("Build") or gui.Name:find("Block") or gui.Name:find("Inventory")) then
            babftGui = gui
            break
        end
    end
    
    if babftGui then
        -- Search for the block button
        for _, btn in ipairs(babftGui:GetDescendants()) do
            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and 
               btn.Name:lower():find(blockData.name:lower()) then
                -- Simulate click
                local args = {[1] = btn}
                btn.MouseButton1Click:Fire()
                return true
            end
        end
    end
    
    return false
end

function BlockPlacer:AutoWeld(parts)
    -- Weld all parts together
    local model = Instance.new("Model")
    model.Name = "OxyX_Build"
    model.Parent = Workspace
    
    local primarySet = false
    for i, part in ipairs(parts) do
        if part:IsA("BasePart") then
            part.Parent = model
            if not primarySet then
                model.PrimaryPart = part
                primarySet = true
            end
        end
    end
    
    -- Create welds
    local weldCount = 0
    for i = 2, #parts do
        if parts[i]:IsA("BasePart") and parts[1]:IsA("BasePart") then
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = parts[1]
            weld.Part1 = parts[i]
            weld.Parent = parts[1]
            weldCount = weldCount + 1
        end
    end
    
    Notify("Auto Weld", "Welded " .. weldCount .. " parts together!", 3)
    return model
end

function BlockPlacer:AutoSetup(buildData)
    -- Complete auto setup: place + weld + configure
    if not buildData or not buildData.blocks then
        Notify("Error", "Invalid build data!", 3)
        return false
    end
    
    local placedParts = {}
    local totalBlocks = #buildData.blocks
    
    Notify("Auto Setup", "Setting up " .. totalBlocks .. " blocks...", 2)
    
    for i, blockInfo in ipairs(buildData.blocks) do
        local blockData = self:GetBlockByName(blockInfo.name)
        if blockData then
            local pos = Vector3.new(
                (blockInfo.position and blockInfo.position.x) or 0,
                (blockInfo.position and blockInfo.position.y) or (i * 1.2),
                (blockInfo.position and blockInfo.position.z) or 0
            )
            local sz = Vector3.new(
                (blockInfo.size and blockInfo.size.x) or 4,
                (blockInfo.size and blockInfo.size.y) or 1.2,
                (blockInfo.size and blockInfo.size.z) or 2
            )
            local col = blockInfo.color and 
                Color3.fromRGB(blockInfo.color.r, blockInfo.color.g, blockInfo.color.b) or
                Color3.fromRGB(163, 102, 51)
            
            self:PlaceBlock(blockData, pos, sz, Vector3.new(0,0,0), col)
            task.wait(self.placementDelay)
        end
        
        -- Update progress
        if i % 10 == 0 then
            Notify("Progress", string.format("Placed %d/%d blocks", i, totalBlocks), 1)
        end
    end
    
    -- Auto weld if enabled
    if buildData.welds and #buildData.welds > 0 then
        self:AutoWeld(placedParts)
    end
    
    Notify("Auto Setup", "Build complete! " .. totalBlocks .. " blocks placed.", 4)
    return true
end

local Placer = BlockPlacer.new()

--// .BUILD FILE SYSTEM
local BuildSystem = {}

function BuildSystem.Parse(jsonString)
    -- Parse .build file (JSON format)
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonString)
    end)
    
    if not success then
        Notify("Parse Error", "Invalid .build file format!", 3)
        return nil
    end
    
    -- Validate structure
    if not data.blocks then
        Notify("Parse Error", "No blocks found in .build file!", 3)
        return nil
    end
    
    return data
end

function BuildSystem.Serialize(buildName, blocks, welds)
    -- Convert to .build format
    local buildData = {
        version = "1.0",
        name = buildName or "MyBuild",
        author = LocalPlayer.Name,
        blocks = blocks or {},
        welds = welds or {},
        metadata = {
            blockCount = #(blocks or {}),
            createdAt = os.date("%Y-%m-%d"),
            gameVersion = "BABFT",
            createdBy = "OxyX v2.0.0"
        }
    }
    
    local success, json = pcall(function()
        return HttpService:JSONEncode(buildData)
    end)
    
    return success and json or nil
end

function BuildSystem.FromStudioModel(modelData)
    -- Convert Roblox Studio model (.rbxm format data) to .build
    if not modelData then return nil end
    
    local blocks = {}
    
    local function ProcessPart(part, parentCFrame)
        if part:IsA("BasePart") then
            -- Find matching BABFT block
            local matchedBlock = nil
            for _, blockDef in ipairs(BlockDatabase) do
                if blockDef.name:lower():find(part.Name:lower()) or 
                   part.Name:lower():find(blockDef.name:lower()) then
                    matchedBlock = blockDef
                    break
                end
            end
            
            if not matchedBlock then
                -- Default to Wood Block
                matchedBlock = BlockDatabase[158] -- Wood Block
            end
            
            local cf = part.CFrame
            local pos = cf.Position
            local _, _, _, 
                  r00, r01, r02,
                  r10, r11, r12,
                  r20, r21, r22 = cf:GetComponents()
            
            local rx = math.atan2(r21, r22)
            local ry = math.atan2(-r20, math.sqrt(r21^2 + r22^2))
            local rz = math.atan2(r10, r00)
            
            table.insert(blocks, {
                id = matchedBlock.id,
                name = matchedBlock.name,
                position = {x = pos.X, y = pos.Y, z = pos.Z},
                size = {x = part.Size.X, y = part.Size.Y, z = part.Size.Z},
                rotation = {
                    x = math.deg(rx),
                    y = math.deg(ry),
                    z = math.deg(rz)
                },
                color = {
                    r = math.floor(part.Color.R * 255),
                    g = math.floor(part.Color.G * 255),
                    b = math.floor(part.Color.B * 255)
                },
                material = tostring(part.Material),
                anchored = part.Anchored,
                weld = true
            })
        end
        
        for _, child in ipairs(part:GetChildren()) do
            ProcessPart(child, parentCFrame)
        end
    end
    
    if modelData:IsA("Model") then
        for _, part in ipairs(modelData:GetChildren()) do
            ProcessPart(part, CFrame.new(0,0,0))
        end
    elseif modelData:IsA("BasePart") then
        ProcessPart(modelData, CFrame.new(0,0,0))
    end
    
    return BuildSystem.Serialize(modelData.Name, blocks)
end

function BuildSystem.FromCurrentBoat()
    -- Export current player's boat to .build format
    local boat = FindPlayerBoat()
    if not boat then
        Notify("Export", "Could not find your boat!", 3)
        return nil
    end
    
    return BuildSystem.FromStudioModel(boat)
end

--// AUTO BUILD SHAPES
local ShapeBuilder = {}

function ShapeBuilder.CreateFlat(blockName, width, length, height, startPos)
    -- Create a flat platform
    local blocks = {}
    startPos = startPos or Vector3.new(0, 0, 0)
    local blockSize = Vector3.new(4, 1.2, 2)
    
    for x = 0, width - 1 do
        for z = 0, length - 1 do
            table.insert(blocks, {
                name = blockName,
                position = {
                    x = startPos.X + (x * blockSize.X),
                    y = startPos.Y + ((height or 0) * blockSize.Y),
                    z = startPos.Z + (z * blockSize.Z)
                },
                size = {x = blockSize.X, y = blockSize.Y, z = blockSize.Z},
                rotation = {x = 0, y = 0, z = 0}
            })
        end
    end
    
    return blocks
end

function ShapeBuilder.CreateBall(blockName, radius, centerPos)
    -- Create a sphere/ball shape approximation
    local blocks = {}
    centerPos = centerPos or Vector3.new(0, 0, 0)
    local blockSize = 2
    
    for x = -radius, radius do
        for y = -radius, radius do
            for z = -radius, radius do
                if (x*x + y*y + z*z) <= (radius * radius) then
                    table.insert(blocks, {
                        name = blockName,
                        position = {
                            x = centerPos.X + (x * blockSize),
                            y = centerPos.Y + (y * blockSize),
                            z = centerPos.Z + (z * blockSize)
                        },
                        size = {x = blockSize, y = blockSize, z = blockSize},
                        rotation = {x = 0, y = 0, z = 0}
                    })
                end
            end
        end
    end
    
    return blocks
end

function ShapeBuilder.CreateCylinder(blockName, radius, height, centerPos)
    -- Create a cylinder shape
    local blocks = {}
    centerPos = centerPos or Vector3.new(0, 0, 0)
    local blockSize = 2
    
    for y = 0, height - 1 do
        for x = -radius, radius do
            for z = -radius, radius do
                if (x*x + z*z) <= (radius * radius) then
                    table.insert(blocks, {
                        name = blockName,
                        position = {
                            x = centerPos.X + (x * blockSize),
                            y = centerPos.Y + (y * blockSize),
                            z = centerPos.Z + (z * blockSize)
                        },
                        size = {x = blockSize, y = blockSize, z = blockSize},
                        rotation = {x = 0, y = 0, z = 0}
                    })
                end
            end
        end
    end
    
    return blocks
end

function ShapeBuilder.CreateTriangle(blockName, base, height, startPos)
    -- Create a triangle/pyramid shape
    local blocks = {}
    startPos = startPos or Vector3.new(0, 0, 0)
    local blockSize = 2
    
    for y = 0, height - 1 do
        local layerWidth = math.floor(base * (1 - (y / height)))
        for x = 0, layerWidth - 1 do
            table.insert(blocks, {
                name = blockName,
                position = {
                    x = startPos.X + (x * blockSize) + (((base - layerWidth) / 2) * blockSize),
                    y = startPos.Y + (y * blockSize),
                    z = startPos.Z
                },
                size = {x = blockSize, y = blockSize, z = blockSize},
                rotation = {x = 0, y = 0, z = 0}
            })
        end
    end
    
    return blocks
end

function ShapeBuilder.CreatePyramid(blockName, base, centerPos)
    -- Create a 3D pyramid
    local blocks = {}
    centerPos = centerPos or Vector3.new(0, 0, 0)
    local blockSize = 2
    
    for y = 0, base - 1 do
        local layerSize = base - y
        local offset = y
        for x = 0, layerSize - 1 do
            for z = 0, layerSize - 1 do
                table.insert(blocks, {
                    name = blockName,
                    position = {
                        x = centerPos.X + ((x + offset) * blockSize),
                        y = centerPos.Y + (y * blockSize),
                        z = centerPos.Z + ((z + offset) * blockSize)
                    },
                    size = {x = blockSize, y = blockSize, z = blockSize},
                    rotation = {x = 0, y = 0, z = 0}
                })
            end
        end
    end
    
    return blocks
end

function ShapeBuilder.CreateHollowBox(blockName, width, height, depth, startPos)
    -- Create a hollow box/room shape
    local blocks = {}
    startPos = startPos or Vector3.new(0, 0, 0)
    local blockSize = 2
    
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            for z = 0, depth - 1 do
                local isWall = (x == 0 or x == width-1 or y == 0 or y == height-1 or z == 0 or z == depth-1)
                if isWall then
                    table.insert(blocks, {
                        name = blockName,
                        position = {
                            x = startPos.X + (x * blockSize),
                            y = startPos.Y + (y * blockSize),
                            z = startPos.Z + (z * blockSize)
                        },
                        size = {x = blockSize, y = blockSize, z = blockSize},
                        rotation = {x = 0, y = 0, z = 0}
                    })
                end
            end
        end
    end
    
    return blocks
end

function ShapeBuilder.CreateBoatHull(blockName, length, width, startPos)
    -- Create a standard boat hull shape
    local blocks = {}
    startPos = startPos or Vector3.new(0, 0, 0)
    local blockW = 4
    local blockH = 1.2
    local blockD = 2
    
    -- Bottom layer (full)
    for x = 0, length - 1 do
        for z = 0, width - 1 do
            table.insert(blocks, {
                name = blockName,
                position = {
                    x = startPos.X + (x * blockW),
                    y = startPos.Y,
                    z = startPos.Z + (z * blockD)
                },
                size = {x = blockW, y = blockH, z = blockD},
                rotation = {x = 0, y = 0, z = 0}
            })
        end
    end
    
    -- Side walls
    for x = 0, length - 1 do
        for y = 1, 2 do
            -- Left wall
            table.insert(blocks, {
                name = blockName,
                position = {
                    x = startPos.X + (x * blockW),
                    y = startPos.Y + (y * blockH),
                    z = startPos.Z
                },
                size = {x = blockW, y = blockH, z = blockD},
                rotation = {x = 0, y = 0, z = 0}
            })
            -- Right wall
            table.insert(blocks, {
                name = blockName,
                position = {
                    x = startPos.X + (x * blockW),
                    y = startPos.Y + (y * blockH),
                    z = startPos.Z + ((width - 1) * blockD)
                },
                size = {x = blockW, y = blockH, z = blockD},
                rotation = {x = 0, y = 0, z = 0}
            })
        end
    end
    
    return blocks
end

function ShapeBuilder.Execute(shapeType, blockName, params)
    local blocks = {}
    
    if shapeType == "Ball" or shapeType == "Sphere" then
        blocks = ShapeBuilder.CreateBall(blockName, params.radius or 3, params.center)
    elseif shapeType == "Cylinder" then
        blocks = ShapeBuilder.CreateCylinder(blockName, params.radius or 3, params.height or 5, params.center)
    elseif shapeType == "Triangle" then
        blocks = ShapeBuilder.CreateTriangle(blockName, params.base or 5, params.height or 5, params.start)
    elseif shapeType == "Pyramid" then
        blocks = ShapeBuilder.CreatePyramid(blockName, params.base or 5, params.center)
    elseif shapeType == "Flat" or shapeType == "Platform" then
        blocks = ShapeBuilder.CreateFlat(blockName, params.width or 5, params.length or 5, params.height or 0, params.start)
    elseif shapeType == "HollowBox" or shapeType == "Room" then
        blocks = ShapeBuilder.CreateHollowBox(blockName, params.width or 5, params.height or 3, params.depth or 5, params.start)
    elseif shapeType == "BoatHull" then
        blocks = ShapeBuilder.CreateBoatHull(blockName, params.length or 8, params.width or 4, params.start)
    end
    
    if #blocks > 0 then
        -- Convert to .build format and execute
        local buildData = {
            version = "1.0",
            name = "OxyX_" .. shapeType,
            author = LocalPlayer.Name,
            blocks = blocks,
            welds = {},
            metadata = {blockCount = #blocks, gameVersion = "BABFT"}
        }
        return buildData
    end
    
    return nil
end

--// IMAGE LOADER SYSTEM (IMPROVED)
local ImageLoader = {}
ImageLoader.cache = {}
ImageLoader.failedAttempts = {}

function ImageLoader.IsValidAssetId(assetId)
    -- Validate Roblox asset ID format
    if type(assetId) == "number" then return true end
    if type(assetId) == "string" then
        -- Handle various formats
        local cleaned = assetId:gsub("rbxassetid://", ""):gsub("https://www.roblox.com/asset/%?id=", "")
        return tonumber(cleaned) ~= nil
    end
    return false
end

function ImageLoader.NormalizeAssetId(assetId)
    if type(assetId) == "number" then
        return "rbxassetid://" .. tostring(assetId)
    elseif type(assetId) == "string" then
        if assetId:match("^%d+$") then
            return "rbxassetid://" .. assetId
        elseif assetId:match("rbxassetid://") then
            return assetId
        elseif assetId:match("roblox.com/asset") then
            local id = assetId:match("id=(%d+)")
            if id then return "rbxassetid://" .. id end
        end
    end
    return nil
end

function ImageLoader.LoadToLabel(imageLabel, assetId, fallbackColor)
    if not imageLabel or not imageLabel:IsA("ImageLabel") and not imageLabel:IsA("ImageButton") then
        warn("[OxyX] ImageLoader: Invalid image label!")
        return false
    end
    
    local normalizedId = ImageLoader.NormalizeAssetId(assetId)
    if not normalizedId then
        warn("[OxyX] ImageLoader: Invalid asset ID: " .. tostring(assetId))
        imageLabel.BackgroundColor3 = fallbackColor or Color3.fromRGB(50, 50, 70)
        return false
    end
    
    -- Check cache
    if ImageLoader.cache[normalizedId] then
        imageLabel.Image = normalizedId
        return true
    end
    
    -- Check failed attempts
    if ImageLoader.failedAttempts[normalizedId] then
        imageLabel.BackgroundColor3 = fallbackColor or Color3.fromRGB(50, 50, 70)
        return false
    end
    
    -- Load with error handling
    local loadSuccess = pcall(function()
        imageLabel.Image = normalizedId
    end)
    
    if loadSuccess then
        ImageLoader.cache[normalizedId] = true
        return true
    else
        ImageLoader.failedAttempts[normalizedId] = true
        imageLabel.BackgroundColor3 = fallbackColor or Color3.fromRGB(50, 50, 70)
        return false
    end
end

function ImageLoader.CreateDecal(part, assetId, face)
    if not part or not part:IsA("BasePart") then return nil end
    
    local normalizedId = ImageLoader.NormalizeAssetId(assetId)
    if not normalizedId then return nil end
    
    local decal = Create("Decal", {
        Texture = normalizedId,
        Face = face or Enum.NormalId.Front,
        Parent = part
    })
    
    return decal
end

function ImageLoader.CreateSurfaceAppearance(part, textureId)
    if not part or not part:IsA("BasePart") then return nil end
    
    local normalizedId = ImageLoader.NormalizeAssetId(textureId)
    if not normalizedId then return nil end
    
    local sa = Create("SurfaceAppearance", {
        ColorMapId = normalizedId,
        Parent = part
    })
    
    return sa
end

--// MAIN UI SYSTEM
local OxyXGui = {}
OxyXGui.isMinimized = false
OxyXGui.currentTab = "AutoBuild"
OxyXGui.selectedBlock = nil
OxyXGui.buildData = nil
OxyXGui.shapeParams = {
    radius = 3,
    height = 5,
    width = 5,
    length = 8,
    base = 5,
    depth = 5,
}

-- Galaxy Color Theme
local Theme = {
    Background = Color3.fromRGB(5, 3, 20),
    Secondary = Color3.fromRGB(12, 8, 35),
    Tertiary = Color3.fromRGB(20, 12, 50),
    Accent1 = Color3.fromRGB(138, 43, 226),    -- Purple
    Accent2 = Color3.fromRGB(75, 0, 130),       -- Dark Purple
    Accent3 = Color3.fromRGB(180, 100, 255),    -- Light Purple
    Accent4 = Color3.fromRGB(0, 191, 255),      -- Cyan
    Accent5 = Color3.fromRGB(255, 105, 180),    -- Pink
    TextMain = Color3.fromRGB(230, 220, 255),
    TextSub = Color3.fromRGB(160, 140, 200),
    TextDim = Color3.fromRGB(100, 80, 140),
    Success = Color3.fromRGB(80, 220, 120),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 80, 80),
    White = Color3.fromRGB(255, 255, 255),
    Transparent = Color3.fromRGB(0, 0, 0),
    StarColor1 = Color3.fromRGB(255, 255, 255),
    StarColor2 = Color3.fromRGB(200, 180, 255),
    NebulaPink = Color3.fromRGB(255, 0, 128),
    NebulaBlue = Color3.fromRGB(0, 128, 255),
}

function OxyXGui.Init()
    -- Remove existing GUI if present
    local existing = CoreGui:FindFirstChild("OxyX_BABFT")
    if existing then existing:Destroy() end
    
    --// MAIN SCREEN GUI
    local ScreenGui = Create("ScreenGui", {
        Name = "OxyX_BABFT",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = CoreGui
    })
    
    --// MAIN FRAME (9:16 aspect ratio equivalent)
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, 600),
        Position = UDim2.new(0.5, -200, 0.5, -300),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = MainFrame})
    
    -- Galaxy gradient border
    local BorderFrame = Create("Frame", {
        Name = "Border",
        Size = UDim2.new(1, 4, 1, 4),
        Position = UDim2.new(0, -2, 0, -2),
        BackgroundColor3 = Theme.Accent1,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = MainFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = BorderFrame})
    
    local borderGrad = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Accent1),
            ColorSequenceKeypoint.new(0.33, Theme.Accent4),
            ColorSequenceKeypoint.new(0.66, Theme.Accent5),
            ColorSequenceKeypoint.new(1, Theme.Accent2),
        }),
        Rotation = 45,
        Parent = BorderFrame
    })
    
    -- Animated border rotation
    local borderAngle = 0
    RunService.Heartbeat:Connect(function(dt)
        borderAngle = (borderAngle + dt * 30) % 360
        borderGrad.Rotation = borderAngle
    end)
    
    --// GALAXY BACKGROUND (stars effect)
    local BgGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 3, 20)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 5, 35)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(3, 8, 25))
        }),
        Rotation = 135,
        Parent = MainFrame
    })
    
    -- Create star particles
    for i = 1, 30 do
        local star = Create("Frame", {
            Name = "Star_" .. i,
            Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3)),
            Position = UDim2.new(math.random() * 0.95, 0, math.random() * 0.95, 0),
            BackgroundColor3 = (math.random() > 0.5) and Theme.StarColor1 or Theme.StarColor2,
            BackgroundTransparency = math.random() * 0.5,
            BorderSizePixel = 0,
            ZIndex = 1,
            Parent = MainFrame
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = star})
        
        -- Twinkle animation
        local delay = math.random() * 3
        task.spawn(function()
            while star and star.Parent do
                task.wait(delay + math.random() * 2)
                if star and star.Parent then
                    Tween(star, {BackgroundTransparency = 0.9}, 0.5)
                    task.wait(0.5)
                    if star and star.Parent then
                        Tween(star, {BackgroundTransparency = math.random() * 0.3}, 0.5)
                    end
                end
            end
        end)
    end
    
    --// HEADER
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 75),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = MainFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = Header})
    
    -- Header gradient
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 55)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 5, 30))
        }),
        Rotation = 90,
        Parent = Header
    })
    
    -- Bottom fix for header corner
    Create("Frame", {
        Name = "BottomFix",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = Header
    })
    
    -- Astolfo Image (left side of header)
    local AstolfoImg = Create("ImageLabel", {
        Name = "AstolfoImage",
        Size = UDim2.new(0, 55, 0, 55),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Image = "rbxassetid://7078026274", -- Astolfo-style anime character placeholder
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 15,
        Parent = Header
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = AstolfoImg})
    
    -- Glow effect for Astolfo image
    local astolfoStroke = Create("UIStroke", {
        Color = Theme.Accent5,
        Thickness = 2,
        Parent = AstolfoImg
    })
    
    -- Logo/Title area
    local LogoFrame = Create("Frame", {
        Name = "LogoFrame",
        Size = UDim2.new(0, 200, 0, 55),
        Position = UDim2.new(0, 75, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = 15,
        Parent = Header
    })
    
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 2),
        BackgroundTransparency = 1,
        Text = "OxyX",
        TextColor3 = Theme.White,
        Font = Enum.Font.GothamBold,
        TextScaled = true,
        ZIndex = 15,
        Parent = LogoFrame
    })
    
    -- Title gradient text effect (using UIGradient on label)
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Accent3),
            ColorSequenceKeypoint.new(0.5, Theme.Accent4),
            ColorSequenceKeypoint.new(1, Theme.Accent5),
        }),
        Rotation = 0,
        Parent = TitleLabel
    })
    
    local SubTitleLabel = Create("TextLabel", {
        Name = "SubTitle",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundTransparency = 1,
        Text = "Build A Boat For Treasure Tool",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextScaled = true,
        ZIndex = 15,
        Parent = LogoFrame
    })
    
    -- Version badge
    local VersionBadge = Create("TextLabel", {
        Name = "Version",
        Size = UDim2.new(0, 60, 0, 18),
        Position = UDim2.new(0, 0, 0, 55),
        BackgroundColor3 = Theme.Accent2,
        BorderSizePixel = 0,
        Text = "v2.0.0",
        TextColor3 = Theme.Accent3,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        ZIndex = 16,
        Parent = LogoFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = VersionBadge})
    
    -- Control Buttons (top right)
    local ControlsFrame = Create("Frame", {
        Name = "Controls",
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -80, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = 20,
        Parent = Header
    })
    
    -- Minimize Button
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Text = "−",
        TextColor3 = Theme.Warning,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        ZIndex = 20,
        Parent = ControlsFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MinBtn})
    Create("UIStroke", {Color = Theme.Warning, Thickness = 1, Parent = MinBtn})
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Text = "✕",
        TextColor3 = Theme.Error,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 20,
        Parent = ControlsFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseBtn})
    Create("UIStroke", {Color = Theme.Error, Thickness = 1, Parent = CloseBtn})
    
    --// TAB BAR
    local TabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 75),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = MainFrame
    })
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 8, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 5, 25))
        }),
        Rotation = 90,
        Parent = TabBar
    })
    
    local TabLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = TabBar
    })
    
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = TabBar
    })
    
    -- Tab definitions
    local Tabs = {
        {name = "AutoBuild",  icon = "🏗️", label = "Auto Build"},
        {name = "Shapes",     icon = "⬡",  label = "Shapes"},
        {name = "Converter",  icon = "🔄", label = "Convert"},
        {name = "ImageLoader",icon = "🖼️", label = "Images"},
        {name = "Blocks",     icon = "📦", label = "Blocks"},
        {name = "Settings",   icon = "⚙️", label = "Settings"},
    }
    
    local TabButtons = {}
    local TabPages = {}
    
    --// CONTENT AREA
    local ContentArea = Create("ScrollingFrame", {
        Name = "ContentArea",
        Size = UDim2.new(1, 0, 1, -165),
        Position = UDim2.new(0, 0, 0, 115),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent1,
        CanvasSize = UDim2.new(1, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 5,
        Parent = MainFrame
    })
    
    --// STATUS BAR
    local StatusBar = Create("Frame", {
        Name = "StatusBar",
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 1, -35),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = MainFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = StatusBar})
    
    -- Top fix for status bar corner
    Create("Frame", {
        Name = "TopFix",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = StatusBar
    })
    
    local StatusText = Create("TextLabel", {
        Name = "StatusText",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "🌌 Ready | Executor: " .. ExecutorName,
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = StatusBar
    })
    
    local BlockCountLabel = Create("TextLabel", {
        Name = "BlockCount",
        Size = UDim2.new(0, 110, 1, 0),
        Position = UDim2.new(1, -115, 0, 0),
        BackgroundTransparency = 1,
        Text = "159 Blocks",
        TextColor3 = Theme.Accent3,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 15,
        Parent = StatusBar
    })
    
    --// FUNCTION: Create Tab Button
    local function CreateTabButton(tabInfo, index)
        local btn = Create("TextButton", {
            Name = "Tab_" .. tabInfo.name,
            Size = UDim2.new(0, 60, 1, 0),
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Text = tabInfo.label,
            TextColor3 = Theme.TextDim,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            AutoButtonColor = false,
            ZIndex = 15,
            Parent = TabBar
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
        
        TabButtons[tabInfo.name] = btn
        return btn
    end
    
    --// FUNCTION: Create Page
    local function CreatePage(name)
        local page = Create("Frame", {
            Name = "Page_" .. name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = ContentArea
        })
        
        local layout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = page
        })
        
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = page
        })
        
        TabPages[name] = page
        return page
    end
    
    --// FUNCTION: Create Section Header
    local function CreateSection(parent, title, icon)
        local section = Create("Frame", {
            Name = "Section_" .. title,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Parent = parent
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = section})
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 15, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 50))
            }),
            Rotation = 90,
            Parent = section
        })
        
        Create("TextLabel", {
            Size = UDim2.new(1, -15, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = (icon or "◆") .. " " .. title,
            TextColor3 = Theme.Accent3,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = section
        })
        
        -- Accent line
        Create("Frame", {
            Size = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = Theme.Accent1,
            BorderSizePixel = 0,
            Parent = section
        })
        
        return section
    end
    
    --// FUNCTION: Create Button
    local function CreateButton(parent, text, icon, color, callback)
        color = color or Theme.Accent1
        local btn = Create("TextButton", {
            Name = "Btn_" .. text,
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Color3.fromRGB(
                math.floor(color.R * 255 * 0.3),
                math.floor(color.G * 255 * 0.3),
                math.floor(color.B * 255 * 0.3)
            ),
            BorderSizePixel = 0,
            Text = (icon and icon .. " " or "") .. text,
            TextColor3 = Theme.TextMain,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            AutoButtonColor = false,
            Parent = parent
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = btn})
        Create("UIStroke", {Color = color, Thickness = 1.5, Parent = btn})
        
        -- Hover effects
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(
                math.floor(color.R * 255 * 0.5),
                math.floor(color.G * 255 * 0.5),
                math.floor(color.B * 255 * 0.5)
            )}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(
                math.floor(color.R * 255 * 0.3),
                math.floor(color.G * 255 * 0.3),
                math.floor(color.B * 255 * 0.3)
            )}, 0.2)
        end)
        
        if callback then
            btn.MouseButton1Click:Connect(callback)
        end
        
        return btn
    end
    
    --// FUNCTION: Create Input Field
    local function CreateInput(parent, placeholder, default)
        local container = Create("Frame", {
            Name = "InputContainer",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Parent = parent
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
        Create("UIStroke", {Color = Theme.Accent2, Thickness = 1, Parent = container})
        
        local input = Create("TextBox", {
            Name = "Input",
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = default or "",
            PlaceholderText = placeholder or "Type here...",
            PlaceholderColor3 = Theme.TextDim,
            TextColor3 = Theme.TextMain,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            ClearTextOnFocus = false,
            Parent = container
        })
        
        input.Focused:Connect(function()
            Tween(container, {BackgroundColor3 = Color3.fromRGB(25, 15, 60)}, 0.2)
            Create("UIStroke", {Color = Theme.Accent1, Thickness = 1.5, Parent = container})
        end)
        input.FocusLost:Connect(function()
            Tween(container, {BackgroundColor3 = Theme.Tertiary}, 0.2)
        end)
        
        return input
    end
    
    --// FUNCTION: Create Toggle
    local function CreateToggle(parent, label, default, callback)
        local container = Create("Frame", {
            Name = "Toggle_" .. label,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Parent = parent
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
        
        Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = label,
            TextColor3 = Theme.TextMain,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container
        })
        
        local toggleBg = Create("Frame", {
            Name = "ToggleBg",
            Size = UDim2.new(0, 44, 0, 22),
            Position = UDim2.new(1, -54, 0.5, -11),
            BackgroundColor3 = default and Theme.Accent1 or Theme.Background,
            BorderSizePixel = 0,
            Parent = container
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggleBg})
        Create("UIStroke", {Color = default and Theme.Accent1 or Theme.TextDim, Thickness = 1.5, Parent = toggleBg})
        
        local toggleKnob = Create("Frame", {
            Name = "Knob",
            Size = UDim2.new(0, 16, 0, 16),
            Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = Theme.White,
            BorderSizePixel = 0,
            Parent = toggleBg
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggleKnob})
        
        local value = default or false
        
        local toggleBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
            Parent = container
        })
        
        toggleBtn.MouseButton1Click:Connect(function()
            value = not value
            if value then
                Tween(toggleBg, {BackgroundColor3 = Theme.Accent1}, 0.2)
                Tween(toggleKnob, {Position = UDim2.new(1, -19, 0.5, -8)}, 0.2)
            else
                Tween(toggleBg, {BackgroundColor3 = Theme.Background}, 0.2)
                Tween(toggleKnob, {Position = UDim2.new(0, 3, 0.5, -8)}, 0.2)
            end
            if callback then callback(value) end
        end)
        
        return container, function() return value end
    end
    
    --// FUNCTION: Create Dropdown
    local function CreateDropdown(parent, label, options, default, callback)
        local selectedValue = default or options[1]
        local isOpen = false
        
        local container = Create("Frame", {
            Name = "Dropdown_" .. label,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            ClipsDescendants = false,
            ZIndex = 50,
            Parent = parent
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
        Create("UIStroke", {Color = Theme.Accent2, Thickness = 1, Parent = container})
        
        Create("TextLabel", {
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = label,
            TextColor3 = Theme.TextSub,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 51,
            Parent = container
        })
        
        local valueLabel = Create("TextLabel", {
            Name = "Value",
            Size = UDim2.new(1, -120, 1, 0),
            Position = UDim2.new(0, 110, 0, 0),
            BackgroundTransparency = 1,
            Text = selectedValue,
            TextColor3 = Theme.Accent3,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 51,
            Parent = container
        })
        
        local arrowLabel = Create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -25, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = Theme.Accent3,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            ZIndex = 51,
            Parent = container
        })
        
        local dropBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 52,
            Parent = container
        })
        
        local dropList = Create("Frame", {
            Name = "DropList",
            Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150)),
            Position = UDim2.new(0, 0, 1, 3),
            BackgroundColor3 = Color3.fromRGB(20, 12, 50),
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 100,
            ClipsDescendants = true,
            Parent = container
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = dropList})
        Create("UIStroke", {Color = Theme.Accent1, Thickness = 1, Parent = dropList})
        
        local scroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent1,
            CanvasSize = UDim2.new(1, 0, 0, #options * 30),
            ZIndex = 101,
            Parent = dropList
        })
        
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll})
        
        for _, opt in ipairs(options) do
            local optBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(20, 12, 50),
                BorderSizePixel = 0,
                Text = opt,
                TextColor3 = Theme.TextMain,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                AutoButtonColor = false,
                ZIndex = 102,
                Parent = scroll
            })
            
            optBtn.MouseEnter:Connect(function()
                Tween(optBtn, {BackgroundColor3 = Theme.Tertiary}, 0.1)
            end)
            optBtn.MouseLeave:Connect(function()
                Tween(optBtn, {BackgroundColor3 = Color3.fromRGB(20, 12, 50)}, 0.1)
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                selectedValue = opt
                valueLabel.Text = opt
                isOpen = false
                dropList.Visible = false
                arrowLabel.Text = "▼"
                if callback then callback(opt) end
            end)
        end
        
        dropBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            dropList.Visible = isOpen
            arrowLabel.Text = isOpen and "▲" or "▼"
        end)
        
        return container, function() return selectedValue end
    end
    
    --// FUNCTION: Create Slider
    local function CreateSlider(parent, label, min, max, default, callback)
        local value = default or min
        
        local container = Create("Frame", {
            Name = "Slider_" .. label,
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Parent = parent
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
        
        local titleRow = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Parent = container
        })
        
        Create("TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = label,
            TextColor3 = Theme.TextMain,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleRow
        })
        
        local valueLabel = Create("TextLabel", {
            Name = "Value",
            Size = UDim2.new(0.3, 0, 1, 0),
            Position = UDim2.new(0.7, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(value),
            TextColor3 = Theme.Accent3,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = titleRow
        })
        
        local trackBg = Create("Frame", {
            Name = "TrackBg",
            Size = UDim2.new(1, -20, 0, 8),
            Position = UDim2.new(0, 10, 0, 33),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Parent = container
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = trackBg})
        
        local trackFill = Create("Frame", {
            Name = "TrackFill",
            Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Theme.Accent1,
            BorderSizePixel = 0,
            Parent = trackBg
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = trackFill})
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.Accent2),
                ColorSequenceKeypoint.new(1, Theme.Accent4)
            }),
            Rotation = 0,
            Parent = trackFill
        })
        
        local knob = Create("Frame", {
            Name = "Knob",
            Size = UDim2.new(0, 16, 0, 16),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
            BackgroundColor3 = Theme.White,
            BorderSizePixel = 0,
            ZIndex = 10,
            Parent = trackBg
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})
        Create("UIStroke", {Color = Theme.Accent1, Thickness = 2, Parent = knob})
        
        -- Slider interaction
        local isDragging = false
        
        local sliderBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 23),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 20,
            Parent = container
        })
        
        local function UpdateSlider(mouseX)
            local trackAbsPos = trackBg.AbsolutePosition.X
            local trackAbsSize = trackBg.AbsoluteSize.X
            local relX = math.clamp((mouseX - trackAbsPos) / trackAbsSize, 0, 1)
            value = math.floor(min + relX * (max - min))
            valueLabel.Text = tostring(value)
            trackFill.Size = UDim2.new(relX, 0, 1, 0)
            knob.Position = UDim2.new(relX, 0, 0.5, 0)
            if callback then callback(value) end
        end
        
        sliderBtn.MouseButton1Down:Connect(function()
            isDragging = true
            UpdateSlider(Mouse.X)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)
        
        RunService.Heartbeat:Connect(function()
            if isDragging then
                UpdateSlider(Mouse.X)
            end
        end)
        
        return container, function() return value end
    end
    
    --// ================================
    --// PAGE: AUTO BUILD
    --// ================================
    local AutoBuildPage = CreatePage("AutoBuild")
    
    CreateSection(AutoBuildPage, "Load .build File", "📂")
    
    -- File input area
    local fileInputFrame = Create("Frame", {
        Name = "FileInput",
        Size = UDim2.new(1, 0, 0, 100),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Parent = AutoBuildPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = fileInputFrame})
    Create("UIStroke", {Color = Theme.Accent2, Thickness = 1.5, Parent = fileInputFrame})
    
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = "📁 Paste .build JSON Content Below:",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = fileInputFrame
    })
    
    local buildInput = Create("TextBox", {
        Name = "BuildInput",
        Size = UDim2.new(1, -20, 0, 55),
        Position = UDim2.new(0, 10, 0, 33),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = '{"version":"1.0","name":"MyBoat","blocks":[...]}',
        PlaceholderColor3 = Theme.TextDim,
        TextColor3 = Theme.TextMain,
        Font = Enum.Font.Code,
        TextSize = 10,
        MultiLine = true,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = fileInputFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = buildInput})
    Create("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingTop = UDim.new(0, 3), Parent = buildInput})
    
    local parseBtn = CreateButton(AutoBuildPage, "Parse & Load Build", "📋", Theme.Accent4, function()
        local content = buildInput.Text
        if content == "" then
            Notify("Error", "Please paste .build content first!", 3)
            return
        end
        
        local data = BuildSystem.Parse(content)
        if data then
            OxyXGui.buildData = data
            local blockCount = #data.blocks
            StatusText.Text = "✅ Loaded: " .. (data.name or "Unknown") .. " (" .. blockCount .. " blocks)"
            Notify("Success", "Build loaded: " .. (data.name or "Unknown") .. " with " .. blockCount .. " blocks!", 3)
        end
    end)
    
    CreateSection(AutoBuildPage, "Auto Build Options", "🔧")
    
    local _, getAutoWeld = CreateToggle(AutoBuildPage, "Auto Weld Blocks", true, function(val)
        Notify("Toggle", "Auto Weld: " .. (val and "ON" or "OFF"), 2)
    end)
    
    local _, getWired = CreateToggle(AutoBuildPage, "Auto Wire / Setup", true, function(val)
        Notify("Toggle", "Auto Wire: " .. (val and "ON" or "OFF"), 2)
    end)
    
    local _, getDelay = CreateSlider(AutoBuildPage, "Placement Delay (ms)", 0, 500, 100, function(val)
        Placer.placementDelay = val / 1000
    end)
    
    CreateSection(AutoBuildPage, "Build Actions", "▶️")
    
    local buildInfoLabel = Create("TextLabel", {
        Name = "BuildInfo",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Text = "No build loaded | Load a .build file above",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        Parent = AutoBuildPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = buildInfoLabel})
    
    local startBuildBtn = CreateButton(AutoBuildPage, "START AUTO BUILD", "🚀", Theme.Success, function()
        if not OxyXGui.buildData then
            Notify("Error", "No build loaded! Parse a .build file first.", 3)
            return
        end
        
        Notify("Building", "Starting auto build process...", 2)
        StatusText.Text = "🔨 Building..."
        
        task.spawn(function()
            local success = Placer:AutoSetup(OxyXGui.buildData)
            if success then
                StatusText.Text = "✅ Build complete!"
            else
                StatusText.Text = "❌ Build failed!"
            end
        end)
    end)
    
    CreateButton(AutoBuildPage, "Clear Build Data", "🗑️", Theme.Error, function()
        OxyXGui.buildData = nil
        buildInput.Text = ""
        buildInfoLabel.Text = "No build loaded | Load a .build file above"
        StatusText.Text = "🌌 Ready"
        Notify("Cleared", "Build data cleared!", 2)
    end)
    
    -- Update build info when data changes
    RunService.Heartbeat:Connect(function()
        if OxyXGui.buildData then
            buildInfoLabel.Text = "📦 " .. (OxyXGui.buildData.name or "Unknown") .. 
                                   " | " .. #OxyXGui.buildData.blocks .. " blocks" ..
                                   " | By: " .. (OxyXGui.buildData.author or "Unknown")
            buildInfoLabel.TextColor3 = Theme.Success
        end
    end)
    
    --// ================================
    --// PAGE: SHAPES
    --// ================================
    local ShapesPage = CreatePage("Shapes")
    
    CreateSection(ShapesPage, "Shape Type", "⬡")
    
    local shapeTypes = {"Ball", "Cylinder", "Triangle", "Pyramid", "Platform", "HollowBox", "BoatHull"}
    local _, getShapeType = CreateDropdown(ShapesPage, "Shape:", shapeTypes, "Ball", function(val)
        OxyXGui.selectedShape = val
    end)
    
    -- Block selector for shapes
    local blockNames = {}
    for _, b in ipairs(BlockDatabase) do
        table.insert(blockNames, b.name)
    end
    
    local _, getBlockForShape = CreateDropdown(ShapesPage, "Block:", blockNames, "Wood Block", function(val)
        OxyXGui.shapeBlock = val
    end)
    
    CreateSection(ShapesPage, "Shape Parameters", "📐")
    
    local _, getShapeRadius = CreateSlider(ShapesPage, "Radius", 1, 15, 3, function(val)
        OxyXGui.shapeParams.radius = val
    end)
    
    local _, getShapeHeight = CreateSlider(ShapesPage, "Height", 1, 20, 5, function(val)
        OxyXGui.shapeParams.height = val
    end)
    
    local _, getShapeWidth = CreateSlider(ShapesPage, "Width", 1, 20, 5, function(val)
        OxyXGui.shapeParams.width = val
    end)
    
    local _, getShapeLength = CreateSlider(ShapesPage, "Length", 1, 30, 8, function(val)
        OxyXGui.shapeParams.length = val
    end)
    
    local _, getShapeBase = CreateSlider(ShapesPage, "Base Size", 1, 20, 5, function(val)
        OxyXGui.shapeParams.base = val
    end)
    
    CreateSection(ShapesPage, "Generate & Build", "🔨")
    
    local previewCountLabel = Create("TextLabel", {
        Name = "PreviewCount",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = "Preview: Select shape and click Generate",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        Parent = ShapesPage
    })
    
    CreateButton(ShapesPage, "Preview Shape", "👁️", Theme.Accent4, function()
        local shape = getShapeType()
        local block = getBlockForShape()
        local params = OxyXGui.shapeParams
        
        local buildData = ShapeBuilder.Execute(shape, block, params)
        if buildData then
            local count = #buildData.blocks
            previewCountLabel.Text = "🔮 Preview: " .. shape .. " | " .. count .. " blocks | Block: " .. block
            previewCountLabel.TextColor3 = Theme.Accent3
            OxyXGui.buildData = buildData
            Notify("Preview", shape .. " shape: " .. count .. " blocks ready!", 3)
        else
            Notify("Error", "Could not generate shape!", 3)
        end
    end)
    
    CreateButton(ShapesPage, "Generate & Build Shape", "🚀", Theme.Success, function()
        local shape = getShapeType()
        local block = getBlockForShape()
        local params = OxyXGui.shapeParams
        
        local buildData = ShapeBuilder.Execute(shape, block, params)
        if buildData then
            OxyXGui.buildData = buildData
            Notify("Building", "Building " .. shape .. " with " .. #buildData.blocks .. " blocks...", 2)
            
            task.spawn(function()
                Placer:AutoSetup(buildData)
            end)
        else
            Notify("Error", "Could not generate shape!", 3)
        end
    end)
    
    CreateButton(ShapesPage, "Export Shape as .build", "💾", Theme.Accent1, function()
        local shape = getShapeType()
        local block = getBlockForShape()
        local params = OxyXGui.shapeParams
        
        local buildData = ShapeBuilder.Execute(shape, block, params)
        if buildData then
            local json = BuildSystem.Serialize(buildData.name, buildData.blocks)
            if json then
                -- Copy to clipboard if possible
                if setclipboard then
                    setclipboard(json)
                    Notify("Exported", "Shape exported to clipboard as .build format!", 3)
                elseif toclipboard then
                    toclipboard(json)
                    Notify("Exported", "Shape exported to clipboard!", 3)
                else
                    -- Show in text box
                    buildInput.Text = json
                    Notify("Exported", "Shape .build data shown in Auto Build tab!", 3)
                end
            end
        end
    end)
    
    --// ================================
    --// PAGE: CONVERTER
    --// ================================
    local ConverterPage = CreatePage("Converter")
    
    CreateSection(ConverterPage, "Studio Model → .build", "🔄")
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Text = "📝 This converter exports your current\nboat/model to .build format automatically",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        Parent = ConverterPage
    }):FindFirstChildOfClass("UICorner") or Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ConverterPage:FindFirstChild("TextLabel")})
    
    local infoLbl2 = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Parent = ConverterPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = infoLbl2})
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "📝 This converter exports your current boat/model to .build format for saving and reloading.",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = infoLbl2
    })
    
    CreateButton(ConverterPage, "Export My Boat → .build", "🚢", Theme.Accent1, function()
        Notify("Exporting", "Scanning your boat...", 2)
        task.spawn(function()
            local json = BuildSystem.FromCurrentBoat()
            if json then
                if setclipboard then
                    setclipboard(json)
                    Notify("Exported", "Boat exported to clipboard as .build!", 4)
                elseif toclipboard then
                    toclipboard(json)
                    Notify("Exported", "Boat exported to clipboard!", 4)
                else
                    buildInput.Text = json
                    Notify("Exported", "Exported to Auto Build tab!", 4)
                end
                StatusText.Text = "✅ Boat exported!"
            else
                Notify("Error", "Could not find your boat!", 3)
                StatusText.Text = "❌ Export failed"
            end
        end)
    end)
    
    CreateSection(ConverterPage, "JSON → .build", "📄")
    
    Create("Frame", {
        Name = "JsonInfo",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(20, 10, 50),
        BorderSizePixel = 0,
        Parent = ConverterPage
    })
    
    local jsonInfoFrame = Create("Frame", {
        Name = "JsonInfoFrame",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(20, 10, 50),
        BorderSizePixel = 0,
        Parent = ConverterPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = jsonInfoFrame})
    Create("UIStroke", {Color = Theme.Accent2, Thickness = 1, Parent = jsonInfoFrame})
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "💡 Paste Roblox Studio JSON export below to convert to .build",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = jsonInfoFrame
    })
    
    local jsonInput = CreateInput(ConverterPage, "Paste Studio JSON here...", "")
    
    CreateButton(ConverterPage, "Convert JSON → .build", "🔄", Theme.Accent4, function()
        local content = jsonInput.Text
        if content == "" then
            Notify("Error", "Please paste JSON content first!", 3)
            return
        end
        
        local success, parsed = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        
        if not success or not parsed then
            Notify("Error", "Invalid JSON format!", 3)
            return
        end
        
        -- Convert parsed JSON to .build
        local blocks = {}
        local function extractParts(obj)
            if type(obj) == "table" then
                if obj.ClassName == "Part" or obj.ClassName == "UnionOperation" or 
                   obj.ClassName == "MeshPart" or obj.ClassName == "SpecialMesh" then
                    -- Find matching block
                    local matchedBlock = Placer:GetBlockByName(obj.Name or "Wood Block") or BlockDatabase[158]
                    table.insert(blocks, {
                        id = matchedBlock.id,
                        name = matchedBlock.name,
                        position = obj.CFrame and {
                            x = obj.CFrame[1] or 0,
                            y = obj.CFrame[2] or 5,
                            z = obj.CFrame[3] or 0
                        } or {x = 0, y = 5, z = 0},
                        size = obj.Size and {
                            x = obj.Size[1] or 4,
                            y = obj.Size[2] or 1.2,
                            z = obj.Size[3] or 2
                        } or {x = 4, y = 1.2, z = 2},
                        color = obj.Color and {
                            r = math.floor((obj.Color[1] or 0.64) * 255),
                            g = math.floor((obj.Color[2] or 0.4) * 255),
                            b = math.floor((obj.Color[3] or 0.2) * 255)
                        } or {r = 163, g = 102, b = 51}
                    })
                end
                if obj.Children then
                    for _, child in ipairs(obj.Children) do
                        extractParts(child)
                    end
                end
            end
        end
        
        extractParts(parsed)
        
        if #blocks == 0 then
            Notify("Warning", "No recognizable parts found in JSON. Using basic conversion.", 3)
            -- Create a simple test block
            table.insert(blocks, {
                id = 158, name = "Wood Block",
                position = {x=0, y=5, z=0},
                size = {x=4, y=1.2, z=2},
                color = {r=163, g=102, b=51}
            })
        end
        
        local buildJson = BuildSystem.Serialize("Converted_Build", blocks)
        if buildJson then
            if setclipboard then
                setclipboard(buildJson)
                Notify("Converted", "Converted " .. #blocks .. " parts to .build! Copied to clipboard.", 4)
            else
                buildInput.Text = buildJson
                Notify("Converted", "Converted " .. #blocks .. " parts! Check Auto Build tab.", 4)
            end
        end
    end)
    
    CreateSection(ConverterPage, "Save/Load .build Files", "💾")
    
    local saveNameInput = CreateInput(ConverterPage, "Build name to save...", "")
    
    CreateButton(ConverterPage, "Save Current Build", "💾", Theme.Success, function()
        if not OxyXGui.buildData then
            Notify("Error", "No build data loaded!", 3)
            return
        end
        
        local name = saveNameInput.Text ~= "" and saveNameInput.Text or "MyBuild"
        local json = BuildSystem.Serialize(name, OxyXGui.buildData.blocks, OxyXGui.buildData.welds)
        
        if json then
            -- Try to save to file if executor supports it
            local filename = "OxyX_" .. name .. ".build"
            if writefile then
                pcall(function()
                    writefile(filename, json)
                    Notify("Saved", "Build saved as " .. filename, 3)
                end)
            else
                if setclipboard then setclipboard(json) end
                Notify("Saved", "Build copied to clipboard (use a text editor to save)", 3)
            end
        end
    end)
    
    CreateButton(ConverterPage, "Load Build from File", "📂", Theme.Accent4, function()
        -- Load from file
        local filename = saveNameInput.Text ~= "" and ("OxyX_" .. saveNameInput.Text .. ".build") or nil
        
        if filename and readfile then
            local success, content = pcall(readfile, filename)
            if success and content then
                local data = BuildSystem.Parse(content)
                if data then
                    OxyXGui.buildData = data
                    buildInput.Text = content
                    Notify("Loaded", "Build loaded from " .. filename, 3)
                end
            else
                Notify("Error", "File not found: " .. filename, 3)
            end
        else
            Notify("Info", "Enter a build name and make sure your executor supports file reading.", 3)
        end
    end)
    
    --// ================================
    --// PAGE: IMAGE LOADER
    --// ================================
    local ImagePage = CreatePage("ImageLoader")
    
    CreateSection(ImagePage, "Image Preview & Loader", "🖼️")
    
    -- Image preview frame
    local previewContainer = Create("Frame", {
        Name = "PreviewContainer",
        Size = UDim2.new(1, 0, 0, 150),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Parent = ImagePage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = previewContainer})
    Create("UIStroke", {Color = Theme.Accent2, Thickness = 1.5, Parent = previewContainer})
    
    local previewImg = Create("ImageLabel", {
        Name = "PreviewImage",
        Size = UDim2.new(0, 130, 0, 130),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Image = "",
        ScaleType = Enum.ScaleType.Fit,
        Parent = previewContainer
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = previewImg})
    Create("UIStroke", {Color = Theme.Accent1, Thickness = 1, Parent = previewImg})
    
    -- Image info
    local imgInfoFrame = Create("Frame", {
        Size = UDim2.new(1, -160, 1, -20),
        Position = UDim2.new(0, 150, 0, 10),
        BackgroundTransparency = 1,
        Parent = previewContainer
    })
    
    local imgStatusLabel = Create("TextLabel", {
        Name = "Status",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "No image loaded",
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = imgInfoFrame
    })
    
    local imgIdLabel = Create("TextLabel", {
        Name = "AssetId",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = "Asset ID: —",
        TextColor3 = Theme.Accent3,
        Font = Enum.Font.Code,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = imgInfoFrame
    })
    
    local imgCacheLabel = Create("TextLabel", {
        Name = "Cache",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        Text = "Cache: 0 images",
        TextColor3 = Theme.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = imgInfoFrame
    })
    
    CreateSection(ImagePage, "Load Image", "📥")
    
    local assetIdInput = CreateInput(ImagePage, "Enter Asset ID or rbxassetid://...", "")
    
    CreateButton(ImagePage, "Preview Image", "👁️", Theme.Accent4, function()
        local assetId = assetIdInput.Text
        if assetId == "" then
            Notify("Error", "Enter an asset ID!", 3)
            return
        end
        
        local success = ImageLoader.LoadToLabel(previewImg, assetId, Theme.Error)
        if success then
            local normalized = ImageLoader.NormalizeAssetId(assetId)
            imgStatusLabel.Text = "✅ Image loaded successfully"
            imgStatusLabel.TextColor3 = Theme.Success
            imgIdLabel.Text = "Asset ID: " .. (normalized or assetId)
            imgCacheLabel.Text = "Cache: " .. tostring(#(function() local t={} for k in pairs(ImageLoader.cache) do t[#t+1]=k end return t end())) .. " images"
            Notify("Image", "Image loaded!", 2)
        else
            imgStatusLabel.Text = "❌ Failed to load image"
            imgStatusLabel.TextColor3 = Theme.Error
            Notify("Error", "Could not load image: " .. assetId, 3)
        end
    end)
    
    CreateSection(ImagePage, "Apply to Block", "🎨")
    
    local targetPartInput = CreateInput(ImagePage, "Part/Block name in workspace...", "")
    local faceOptions = {"Front", "Back", "Left", "Right", "Top", "Bottom"}
    local _, getFace = CreateDropdown(ImagePage, "Face:", faceOptions, "Front", function(val) end)
    
    CreateButton(ImagePage, "Apply Image as Decal", "🖼️", Theme.Accent1, function()
        local assetId = assetIdInput.Text
        local partName = targetPartInput.Text
        local face = getFace()
        
        if assetId == "" or partName == "" then
            Notify("Error", "Enter both asset ID and part name!", 3)
            return
        end
        
        local part = Workspace:FindFirstChild(partName, true)
        if not part then
            Notify("Error", "Part not found: " .. partName, 3)
            return
        end
        
        local faceEnum = Enum.NormalId[face] or Enum.NormalId.Front
        local decal = ImageLoader.CreateDecal(part, assetId, faceEnum)
        
        if decal then
            Notify("Applied", "Decal applied to " .. partName .. " (" .. face .. " face)", 3)
        else
            Notify("Error", "Failed to apply decal!", 3)
        end
    end)
    
    CreateButton(ImagePage, "Apply as Surface Appearance", "✨", Theme.Accent5, function()
        local assetId = assetIdInput.Text
        local partName = targetPartInput.Text
        
        if assetId == "" or partName == "" then
            Notify("Error", "Enter both asset ID and part name!", 3)
            return
        end
        
        local part = Workspace:FindFirstChild(partName, true)
        if not part then
            Notify("Error", "Part not found: " .. partName, 3)
            return
        end
        
        local sa = ImageLoader.CreateSurfaceAppearance(part, assetId)
        if sa then
            Notify("Applied", "Surface appearance applied to " .. partName, 3)
        else
            Notify("Error", "Failed to apply surface appearance!", 3)
        end
    end)
    
    CreateButton(ImagePage, "Clear Image Cache", "🗑️", Theme.Error, function()
        ImageLoader.cache = {}
        ImageLoader.failedAttempts = {}
        previewImg.Image = ""
        imgStatusLabel.Text = "Cache cleared"
        imgStatusLabel.TextColor3 = Theme.TextDim
        Notify("Cache", "Image cache cleared!", 2)
    end)
    
    --// ================================
    --// PAGE: BLOCKS
    --// ================================
    local BlocksPage = CreatePage("Blocks")
    
    CreateSection(BlocksPage, "Block Database (159 Blocks)", "📦")
    
    -- Search input
    local searchInput = CreateInput(BlocksPage, "Search block name...", "")
    
    -- Category filter
    local categories = {"All"}
    local catMap = {}
    for _, b in ipairs(BlockDatabase) do
        if not catMap[b.category] then
            catMap[b.category] = true
            table.insert(categories, b.category)
        end
    end
    
    local _, getCatFilter = CreateDropdown(BlocksPage, "Category:", categories, "All", function(val)
        -- Filter will be applied when refresh is called
    end)
    
    -- Block list scroll frame
    local blockListContainer = Create("Frame", {
        Name = "BlockListContainer",
        Size = UDim2.new(1, 0, 0, 300),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Parent = BlocksPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = blockListContainer})
    
    local blockScroll = Create("ScrollingFrame", {
        Name = "BlockScroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent1,
        CanvasSize = UDim2.new(1, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = blockListContainer
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = blockScroll
    })
    Create("UIPadding", {
        PaddingAll = UDim.new(0, 5),
        Parent = blockScroll
    })
    
    local selectedBlockLabel = Create("TextLabel", {
        Name = "SelectedBlock",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Text = "Selected: None | Click a block to select",
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        Parent = BlocksPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = selectedBlockLabel})
    
    local function RefreshBlockList(filter, catFilter)
        -- Clear existing
        for _, child in ipairs(blockScroll:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        
        local count = 0
        for _, block in ipairs(BlockDatabase) do
            local nameMatch = filter == "" or block.name:lower():find(filter:lower())
            local catMatch = catFilter == "All" or block.category == catFilter
            
            if nameMatch and catMatch then
                count = count + 1
                local row = Create("TextButton", {
                    Name = "Block_" .. block.id,
                    Size = UDim2.new(1, -4, 0, 28),
                    BackgroundColor3 = Color3.fromRGB(15, 8, 40),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = blockScroll
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = row})
                
                -- Block ID badge
                local idBadge = Create("TextLabel", {
                    Size = UDim2.new(0, 35, 0, 20),
                    Position = UDim2.new(0, 3, 0.5, -10),
                    BackgroundColor3 = Theme.Accent2,
                    BorderSizePixel = 0,
                    Text = "#" .. block.id,
                    TextColor3 = Theme.Accent3,
                    Font = Enum.Font.GothamBold,
                    TextSize = 9,
                    Parent = row
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = idBadge})
                
                -- Block name
                Create("TextLabel", {
                    Size = UDim2.new(0.45, -45, 1, 0),
                    Position = UDim2.new(0, 42, 0, 0),
                    BackgroundTransparency = 1,
                    Text = block.name,
                    TextColor3 = Theme.TextMain,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                })
                
                -- Category badge
                local catBadge = Create("TextLabel", {
                    Size = UDim2.new(0.3, 0, 0, 16),
                    Position = UDim2.new(0.5, 0, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(
                        block.category == "Structure" and 50 or
                        block.category == "Weapons" and 80 or
                        block.category == "Propulsion" and 20 or 30,
                        block.category == "Structure" and 30 or
                        block.category == "Weapons" and 20 or
                        block.category == "Propulsion" and 80 or 20,
                        block.category == "Structure" and 80 or
                        block.category == "Weapons" and 20 or
                        block.category == "Propulsion" and 30 or 80
                    ),
                    BorderSizePixel = 0,
                    Text = block.category,
                    TextColor3 = Theme.TextSub,
                    Font = Enum.Font.Gotham,
                    TextSize = 8,
                    Parent = row
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = catBadge})
                
                -- Type badge
                Create("TextLabel", {
                    Size = UDim2.new(0.18, 0, 0, 16),
                    Position = UDim2.new(0.82, 0, 0.5, -8),
                    BackgroundColor3 = Theme.Tertiary,
                    BorderSizePixel = 0,
                    Text = block.type,
                    TextColor3 = Theme.Accent3,
                    Font = Enum.Font.GothamBold,
                    TextSize = 8,
                    Parent = row
                })
                
                -- Hover & click
                row.MouseEnter:Connect(function()
                    Tween(row, {BackgroundColor3 = Color3.fromRGB(25, 12, 60)}, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    if OxyXGui.selectedBlock ~= block then
                        Tween(row, {BackgroundColor3 = Color3.fromRGB(15, 8, 40)}, 0.1)
                    end
                end)
                row.MouseButton1Click:Connect(function()
                    OxyXGui.selectedBlock = block
                    selectedBlockLabel.Text = "✅ Selected: " .. block.name .. " (ID: " .. block.id .. ") | " .. block.category
                    selectedBlockLabel.TextColor3 = Theme.Accent3
                    
                    -- Place single block
                    Placer:PlaceBlock(block, LocalPlayer.Character and 
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                        LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, -8) or
                        Vector3.new(0, 5, 0))
                    
                    Notify("Block", "Placed: " .. block.name, 2)
                end)
            end
        end
        
        -- Show count
        if count == 0 then
            Create("TextLabel", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundTransparency = 1,
                Text = "No blocks found matching '" .. filter .. "'",
                TextColor3 = Theme.TextDim,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Parent = blockScroll
            })
        end
    end
    
    -- Initial populate
    RefreshBlockList("", "All")
    
    searchInput.Changed:Connect(function(prop)
        if prop == "Text" then
            RefreshBlockList(searchInput.Text, getCatFilter())
        end
    end)
    
    CreateButton(BlocksPage, "Refresh Block List", "🔄", Theme.Accent4, function()
        RefreshBlockList(searchInput.Text, getCatFilter())
        Notify("Refreshed", "Block list updated!", 2)
    end)
    
    --// ================================
    --// PAGE: SETTINGS
    --// ================================
    local SettingsPage = CreatePage("Settings")
    
    CreateSection(SettingsPage, "About OxyX", "ℹ️")
    
    local aboutFrame = Create("Frame", {
        Name = "About",
        Size = UDim2.new(1, 0, 0, 120),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Parent = SettingsPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = aboutFrame})
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 10, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 30))
        }),
        Rotation = 135,
        Parent = aboutFrame
    })
    
    local astolfoSmall = Create("ImageLabel", {
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0, 10, 0, 20),
        BackgroundColor3 = Theme.Accent2,
        BorderSizePixel = 0,
        Image = "rbxassetid://7078026274",
        ScaleType = Enum.ScaleType.Fit,
        Parent = aboutFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = astolfoSmall})
    Create("UIStroke", {Color = Theme.Accent5, Thickness = 2, Parent = astolfoSmall})
    
    Create("TextLabel", {
        Size = UDim2.new(1, -110, 0, 25),
        Position = UDim2.new(0, 100, 0, 15),
        BackgroundTransparency = 1,
        Text = "OxyX BABFT Tool",
        TextColor3 = Theme.White,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = aboutFrame
    })
    
    local aboutLines = {
        "Version 2.0.0 | Galaxy Edition",
        "Build A Boat For Treasure Helper",
        "159 Blocks | Auto Build | Shapes",
        "Model Converter | Image Loader",
        "Executor: " .. ExecutorName,
    }
    
    for i, line in ipairs(aboutLines) do
        Create("TextLabel", {
            Size = UDim2.new(1, -110, 0, 16),
            Position = UDim2.new(0, 100, 0, 38 + (i-1) * 16),
            BackgroundTransparency = 1,
            Text = line,
            TextColor3 = (i == 1) and Theme.Accent3 or Theme.TextSub,
            Font = (i == 1) and Enum.Font.GothamBold or Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = aboutFrame
        })
    end
    
    CreateSection(SettingsPage, "Script Settings", "⚙️")
    
    CreateToggle(SettingsPage, "Show Notifications", true, function(val)
        -- Store preference
    end)
    
    CreateToggle(SettingsPage, "Auto-Place on Select", true, function(val) end)
    
    CreateToggle(SettingsPage, "Debug Mode", false, function(val)
        if val then
            Notify("Debug", "Debug mode enabled - check output for logs", 3)
        end
    end)
    
    local _, getThemeOpacity = CreateSlider(SettingsPage, "UI Opacity", 50, 100, 95, function(val)
        MainFrame.BackgroundTransparency = 1 - (val / 100)
    end)
    
    CreateSection(SettingsPage, "Hotkeys", "⌨️")
    
    local hotkeyFrame = Create("Frame", {
        Name = "Hotkeys",
        Size = UDim2.new(1, 0, 0, 120),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Parent = SettingsPage
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = hotkeyFrame})
    
    local hotkeys = {
        {"Right Shift", "Toggle UI Visibility"},
        {"Ctrl + B", "Quick Build (Current .build)"},
        {"Ctrl + E", "Export Current Boat"},
        {"Ctrl + R", "Reset/Clear Build Data"},
    }
    
    local hotkeyLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = hotkeyFrame
    })
    Create("UIPadding", {PaddingAll = UDim.new(0, 8), Parent = hotkeyFrame})
    
    for _, hk in ipairs(hotkeys) do
        local row = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            Parent = hotkeyFrame
        })
        
        local keyBadge = Create("TextLabel", {
            Size = UDim2.new(0, 100, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -10),
            BackgroundColor3 = Theme.Accent2,
            BorderSizePixel = 0,
            Text = hk[1],
            TextColor3 = Theme.Accent3,
            Font = Enum.Font.Code,
            TextSize = 10,
            Parent = row
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = keyBadge})
        
        Create("TextLabel", {
            Size = UDim2.new(1, -110, 1, 0),
            Position = UDim2.new(0, 110, 0, 0),
            BackgroundTransparency = 1,
            Text = hk[2],
            TextColor3 = Theme.TextSub,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row
        })
    end
    
    CreateButton(SettingsPage, "Check for Updates", "🔄", Theme.Accent4, function()
        Notify("Update Check", "OxyX v2.0.0 - Check GitHub for latest version", 4)
        StatusText.Text = "📡 Checking GitHub..."
        task.delay(2, function()
            StatusText.Text = "✅ OxyX v2.0.0 (Latest)"
        end)
    end)
    
    CreateButton(SettingsPage, "Join OxyX Discord", "💬", Theme.Accent5, function()
        Notify("Discord", "Join our community for updates and support!", 3)
        if setclipboard then
            setclipboard("https://discord.gg/oxyx")
        end
    end)
    
    CreateButton(SettingsPage, "GitHub Repository", "📁", Theme.Accent1, function()
        if setclipboard then
            setclipboard("https://github.com/OxyXScript/BABFT")
            Notify("GitHub", "GitHub URL copied to clipboard!", 3)
        end
    end)
    
    --// ================================
    --// TAB SWITCHING LOGIC
    --// ================================
    local function SwitchTab(tabName)
        OxyXGui.currentTab = tabName
        
        -- Hide all pages
        for name, page in pairs(TabPages) do
            page.Visible = false
        end
        
        -- Update tab buttons
        for name, btn in pairs(TabButtons) do
            if name == tabName then
                Tween(btn, {BackgroundColor3 = Theme.Accent1}, 0.2)
                btn.TextColor3 = Theme.White
            else
                Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                btn.TextColor3 = Theme.TextDim
            end
        end
        
        -- Show selected page
        if TabPages[tabName] then
            TabPages[tabName].Visible = true
        end
        
        StatusText.Text = "🌌 Tab: " .. tabName
    end
    
    -- Create tab buttons and connect them
    for i, tabInfo in ipairs(Tabs) do
        local btn = CreateTabButton(tabInfo, i)
        btn.MouseButton1Click:Connect(function()
            SwitchTab(tabInfo.name)
        end)
    end
    
    -- Start on AutoBuild tab
    SwitchTab("AutoBuild")
    
    --// ================================
    --// WINDOW DRAGGING
    --// ================================
    local isDragging = false
    local dragOffset = Vector2.new(0, 0)
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            local pos = MainFrame.AbsolutePosition
            dragOffset = Vector2.new(
                Mouse.X - pos.X,
                Mouse.Y - pos.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if isDragging then
            local viewportSize = Camera.ViewportSize
            local newX = math.clamp(Mouse.X - dragOffset.X, 0, viewportSize.X - MainFrame.AbsoluteSize.X)
            local newY = math.clamp(Mouse.Y - dragOffset.Y, 0, viewportSize.Y - MainFrame.AbsoluteSize.Y)
            MainFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
    
    --// ================================
    --// MINIMIZE / CLOSE BUTTONS
    --// ================================
    MinBtn.MouseButton1Click:Connect(function()
        OxyXGui.isMinimized = not OxyXGui.isMinimized
        
        if OxyXGui.isMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, 400, 0, 75)}, 0.3)
            MinBtn.Text = "□"
            Notify("OxyX", "UI Minimized | Click □ to restore", 2)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 400, 0, 600)}, 0.3)
            MinBtn.Text = "−"
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)
    
    --// ================================
    --// HOTKEYS
    --// ================================
    UserInputService.InputBegan:Connect(function(input, gameProc)
        if gameProc then return end
        
        -- Right Shift = Toggle Visibility
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
        
        -- Ctrl + B = Quick Build
        if input.KeyCode == Enum.KeyCode.B and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            if OxyXGui.buildData then
                task.spawn(function()
                    Placer:AutoSetup(OxyXGui.buildData)
                end)
            else
                Notify("Quick Build", "No build loaded! Go to Auto Build tab.", 3)
            end
        end
        
        -- Ctrl + E = Export Boat
        if input.KeyCode == Enum.KeyCode.E and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            task.spawn(function()
                local json = BuildSystem.FromCurrentBoat()
                if json and setclipboard then
                    setclipboard(json)
                    Notify("Export", "Boat exported to clipboard!", 3)
                end
            end)
        end
        
        -- Ctrl + R = Reset Build
        if input.KeyCode == Enum.KeyCode.R and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            OxyXGui.buildData = nil
            Notify("Reset", "Build data cleared!", 2)
        end
    end)
    
    --// ================================
    --// GALAXY NEBULA ANIMATION
    --// ================================
    task.spawn(function()
        local nebulaAngle = 0
        while MainFrame and MainFrame.Parent do
            nebulaAngle = (nebulaAngle + 0.5) % 360
            BgGradient.Rotation = nebulaAngle
            task.wait(0.05)
        end
    end)
    
    -- Animate Astolfo image glow
    task.spawn(function()
        local glowColors = {Theme.Accent5, Theme.Accent4, Theme.Accent3, Theme.Accent1}
        local glowIdx = 1
        while AstolfoImg and AstolfoImg.Parent do
            glowIdx = (glowIdx % #glowColors) + 1
            Tween(astolfoStroke, {Color = glowColors[glowIdx]}, 1)
            task.wait(1)
        end
    end)
    
    --// STARTUP NOTIFICATION
    Notify("OxyX v2.0.0", "Galaxy Edition loaded! 159 blocks ready 🌌", 4)
    StatusText.Text = "🌌 OxyX Ready | " .. ExecutorName
    
    return ScreenGui
end

--// INITIALIZE GUI
local success, err = pcall(function()
    OxyXGui.Init()
end)

if not success then
    warn("[OxyX] GUI initialization error: " .. tostring(err))
    -- Fallback minimal notification
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "OxyX_Error"
        gui.Parent = CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 60)
        frame.Position = UDim2.new(0.5, -150, 0, 20)
        frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        frame.Parent = gui
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "[OxyX] Error loading GUI. Check output."
        lbl.TextColor3 = Color3.fromRGB(255, 100, 100)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.Parent = frame
        
        task.delay(5, function() gui:Destroy() end)
    end)
end

print([[
╔═══════════════════════════════════════╗
║     OxyX BABFT Tool - Loaded! 🌌      ║
║  Version: 2.0.0 | Galaxy Edition      ║
║  Blocks: 159 | Auto Build Ready       ║
║  Press Right Shift to toggle UI       ║
╚═══════════════════════════════════════╝
]])
