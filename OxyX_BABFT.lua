-- ============================================================
--   OxyX BABFT Auto Builder v1.0
--   Build A Boat For Treasure - Auto Build Script
--   Author  : GALAXY_INDO122
--   Version : 1.0
--   Engine  : BuildingTool.RF (confirmed working)
--   Blocks  : 159 blocks supported
-- ============================================================

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService    = game:GetService("HttpService")
local Workspace      = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GUI_PARENT
pcall(function() GUI_PARENT = game:GetService("CoreGui") end)
if not GUI_PARENT then GUI_PARENT = Players.LocalPlayer.PlayerGui end

local LP    = Players.LocalPlayer
local PGui  = LP:WaitForChild("PlayerGui")
local Mouse = LP:GetMouse()
local Cam   = Workspace.CurrentCamera

-- ============================================================
-- COLOUR PALETTE
-- ============================================================
local c0 = Color3.fromRGB

local BG0   = c0(5,   3,  18)
local BG1   = c0(12,  7,  35)
local BG2   = c0(20, 12,  55)
local BG3   = c0(32, 20,  75)
local PRP   = c0(140, 44, 230)
local DPRP  = c0(60,   0, 120)
local LPRP  = c0(190, 110, 255)
local CYN   = c0(0,  205, 255)
local PNK   = c0(255,  95, 180)
local GLD   = c0(255, 200,  55)
local GRN   = c0(70,  225, 115)
local RED   = c0(255,  65,  65)
local YLW   = c0(255, 210,  50)
local WHT   = c0(255, 255, 255)
local TXT0  = c0(238, 228, 255)
local TXT1  = c0(165, 148, 215)
local TXT2  = c0(90,   72, 138)

-- ============================================================
-- UTILITY
-- ============================================================
local function New(class, props)
    local ok, inst = pcall(Instance.new, class)
    if not ok then return nil end
    for k, v in pairs(props) do
        if k ~= "Parent" then
            pcall(function() inst[k] = v end)
        end
    end
    if props.Parent then
        pcall(function() inst.Parent = props.Parent end)
    end
    return inst
end

local function Tween(obj, goal, t, easeStyle)
    if not obj or not obj.Parent then return end
    pcall(function()
        TweenService:Create(
            obj,
            TweenInfo.new(t or 0.25, easeStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            goal
        ):Play()
    end)
end

local function Notify(title, msg, dur)
    dur = dur or 3
    task.spawn(function()
        pcall(function()
            local sg = New("ScreenGui", {
                Name = "OxNotif_" .. tick(),
                DisplayOrder = 99999,
                IgnoreGuiInset = true,
                ResetOnSpawn = false,
                Parent = GUI_PARENT
            })
            local frame = New("Frame", {
                Size = UDim2.new(0, 290, 0, 58),
                Position = UDim2.new(1, 10, 1, -72),
                BackgroundColor3 = BG1,
                BorderSizePixel = 0,
                Parent = sg
            })
            New("UICorner",  { CornerRadius = UDim.new(0, 10), Parent = frame })
            New("UIStroke",  { Color = PRP, Thickness = 1.5,   Parent = frame })
            New("TextLabel", {
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 8, 0, 4),
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = LPRP,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            New("TextLabel", {
                Size = UDim2.new(1, -10, 0, 28),
                Position = UDim2.new(0, 8, 0, 24),
                BackgroundTransparency = 1,
                Text = msg,
                TextColor3 = TXT1,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            Tween(frame, { Position = UDim2.new(1, -300, 1, -72) }, 0.3)
            task.delay(dur, function()
                pcall(function()
                    Tween(frame, { Position = UDim2.new(1, 10, 1, -72) }, 0.25)
                    task.wait(0.3)
                    sg:Destroy()
                end)
            end)
        end)
    end)
end

-- ============================================================
-- BLOCK DATABASE  (159 blocks)
-- ============================================================
local BLOCKS = {
    {id=1,  n="Back Wheel",             cat="Wheels"},
    {id=2,  n="Balloon Block",          cat="Special"},
    {id=3,  n="Bar",                    cat="Structure"},
    {id=4,  n="Big Cannon",             cat="Weapons"},
    {id=5,  n="Big Switch",             cat="Electronics"},
    {id=6,  n="Blue Candy",             cat="Candy"},
    {id=7,  n="Boat Motor",             cat="Propulsion"},
    {id=8,  n="Bouncy Block",           cat="Special"},
    {id=9,  n="Boxing Glove",           cat="Weapons"},
    {id=10, n="Bread",                  cat="Food"},
    {id=11, n="Brick Block",            cat="Structure"},
    {id=12, n="Bundles of Potions",     cat="Special"},
    {id=13, n="Button",                 cat="Electronics"},
    {id=14, n="Cake",                   cat="Food"},
    {id=15, n="Camera",                 cat="Special"},
    {id=16, n="Candle",                 cat="Decoration"},
    {id=17, n="Candy Cane Block",       cat="Candy"},
    {id=18, n="Candy Cane Rod",         cat="Candy"},
    {id=19, n="Cannon",                 cat="Weapons"},
    {id=20, n="Car Seat",               cat="Seats"},
    {id=21, n="Chair",                  cat="Seats"},
    {id=22, n="Classic Firework",       cat="Fireworks"},
    {id=23, n="Coal Block",             cat="Structure"},
    {id=24, n="Common Chest Block",     cat="Chests"},
    {id=25, n="Concrete Block",         cat="Structure"},
    {id=26, n="Concrete Rod",           cat="Structure"},
    {id=27, n="Cookie Back Wheel",      cat="Wheels"},
    {id=28, n="Cookie Front Wheel",     cat="Wheels"},
    {id=29, n="Corner Wedge",           cat="Structure"},
    {id=30, n="Delay Block",            cat="Electronics"},
    {id=31, n="Dome Camera",            cat="Special"},
    {id=32, n="Door",                   cat="Structure"},
    {id=33, n="Dragon Egg",             cat="Special"},
    {id=34, n="Dragon Harpoon",         cat="Weapons"},
    {id=35, n="Dual Candy Cane Harpoon",cat="Weapons"},
    {id=36, n="Dynamite",               cat="Weapons"},
    {id=37, n="Easter Jetpack",         cat="Propulsion"},
    {id=38, n="Egg Cannon",             cat="Weapons"},
    {id=39, n="Epic Chest Block",       cat="Chests"},
    {id=40, n="Fabric Block",           cat="Structure"},
    {id=41, n="Firework 1",             cat="Fireworks"},
    {id=42, n="Firework 2",             cat="Fireworks"},
    {id=43, n="Firework 3",             cat="Fireworks"},
    {id=44, n="Firework 4",             cat="Fireworks"},
    {id=45, n="Flag",                   cat="Decoration"},
    {id=46, n="Front Wheel",            cat="Wheels"},
    {id=47, n="Gameboard",              cat="Special"},
    {id=48, n="Glass Block",            cat="Structure"},
    {id=49, n="Glue",                   cat="Electronics"},
    {id=50, n="Gold Block",             cat="Structure"},
    {id=51, n="Golden Harpoon",         cat="Weapons"},
    {id=52, n="Grass Block",            cat="Structure"},
    {id=53, n="Harpoon",                cat="Weapons"},
    {id=54, n="Hatch",                  cat="Structure"},
    {id=55, n="Heart",                  cat="Decoration"},
    {id=56, n="Helm",                   cat="Special"},
    {id=57, n="Hinge",                  cat="Electronics"},
    {id=58, n="Huge Back Wheel",        cat="Wheels"},
    {id=59, n="Huge Front Wheel",       cat="Wheels"},
    {id=60, n="Huge Wheel",             cat="Wheels"},
    {id=61, n="I-Beam",                 cat="Structure"},
    {id=62, n="Ice Block",              cat="Structure"},
    {id=63, n="Jet Turbine",            cat="Propulsion"},
    {id=64, n="Jetpack",                cat="Propulsion"},
    {id=65, n="Lamp",                   cat="Decoration"},
    {id=66, n="Large Treasure",         cat="Treasure"},
    {id=67, n="Laser Launcher",         cat="Weapons"},
    {id=68, n="Legendary Chest Block",  cat="Chests"},
    {id=69, n="Lever",                  cat="Electronics"},
    {id=70, n="Life Preserver",         cat="Special"},
    {id=71, n="Light Bulb",             cat="Decoration"},
    {id=72, n="Locked Door",            cat="Structure"},
    {id=73, n="Magnet",                 cat="Special"},
    {id=74, n="Marble Block",           cat="Structure"},
    {id=75, n="Marble Rod",             cat="Structure"},
    {id=76, n="Mast",                   cat="Structure"},
    {id=77, n="Master Builder Trophy",  cat="Trophies"},
    {id=78, n="Medium Treasure",        cat="Treasure"},
    {id=79, n="Mega Thruster",          cat="Propulsion"},
    {id=80, n="Metal Block",            cat="Structure"},
    {id=81, n="Metal Rod",              cat="Structure"},
    {id=82, n="Mini Gun",               cat="Weapons"},
    {id=83, n="Mounted Bow",            cat="Weapons"},
    {id=84, n="Mounted Candy Cane Sword",cat="Weapons"},
    {id=85, n="Mounted Cannon",         cat="Weapons"},
    {id=86, n="Mounted Flintlocks",     cat="Weapons"},
    {id=87, n="Mounted Knight Sword",   cat="Weapons"},
    {id=88, n="Mounted Sword",          cat="Weapons"},
    {id=89, n="Mounted Wizard Staff",   cat="Weapons"},
    {id=90, n="Music Note",             cat="Decoration"},
    {id=91, n="Mystery Box",            cat="Special"},
    {id=92, n="Neon Block",             cat="Structure"},
    {id=93, n="Obsidian Block",         cat="Structure"},
    {id=94, n="Orange Candy",           cat="Candy"},
    {id=95, n="Parachute Block",        cat="Special"},
    {id=96, n="Peppermint Back Wheel",  cat="Wheels"},
    {id=97, n="Peppermint Front Wheel", cat="Wheels"},
    {id=98, n="Pilot Seat",             cat="Seats"},
    {id=99, n="Pine Tree",              cat="Decoration"},
    {id=100,n="Pink Candy",             cat="Candy"},
    {id=101,n="Piston",                 cat="Electronics"},
    {id=102,n="Plastic Block",          cat="Structure"},
    {id=103,n="Plushie 1",              cat="Decoration"},
    {id=104,n="Plushie 2",              cat="Decoration"},
    {id=105,n="Plushie 3",              cat="Decoration"},
    {id=106,n="Plushie 4",              cat="Decoration"},
    {id=107,n="Portal",                 cat="Special"},
    {id=108,n="Pumpkin",                cat="Decoration"},
    {id=109,n="Purple Candy",           cat="Candy"},
    {id=110,n="Rare Chest Block",       cat="Chests"},
    {id=111,n="Red Candy",              cat="Candy"},
    {id=112,n="Rope",                   cat="Structure"},
    {id=113,n="Rusted Block",           cat="Structure"},
    {id=114,n="Rusted Rod",             cat="Structure"},
    {id=115,n="Sand Block",             cat="Structure"},
    {id=116,n="Seat",                   cat="Seats"},
    {id=117,n="Servo",                  cat="Electronics"},
    {id=118,n="Shield Generator",       cat="Special"},
    {id=119,n="Sign",                   cat="Decoration"},
    {id=120,n="Small Treasure",         cat="Treasure"},
    {id=121,n="Smooth Wood Block",      cat="Structure"},
    {id=122,n="Snowball Launcher",      cat="Weapons"},
    {id=123,n="Soccer Ball",            cat="Special"},
    {id=124,n="Sonic Jet Turbine",      cat="Propulsion"},
    {id=125,n="Spike Trap",             cat="Weapons"},
    {id=126,n="Spooky Thruster",        cat="Propulsion"},
    {id=127,n="Star",                   cat="Decoration"},
    {id=128,n="Star Balloon Block",     cat="Special"},
    {id=129,n="Star Jetpack",           cat="Propulsion"},
    {id=130,n="Steampunk Jetpack",      cat="Propulsion"},
    {id=131,n="Step",                   cat="Structure"},
    {id=132,n="Stone Block",            cat="Structure"},
    {id=133,n="Stone Rod",              cat="Structure"},
    {id=134,n="Suspension",             cat="Electronics"},
    {id=135,n="Switch",                 cat="Electronics"},
    {id=136,n="Throne",                 cat="Seats"},
    {id=137,n="Thruster",               cat="Propulsion"},
    {id=138,n="Titanium Block",         cat="Structure"},
    {id=139,n="Titanium Rod",           cat="Structure"},
    {id=140,n="TNT",                    cat="Weapons"},
    {id=141,n="Torch",                  cat="Decoration"},
    {id=142,n="Toy Block",              cat="Structure"},
    {id=143,n="Treasure Chest",         cat="Treasure"},
    {id=144,n="Trophy 1st",             cat="Trophies"},
    {id=145,n="Trophy 2nd",             cat="Trophies"},
    {id=146,n="Trophy 3rd",             cat="Trophies"},
    {id=147,n="Truss",                  cat="Structure"},
    {id=148,n="Ultra Boat Motor",       cat="Propulsion"},
    {id=149,n="Ultra Jetpack",          cat="Propulsion"},
    {id=150,n="Ultra Thruster",         cat="Propulsion"},
    {id=151,n="Uncommon Chest Block",   cat="Chests"},
    {id=152,n="Wedge",                  cat="Structure"},
    {id=153,n="Wheel",                  cat="Wheels"},
    {id=154,n="Window",                 cat="Structure"},
    {id=155,n="Winter Boat Motor",      cat="Propulsion"},
    {id=156,n="Winter Jet Turbine",     cat="Propulsion"},
    {id=157,n="Winter Thruster",        cat="Propulsion"},
    {id=158,n="Wood Block",             cat="Structure"},
    {id=159,n="Wood Rod",               cat="Structure"},
}

-- Lookup tables for fast search
local BLOCKS_LOWER = {}
for _, b in ipairs(BLOCKS) do
    BLOCKS_LOWER[b.n:lower()] = b
end

local function FindBlock(name)
    if not name then return BLOCKS[158] end
    local lo = name:lower()
    if BLOCKS_LOWER[lo] then return BLOCKS_LOWER[lo] end
    for k, v in pairs(BLOCKS_LOWER) do
        if k:find(lo, 1, true) or lo:find(k, 1, true) then return v end
    end
    return BLOCKS[158]
end

-- Display name -> ReplicatedStorage name ("Wood Block" -> "WoodBlock")
local function ToRSName(displayName)
    return displayName:gsub("%s+", "")
end

-- ============================================================
-- RF PLACEMENT ENGINE  (BuildingTool.RF confirmed working)
-- ============================================================

local function GetZone()
    return Workspace:FindFirstChild(tostring(LP.TeamColor) .. "Zone")
end

local function GetRF()
    if LP.Character then
        local bt = LP.Character:FindFirstChild("BuildingTool")
        if bt then return bt:FindFirstChild("RF") end
    end
    local bt = LP.Backpack:FindFirstChild("BuildingTool")
    if bt then return bt:FindFirstChild("RF") end
    return nil
end

local function EquipBuildingTool()
    local bt = LP.Backpack:FindFirstChild("BuildingTool")
    if bt and LP.Character then
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hum then
            hum:EquipTool(bt)
            task.wait(0.7)
        end
    end
    return GetRF()
end

-- Place one block at zone-relative offset (ox, oy, oz).
-- ox/oz = horizontal offset from zone center.
-- oy    = vertical offset from zone top surface.
-- rotY  = Y rotation in degrees (optional).
local function PlaceBlock(blockDisplayName, ox, oy, oz, rotY)
    local rf = GetRF()
    if not rf then rf = EquipBuildingTool() end
    if not rf then return false, "BuildingTool RF not found" end

    -- Resolve RS name
    local rsName = ToRSName(blockDisplayName)
    if not ReplicatedStorage.BuildingParts:FindFirstChild(rsName) then
        rsName = blockDisplayName
        if not ReplicatedStorage.BuildingParts:FindFirstChild(rsName) then
            return false, "Block not in ReplicatedStorage: " .. blockDisplayName
        end
    end

    local zone = GetZone()
    if not zone then return false, "Player zone not found" end

    -- Compute world CFrame
    local zoneTop  = zone.Position.Y + zone.Size.Y / 2
    local worldCF  = CFrame.new(zone.Position.X + ox, zoneTop + oy, zone.Position.Z + oz)
    if (rotY or 0) ~= 0 then
        worldCF = worldCF * CFrame.Angles(0, math.rad(rotY), 0)
    end

    local relCF  = zone.CFrame:toObjectSpace(worldCF)
    local count  = 999
    pcall(function() count = LP.Data[rsName].Value end)

    local anchor = false
    pcall(function()
        anchor = PGui.BuildGui.InventoryFrame.MoreFrame.AnchorBlock.Anchor.Value
    end)

    -- Invoke server RF  (7 args - confirmed working)
    local ok, res = pcall(function()
        return rf:InvokeServer(rsName, count, zone, relCF, anchor, worldCF, false)
    end)

    if ok then return true, tostring(res)
    else return false, tostring(res) end
end

-- ============================================================
-- BUILD FILE PARSER
-- ============================================================

local function ParseBuildData(text)
    if not text or text:match("^%s*$") then
        return nil, "File is empty"
    end
    local ok, data = pcall(function() return HttpService:JSONDecode(text) end)
    if not ok or type(data) ~= "table" then
        return nil, "Invalid JSON"
    end
    if data.blocks and #data.blocks > 0 then
        return data
    end
    -- Legacy array format
    if data[1] and (data[1].name or data[1].Name) then
        local bl = {}
        for _, bi in ipairs(data) do
            bl[#bl + 1] = {
                name     = bi.name or bi.Name or "Wood Block",
                position = bi.position or { x = 0, y = 2, z = 0 }
            }
        end
        return { version = "1.0", name = "Import", author = LP.Name, blocks = bl, welds = {} }
    end
    return nil, "Unrecognized format"
end

-- ============================================================
-- SHAPE GENERATORS  (zone-relative coords)
-- ============================================================

local function MakePlatform(blockName, w, l)
    local bl = {}
    for x = 0, w - 1 do
        for z = 0, l - 1 do
            bl[#bl + 1] = {
                name     = blockName,
                position = { x = (x - w / 2) * 4, y = 2, z = (z - l / 2) * 4 }
            }
        end
    end
    return { version = "1.0", name = "Platform_" .. w .. "x" .. l, author = LP.Name, blocks = bl, welds = {} }
end

local function MakeBall(blockName, radius)
    local bl = {}
    for x = -radius, radius do
        for y = -radius, radius do
            for z = -radius, radius do
                if x*x + y*y + z*z <= radius*radius then
                    bl[#bl + 1] = {
                        name     = blockName,
                        position = { x = x * 2, y = y * 2 + radius * 2 + 2, z = z * 2 }
                    }
                end
            end
        end
    end
    return { version = "1.0", name = "Ball_r" .. radius, author = LP.Name, blocks = bl, welds = {} }
end

local function MakeBoatHull(blockName, len, w)
    local bl = {}
    -- Bottom floor
    for x = 0, len - 1 do
        for z = 0, w - 1 do
            bl[#bl + 1] = {
                name     = blockName,
                position = { x = (x - len / 2) * 4, y = 2, z = (z - w / 2) * 4 }
            }
        end
    end
    -- Side walls
    for x = 0, len - 1 do
        for y = 1, 3 do
            bl[#bl + 1] = {
                name     = blockName,
                position = { x = (x - len / 2) * 4, y = y * 2 + 2, z = (-w / 2) * 4 }
            }
            bl[#bl + 1] = {
                name     = blockName,
                position = { x = (x - len / 2) * 4, y = y * 2 + 2, z = (w / 2) * 4 }
            }
        end
    end
    return { version = "1.0", name = "BoatHull_" .. len .. "x" .. w, author = LP.Name, blocks = bl, welds = {} }
end

local function MakeStaircase(blockName, steps)
    local bl = {}
    for i = 0, steps - 1 do
        bl[#bl + 1] = {
            name     = blockName,
            position = { x = i * 4, y = i * 2 + 2, z = 0 }
        }
    end
    return { version = "1.0", name = "Staircase_" .. steps, author = LP.Name, blocks = bl, welds = {} }
end

local function MakePyramid(blockName, base)
    local bl = {}
    for layer = 0, base - 1 do
        local half = base - layer - 1
        for x = -half, half do
            for z = -half, half do
                bl[#bl + 1] = {
                    name     = blockName,
                    position = { x = x * 4, y = layer * 2 + 2, z = z * 4 }
                }
            end
        end
    end
    return { version = "1.0", name = "Pyramid_" .. base, author = LP.Name, blocks = bl, welds = {} }
end

-- ============================================================
-- BUILD ENGINE
-- ============================================================

local Builder = {
    delay   = 0.3,
    running = false,
    placed  = 0,
    failed  = 0,
}

function Builder:Start(data, onProgress)
    if self.running then
        Notify("OxyX", "A build is already running.", 2)
        return
    end
    if not data then return end

    -- Ensure BuildingTool is equipped
    local rf = GetRF()
    if not rf then rf = EquipBuildingTool() end
    if not rf then
        Notify("Error", "BuildingTool not found in Backpack.", 4)
        return
    end

    self.running = true
    self.placed  = 0
    self.failed  = 0

    local total = #data.blocks
    task.spawn(function()
        Notify("OxyX", "Starting build: " .. total .. " blocks", 2)
        for i, bi in ipairs(data.blocks) do
            if not self.running then break end

            local bd  = FindBlock(bi.name or bi.n or "Wood Block")
            local pos = bi.position or { x = 0, y = 2, z = 0 }
            local ox  = pos.x or 0
            local oy  = pos.y or 2
            local oz  = pos.z or 0
            local ry  = bi.rotation and (bi.rotation.y or 0) or 0

            local ok, msg = PlaceBlock(bd.n, ox, oy, oz, ry)
            if ok then
                self.placed = self.placed + 1
            else
                self.failed = self.failed + 1
                warn("[OxyX] Failed [" .. bd.n .. "]: " .. msg)
            end

            if onProgress then
                pcall(onProgress, i, total, bd.n, ok)
            end
            task.wait(self.delay)
        end
        self.running = false
        Notify("OxyX", "Done! Placed: " .. self.placed .. "  Failed: " .. self.failed, 4)
        if onProgress then pcall(onProgress, total, total, "DONE", true) end
    end)
end

function Builder:Stop()
    self.running = false
    Notify("OxyX", "Build stopped.", 2)
end

-- ============================================================
-- FILE HELPERS
-- ============================================================

local function MakeFolder(path)
    if makefolder then
        pcall(function()
            if not isfolder(path) then makefolder(path) end
        end)
    end
end

local function ListFiles(folder, ext)
    local out = {}
    if not listfiles then return out end
    pcall(function()
        for _, path in ipairs(listfiles(folder)) do
            local fname = path:match("([^/\\]+)$") or path
            if fname:lower():sub(-#ext) == ext:lower() then
                out[#out + 1] = { name = fname, path = path }
            end
        end
    end)
    return out
end

local function ReadFile(path)
    if readfile then
        local ok, text = pcall(readfile, path)
        if ok and text then return text end
    end
end

local function WriteFile(path, content)
    if writefile then
        pcall(writefile, path, content)
        return true
    end
    return false
end

-- ============================================================
-- STATE
-- ============================================================

local State = {
    activeTab   = "Build",
    buildData   = nil,
    minimized   = false,
    shapeType   = "Platform",
    shapeBlock  = "Wood Block",
    shapeW      = 5,
    shapeL      = 8,
    shapeR      = 3,
    shapeSteps  = 8,
    shapePyramid= 5,
}

-- Clean up old GUI instance
pcall(function()
    local old = GUI_PARENT:FindFirstChild("OxyX_v1")
    if old then old:Destroy() end
end)

MakeFolder("builds")
MakeFolder("json")

-- ============================================================
-- MAIN GUI
-- ============================================================

local ScreenGui = New("ScreenGui", {
    Name             = "OxyX_v1",
    DisplayOrder     = 9999,
    IgnoreGuiInset   = true,
    ResetOnSpawn     = false,
    ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
    Parent           = GUI_PARENT
})

local MainFrame = New("Frame", {
    Size             = UDim2.new(0, 500, 0, 620),
    Position         = UDim2.new(0.5, -250, 0.5, -310),
    BackgroundColor3 = BG0,
    BorderSizePixel  = 0,
    Parent           = ScreenGui
})
New("UICorner", { CornerRadius = UDim.new(0, 16), Parent = MainFrame })

-- Animated gradient border
local BorderFrame = New("Frame", {
    Size             = UDim2.new(1, 8, 1, 8),
    Position         = UDim2.new(0, -4, 0, -4),
    BackgroundColor3 = PRP,
    BorderSizePixel  = 0,
    ZIndex           = 0,
    Parent           = MainFrame
})
New("UICorner", { CornerRadius = UDim.new(0, 20), Parent = BorderFrame })

local BorderGradient = New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    PRP),
        ColorSequenceKeypoint.new(0.33, CYN),
        ColorSequenceKeypoint.new(0.66, PNK),
        ColorSequenceKeypoint.new(1,    PRP),
    }),
    Rotation = 0,
    Parent   = BorderFrame
})

local InnerFrame = New("Frame", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = BG0,
    BorderSizePixel  = 0,
    ZIndex           = 1,
    Parent           = MainFrame
})
New("UICorner", { CornerRadius = UDim.new(0, 16), Parent = InnerFrame })

-- Rotate gradient animation
local borderAngle = 0
RunService.Heartbeat:Connect(function(dt)
    borderAngle = (borderAngle + dt * 45) % 360
    pcall(function() BorderGradient.Rotation = borderAngle end)
end)

-- Background star particles
for i = 1, 22 do
    local sz   = math.random(1, 3)
    local star = New("Frame", {
        Size                 = UDim2.new(0, sz, 0, sz),
        Position             = UDim2.new(math.random() * 0.94, 0, math.random() * 0.94, 0),
        BackgroundColor3     = i % 3 == 0 and CYN or (i % 2 == 0 and LPRP or WHT),
        BackgroundTransparency = math.random() * 0.5 + 0.2,
        BorderSizePixel      = 0,
        ZIndex               = 2,
        Parent               = InnerFrame
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = star })
    task.spawn(function()
        while star and star.Parent do
            task.wait(1 + math.random() * 2)
            pcall(function()
                Tween(star, { BackgroundTransparency = 0.9 }, 0.4)
                task.wait(0.4)
                Tween(star, { BackgroundTransparency = math.random() * 0.4 + 0.1 }, 0.4)
            end)
        end
    end)
end

-- ============================================================
-- HEADER
-- ============================================================

local Header = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 88),
    BackgroundColor3 = BG1,
    BorderSizePixel  = 0,
    ZIndex           = 10,
    Parent           = InnerFrame
})
New("UICorner", { CornerRadius = UDim.new(0, 16), Parent = Header })
New("Frame", {
    Size             = UDim2.new(1, 0, 0, 20),
    Position         = UDim2.new(0, 0, 1, -20),
    BackgroundColor3 = BG1,
    BorderSizePixel  = 0,
    ZIndex           = 10,
    Parent           = Header
})

-- Avatar frame (Astolfo)
local AvatarFrame = New("Frame", {
    Size             = UDim2.new(0, 70, 0, 70),
    Position         = UDim2.new(0, 12, 0, 9),
    BackgroundColor3 = DPRP,
    BorderSizePixel  = 0,
    ZIndex           = 15,
    Parent           = Header
})
New("UICorner", { CornerRadius = UDim.new(0, 14), Parent = AvatarFrame })
local AvatarStroke = New("UIStroke", { Color = PNK, Thickness = 3, Parent = AvatarFrame })

local AvatarImg1 = New("ImageLabel", {
    Size                 = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image                = "rbxassetid://7078026274",
    ScaleType            = Enum.ScaleType.Crop,
    ZIndex               = 16,
    Parent               = AvatarFrame
})
New("UICorner", { CornerRadius = UDim.new(0, 12), Parent = AvatarImg1 })

local AvatarImg2 = New("ImageLabel", {
    Size                 = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image                = "rbxassetid://11832808662",
    ScaleType            = Enum.ScaleType.Crop,
    ImageTransparency    = 1,
    ZIndex               = 17,
    Parent               = AvatarFrame
})
New("UICorner", { CornerRadius = UDim.new(0, 12), Parent = AvatarImg2 })

-- Cycle avatar images
local avatarImages  = { "rbxassetid://7078026274", "rbxassetid://11832808662", "rbxassetid://6423102987" }
local avatarIndex   = 1
task.spawn(function()
    while AvatarImg1 and AvatarImg1.Parent do
        avatarIndex = avatarIndex % #avatarImages + 1
        pcall(function()
            AvatarImg2.Image            = avatarImages[avatarIndex]
            AvatarImg2.ImageTransparency = 1
            Tween(AvatarImg2, { ImageTransparency = 0 }, 0.5, Enum.EasingStyle.Sine)
            Tween(AvatarImg1, { ImageTransparency = 1 }, 0.5, Enum.EasingStyle.Sine)
        end)
        task.wait(0.6)
        pcall(function()
            AvatarImg1.Image            = avatarImages[avatarIndex]
            AvatarImg1.ImageTransparency = 0
            AvatarImg2.ImageTransparency = 1
        end)
        task.wait(1.4)
    end
end)

-- Cycle avatar border colour
task.spawn(function()
    local colors = { PNK, CYN, LPRP, GLD, PRP }
    local ci     = 1
    while AvatarStroke and AvatarStroke.Parent do
        ci = ci % #colors + 1
        Tween(AvatarStroke, { Color = colors[ci] }, 1, Enum.EasingStyle.Sine)
        task.wait(1.1)
    end
end)

-- Title labels
New("TextLabel", {
    Size                 = UDim2.new(0, 300, 0, 36),
    Position             = UDim2.new(0, 92, 0, 9),
    BackgroundTransparency = 1,
    Text                 = "OxyX",
    TextColor3           = WHT,
    Font                 = Enum.Font.GothamBold,
    TextScaled           = true,
    ZIndex               = 15,
    Parent               = Header
})
New("TextLabel", {
    Size                 = UDim2.new(0, 300, 0, 16),
    Position             = UDim2.new(0, 92, 0, 48),
    BackgroundTransparency = 1,
    Text                 = "Build A Boat For Treasure  -  v1.0",
    TextColor3           = TXT1,
    Font                 = Enum.Font.Gotham,
    TextScaled           = true,
    ZIndex               = 15,
    Parent               = Header
})

local RFStatusLabel = New("TextLabel", {
    Size                 = UDim2.new(0, 300, 0, 13),
    Position             = UDim2.new(0, 92, 0, 67),
    BackgroundTransparency = 1,
    Text                 = "Checking RF...",
    TextColor3           = YLW,
    Font                 = Enum.Font.GothamBold,
    TextSize             = 10,
    ZIndex               = 15,
    Parent               = Header
})

-- Minimize / Close buttons
local MinButton = New("TextButton", {
    Size             = UDim2.new(0, 28, 0, 28),
    Position         = UDim2.new(1, -66, 0, 12),
    BackgroundColor3 = BG3,
    BorderSizePixel  = 0,
    Text             = "-",
    TextColor3       = YLW,
    Font             = Enum.Font.GothamBold,
    TextSize         = 22,
    AutoButtonColor  = false,
    ZIndex           = 20,
    Parent           = Header
})
New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = MinButton })
New("UIStroke", { Color = YLW, Thickness = 1.5,  Parent = MinButton })

local CloseButton = New("TextButton", {
    Size             = UDim2.new(0, 28, 0, 28),
    Position         = UDim2.new(1, -34, 0, 12),
    BackgroundColor3 = BG3,
    BorderSizePixel  = 0,
    Text             = "X",
    TextColor3       = RED,
    Font             = Enum.Font.GothamBold,
    TextSize         = 14,
    AutoButtonColor  = false,
    ZIndex           = 20,
    Parent           = Header
})
New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = CloseButton })
New("UIStroke", { Color = RED, Thickness = 1.5,  Parent = CloseButton })

-- ============================================================
-- TAB BAR
-- ============================================================

local TabBar = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 38),
    Position         = UDim2.new(0, 0, 0, 88),
    BackgroundColor3 = BG1,
    BorderSizePixel  = 0,
    ZIndex           = 10,
    Parent           = InnerFrame
})
New("Frame", {
    Size             = UDim2.new(1, -12, 0, 1),
    Position         = UDim2.new(0, 6, 0, 0),
    BackgroundColor3 = BG3,
    BorderSizePixel  = 0,
    Parent           = TabBar
})

-- ============================================================
-- CONTENT SCROLL
-- ============================================================

local ContentFrame = New("ScrollingFrame", {
    Size                  = UDim2.new(1, 0, 1, -160),
    Position              = UDim2.new(0, 0, 0, 126),
    BackgroundColor3      = BG0,
    BorderSizePixel       = 0,
    ScrollBarThickness    = 4,
    ScrollBarImageColor3  = PRP,
    CanvasSize            = UDim2.new(1, 0, 0, 0),
    AutomaticCanvasSize   = Enum.AutomaticSize.Y,
    ZIndex                = 5,
    Parent                = InnerFrame
})

-- Progress bar
local ProgressBar = New("Frame", {
    Size             = UDim2.new(1, -20, 0, 8),
    Position         = UDim2.new(0, 10, 0, 128),
    BackgroundColor3 = BG3,
    BorderSizePixel  = 0,
    Visible          = false,
    ZIndex           = 12,
    Parent           = InnerFrame
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressBar })
local ProgressFill = New("Frame", {
    Size             = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = GRN,
    BorderSizePixel  = 0,
    Parent           = ProgressBar
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressFill })

local ProgressLabel = New("TextLabel", {
    Size                 = UDim2.new(1, -20, 0, 12),
    Position             = UDim2.new(0, 10, 0, 138),
    BackgroundTransparency = 1,
    Text                 = "",
    TextColor3           = TXT1,
    Font                 = Enum.Font.Gotham,
    TextSize             = 10,
    TextXAlignment       = Enum.TextXAlignment.Left,
    Visible              = false,
    ZIndex               = 12,
    Parent               = InnerFrame
})

-- Status bar
local StatusBar = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 34),
    Position         = UDim2.new(0, 0, 1, -34),
    BackgroundColor3 = BG1,
    BorderSizePixel  = 0,
    ZIndex           = 10,
    Parent           = InnerFrame
})
New("UICorner", { CornerRadius = UDim.new(0, 16), Parent = StatusBar })
New("Frame", {
    Size             = UDim2.new(1, 0, 0, 18),
    BackgroundColor3 = BG1,
    BorderSizePixel  = 0,
    ZIndex           = 10,
    Parent           = StatusBar
})
local StatusLabel = New("TextLabel", {
    Size                 = UDim2.new(1, -10, 1, 0),
    Position             = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text                 = "Ready  -  OxyX v1.0",
    TextColor3           = TXT1,
    Font                 = Enum.Font.Gotham,
    TextSize             = 11,
    TextXAlignment       = Enum.TextXAlignment.Left,
    ZIndex               = 15,
    Parent               = StatusBar
})

-- ============================================================
-- WIDGET FACTORY HELPERS
-- ============================================================

local Pages   = {}
local TabBtns = {}

local function MakePage(name)
    local page = New("Frame", {
        Name                 = "Page_" .. name,
        Size                 = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible              = false,
        Parent               = ContentFrame
    })
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = page })
    New("UIPadding", {
        PaddingLeft   = UDim.new(0, 10),
        PaddingRight  = UDim.new(0, 10),
        PaddingTop    = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 14),
        Parent        = page
    })
    Pages[name] = page
    return page
end

local function SectionHeader(parent, text)
    local f = New("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = BG2, BorderSizePixel = 0, Parent = parent })
    New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = f })
    local accent = New("Frame", { Size = UDim2.new(0, 4, 0.7, 0), Position = UDim2.new(0, 0, 0.15, 0), BackgroundColor3 = PRP, BorderSizePixel = 0, Parent = f })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accent })
    New("TextLabel", {
        Size                 = UDim2.new(1, -14, 1, 0),
        Position             = UDim2.new(0, 11, 0, 0),
        BackgroundTransparency = 1,
        Text                 = text,
        TextColor3           = LPRP,
        Font                 = Enum.Font.GothamBold,
        TextSize             = 12,
        TextXAlignment       = Enum.TextXAlignment.Left,
        Parent               = f
    })
    return f
end

local function MakeButton(parent, text, col, callback)
    col = col or PRP
    local r, g, b = col.R * 255, col.G * 255, col.B * 255
    local dark = c0(math.floor(r * 0.18), math.floor(g * 0.18), math.floor(b * 0.18))
    local mid  = c0(math.floor(r * 0.35), math.floor(g * 0.35), math.floor(b * 0.35))
    local btn  = New("TextButton", {
        Size             = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = dark,
        BorderSizePixel  = 0,
        Text             = text,
        TextColor3       = TXT0,
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        AutoButtonColor  = false,
        Parent           = parent
    })
    New("UICorner", { CornerRadius = UDim.new(0, 9), Parent = btn })
    New("UIStroke", { Color = col, Thickness = 1.5, Parent = btn })
    btn.MouseEnter:Connect(function()   Tween(btn, { BackgroundColor3 = mid  }, 0.12) end)
    btn.MouseLeave:Connect(function()   Tween(btn, { BackgroundColor3 = dark }, 0.12) end)
    btn.MouseButton1Down:Connect(function() Tween(btn, { BackgroundColor3 = col  }, 0.07) end)
    btn.MouseButton1Up:Connect(function()   Tween(btn, { BackgroundColor3 = mid  }, 0.10) end)
    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

local function MakeCard(parent, text)
    local f = New("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = BG2, BorderSizePixel = 0, Parent = parent })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = f })
    local lbl = New("TextLabel", {
        Size                 = UDim2.new(1, -14, 1, 0),
        Position             = UDim2.new(0, 7, 0, 0),
        BackgroundTransparency = 1,
        Text                 = text,
        TextColor3           = TXT1,
        Font                 = Enum.Font.Gotham,
        TextSize             = 11,
        TextWrapped          = true,
        TextXAlignment       = Enum.TextXAlignment.Left,
        Parent               = f
    })
    return f, lbl
end

local function MakeTextInput(parent, placeholder, height)
    local f = New("Frame", { Size = UDim2.new(1, 0, 0, height or 33), BackgroundColor3 = BG2, BorderSizePixel = 0, Parent = parent })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = f })
    local stroke = New("UIStroke", { Color = BG3, Thickness = 1.5, Parent = f })
    local tb = New("TextBox", {
        Size                 = UDim2.new(1, -14, 1, 0),
        Position             = UDim2.new(0, 7, 0, 0),
        BackgroundTransparency = 1,
        Text                 = "",
        PlaceholderText      = placeholder or "",
        PlaceholderColor3    = TXT2,
        TextColor3           = TXT0,
        Font                 = Enum.Font.Gotham,
        TextSize             = 12,
        ClearTextOnFocus     = false,
        Parent               = f
    })
    tb.Focused:Connect(function()   pcall(function() Tween(stroke, { Color = PRP }, 0.2) end) end)
    tb.FocusLost:Connect(function() pcall(function() Tween(stroke, { Color = BG3 }, 0.2) end) end)
    return tb
end

local function MakeBigTextInput(parent, placeholder)
    local f = New("Frame", { Size = UDim2.new(1, 0, 0, 85), BackgroundColor3 = BG2, BorderSizePixel = 0, Parent = parent })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = f })
    New("UIStroke", { Color = BG3, Thickness = 1.5, Parent = f })
    local tb = New("TextBox", {
        Size                 = UDim2.new(1, -10, 1, -6),
        Position             = UDim2.new(0, 5, 0, 3),
        BackgroundTransparency = 1,
        Text                 = "",
        PlaceholderText      = placeholder or "",
        PlaceholderColor3    = TXT2,
        TextColor3           = TXT0,
        Font                 = Enum.Font.Code,
        TextSize             = 10,
        MultiLine            = true,
        ClearTextOnFocus     = false,
        TextXAlignment       = Enum.TextXAlignment.Left,
        TextYAlignment       = Enum.TextYAlignment.Top,
        Parent               = f
    })
    return tb
end

local function MakeSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
    local val   = defaultVal
    local frame = New("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = BG2, BorderSizePixel = 0, Parent = parent })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = frame })
    New("TextLabel", {
        Size = UDim2.new(0.72, 0, 0, 16), Position = UDim2.new(0, 7, 0, 4),
        BackgroundTransparency = 1, Text = labelText, TextColor3 = TXT0,
        Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    local valLabel = New("TextLabel", {
        Size = UDim2.new(0.28, 0, 0, 16), Position = UDim2.new(0.72, 0, 0, 4),
        BackgroundTransparency = 1, Text = tostring(val), TextColor3 = CYN,
        Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
        Parent = frame
    })
    local track = New("Frame", { Size = UDim2.new(1, -14, 0, 6), Position = UDim2.new(0, 7, 0, 28), BackgroundColor3 = BG0, BorderSizePixel = 0, Parent = frame })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
    local fill = New("Frame", { Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0), BackgroundColor3 = PRP, BorderSizePixel = 0, Parent = track })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
    local knob = New("Frame", {
        Size = UDim2.new(0, 14, 0, 14), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((val - minVal) / (maxVal - minVal), 0, 0.5, 0),
        BackgroundColor3 = WHT, BorderSizePixel = 0, ZIndex = 10, Parent = track
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
    New("UIStroke", { Color = PRP, Thickness = 2, Parent = knob })
    local dragging = false
    local hitbox = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 18),
        BackgroundTransparency = 1, Text = "", ZIndex = 20, Parent = frame
    })
    hitbox.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.Heartbeat:Connect(function()
        if not dragging then return end
        pcall(function()
            local rx  = math.clamp((Mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            val       = math.floor(minVal + rx * (maxVal - minVal))
            valLabel.Text      = tostring(val)
            fill.Size          = UDim2.new(rx, 0, 1, 0)
            knob.Position      = UDim2.new(rx, 0, 0.5, 0)
            if callback then callback(val) end
        end)
    end)
end

-- File browser widget: shows .build AND .json files from a folder
local function MakeFileBrowser(parent, folder, ext, onLoad)
    local wrap = New("Frame", { Size = UDim2.new(1, 0, 0, 160), BackgroundColor3 = BG2, BorderSizePixel = 0, Parent = parent })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = wrap })
    New("UIStroke", { Color = PRP, Thickness = 1.5, Parent = wrap })

    local hdr = New("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = PRP, BorderSizePixel = 0, Parent = wrap })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = hdr })
    New("Frame", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = PRP, BorderSizePixel = 0, Parent = hdr })
    New("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 9, 0, 0),
        BackgroundTransparency = 1, Text = folder .. "/  [" .. ext .. "]",
        TextColor3 = WHT, Font = Enum.Font.GothamBold, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = hdr
    })
    local refreshBtn = New("TextButton", {
        Size = UDim2.new(0, 64, 0, 20), Position = UDim2.new(1, -68, 0.5, -10),
        BackgroundColor3 = DPRP, BorderSizePixel = 0, Text = "Refresh",
        TextColor3 = WHT, Font = Enum.Font.GothamBold, TextSize = 10,
        AutoButtonColor = false, Parent = hdr
    })
    New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = refreshBtn })

    local list = New("ScrollingFrame", {
        Size = UDim2.new(1, -6, 0, 125), Position = UDim2.new(0, 3, 0, 31),
        BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = PRP,
        CanvasSize = UDim2.new(1, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = wrap
    })
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = list })
    New("UIPadding", { PaddingAll = UDim.new(0, 3), Parent = list })

    local function Refresh()
        for _, child in ipairs(list:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        local files = ListFiles(folder, ext)
        -- Also include .json if browsing builds folder
        if ext == ".build" then
            for _, jf in ipairs(ListFiles(folder, ".json")) do
                local dup = false
                for _, bf in ipairs(files) do if bf.name == jf.name then dup = true; break end end
                if not dup then files[#files + 1] = jf end
            end
        end
        if #files == 0 then
            New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1,
                Text = "No " .. ext .. " files found in '" .. folder .. "' folder.",
                TextColor3 = TXT2, Font = Enum.Font.Gotham, TextSize = 11,
                TextWrapped = true, Parent = list
            })
            return
        end
        for _, file in ipairs(files) do
            local row = New("Frame", { Size = UDim2.new(1, -2, 0, 28), BackgroundColor3 = c0(13, 7, 38), BorderSizePixel = 0, Parent = list })
            New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = row })
            local labelColor = file.name:lower():sub(-6) == ".build" and GRN or CYN
            New("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1, Text = file.name, TextColor3 = labelColor,
                Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, Parent = row
            })
            local loadBtn = New("TextButton", {
                Size = UDim2.new(0, 62, 0, 20), Position = UDim2.new(1, -66, 0.5, -10),
                BackgroundColor3 = PRP, BorderSizePixel = 0, Text = "Load",
                TextColor3 = WHT, Font = Enum.Font.GothamBold, TextSize = 10,
                AutoButtonColor = false, Parent = row
            })
            New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = loadBtn })
            loadBtn.MouseButton1Click:Connect(function()
                local content = ReadFile(file.path) or ReadFile(folder .. "/" .. file.name)
                if content and onLoad then onLoad(file.name, content)
                else Notify("Error", "Could not read: " .. file.name, 3) end
            end)
            row.MouseEnter:Connect(function() Tween(row, { BackgroundColor3 = BG3 }, 0.1) end)
            row.MouseLeave:Connect(function() Tween(row, { BackgroundColor3 = c0(13, 7, 38) }, 0.1) end)
        end
    end
    Refresh()
    refreshBtn.MouseButton1Click:Connect(function() Refresh(); Notify("OxyX", "File list refreshed.", 2) end)
end

-- ============================================================
-- PAGE: BUILD
-- ============================================================

local BuildPage = MakePage("Build")

SectionHeader(BuildPage, "Load .build / .json file  (from builds/ folder)")
MakeFileBrowser(BuildPage, "builds", ".build", function(fname, content)
    local data, err = ParseBuildData(content)
    if data then
        State.buildData = data
        Notify("Loaded", fname .. "  |  " .. #data.blocks .. " blocks", 3)
        StatusLabel.Text = "Loaded: " .. fname .. "  |  " .. #data.blocks .. " blocks"
        -- Auto-start build
        local total = #data.blocks
        ProgressBar.Visible  = true
        ProgressLabel.Visible = true
        ProgressFill.Size    = UDim2.new(0, 0, 1, 0)
        Builder:Start(data, function(i, tot, name, ok)
            pcall(function()
                if name == "DONE" then
                    ProgressLabel.Text = "Complete!  Placed: " .. Builder.placed .. "  Failed: " .. Builder.failed
                    StatusLabel.Text   = "Done!  " .. Builder.placed .. "/" .. tot
                    task.delay(5, function() pcall(function() ProgressBar.Visible = false; ProgressLabel.Visible = false end) end)
                else
                    Tween(ProgressFill, { Size = UDim2.new(i / tot, 0, 1, 0) }, 0.1)
                    ProgressLabel.Text = "[" .. i .. "/" .. tot .. "]  " .. name
                    StatusLabel.Text   = "Building  [" .. i .. "/" .. tot .. "]"
                end
            end)
        end)
    else
        Notify("Error", err or "Parse failed", 3)
    end
end)

SectionHeader(BuildPage, "Paste JSON manually")
local pasteInput = MakeBigTextInput(BuildPage, '{"blocks":[{"name":"Wood Block","position":{"x":0,"y":2,"z":0}}]}')
MakeButton(BuildPage, "Parse and Load", CYN, function()
    local data, err = ParseBuildData(pasteInput.Text)
    if data then
        State.buildData = data
        Notify("Loaded", (data.name or "Build") .. "  |  " .. #data.blocks .. " blocks", 3)
    else
        Notify("Error", err or "Parse failed", 3)
    end
end)

SectionHeader(BuildPage, "Quick test build")
MakeButton(BuildPage, "Generate 5x5 Platform (test)", BG3, function()
    State.buildData = MakePlatform("Wood Block", 5, 5)
    Notify("OxyX", "5x5 platform ready (25 blocks)", 3)
    StatusLabel.Text = "Ready: 5x5 Platform  |  25 blocks"
end)

local _, buildStatusLabel = MakeCard(BuildPage, "No build data loaded")
RunService.Heartbeat:Connect(function()
    if State.buildData then
        pcall(function()
            buildStatusLabel.Text      = "Ready: " .. (State.buildData.name or "?") .. "  |  " .. #State.buildData.blocks .. " blocks"
            buildStatusLabel.TextColor3 = GRN
        end)
    end
end)

MakeSlider(BuildPage, "Delay per block (ms)", 100, 2000, 300, function(v) Builder.delay = v / 1000 end)

MakeButton(BuildPage, "START AUTO BUILD", GRN, function()
    if not State.buildData then
        Notify("Error", "No build data! Load a file or generate a shape first.", 3)
        return
    end
    local total = #State.buildData.blocks
    ProgressBar.Visible  = true
    ProgressLabel.Visible = true
    ProgressFill.Size    = UDim2.new(0, 0, 1, 0)
    StatusLabel.Text     = "Building  0/" .. total
    Builder:Start(State.buildData, function(i, tot, name, ok)
        pcall(function()
            if name == "DONE" then
                ProgressLabel.Text = "Complete!  Placed: " .. Builder.placed .. "  Failed: " .. Builder.failed
                StatusLabel.Text   = "Done!  " .. Builder.placed .. "/" .. tot
                task.delay(5, function() pcall(function() ProgressBar.Visible = false; ProgressLabel.Visible = false end) end)
            else
                Tween(ProgressFill, { Size = UDim2.new(i / tot, 0, 1, 0) }, 0.1)
                ProgressLabel.Text = "[" .. i .. "/" .. tot .. "]  " .. name
                StatusLabel.Text   = "Building  [" .. i .. "/" .. tot .. "]"
            end
        end)
    end)
end)

MakeButton(BuildPage, "STOP BUILD", YLW, function() Builder:Stop() end)
MakeButton(BuildPage, "Clear Data", RED, function()
    State.buildData         = nil
    buildStatusLabel.Text       = "No build data loaded"
    buildStatusLabel.TextColor3 = TXT1
    Notify("OxyX", "Build data cleared.", 2)
end)

-- ============================================================
-- PAGE: SHAPES
-- ============================================================

local ShapesPage = MakePage("Shapes")
SectionHeader(ShapesPage, "Shape Generator")

local shapeTypes  = { "Platform", "Ball", "BoatHull", "Staircase", "Pyramid" }
local shapeIndex  = 1
local shapeButton = MakeButton(ShapesPage, "Shape: Platform", BG2, nil)
shapeButton.MouseButton1Click:Connect(function()
    shapeIndex          = shapeIndex % #shapeTypes + 1
    State.shapeType     = shapeTypes[shapeIndex]
    shapeButton.Text    = "Shape: " .. State.shapeType
end)

local blockInput = MakeTextInput(ShapesPage, "Block name (e.g. Wood Block)")
blockInput.Text  = "Wood Block"
blockInput.FocusLost:Connect(function()
    local q = blockInput.Text:lower()
    for _, b in ipairs(BLOCKS) do
        if b.n:lower():find(q, 1, true) then
            State.shapeBlock = b.n
            blockInput.Text  = b.n
            break
        end
    end
end)

MakeSlider(ShapesPage, "Width / Radius / Steps", 1, 15, 5, function(v) State.shapeW = v; State.shapeR = v; State.shapeSteps = v end)
MakeSlider(ShapesPage, "Length / Base Size",     1, 20, 8, function(v) State.shapeL = v; State.shapePyramid = v end)

MakeButton(ShapesPage, "Generate and Build", GRN, function()
    local data
    local t = State.shapeType
    if     t == "Platform"  then data = MakePlatform(State.shapeBlock, State.shapeW, State.shapeL)
    elseif t == "Ball"      then data = MakeBall(State.shapeBlock, State.shapeR)
    elseif t == "BoatHull"  then data = MakeBoatHull(State.shapeBlock, State.shapeL, State.shapeW)
    elseif t == "Staircase" then data = MakeStaircase(State.shapeBlock, State.shapeSteps)
    elseif t == "Pyramid"   then data = MakePyramid(State.shapeBlock, State.shapePyramid)
    end
    if data then
        State.buildData = data
        Notify("OxyX", t .. "  |  " .. #data.blocks .. " blocks", 2)
        Builder:Start(data, function(i, tot, name)
            if name == "DONE" then Notify("OxyX", "Shape complete!", 3) end
        end)
    end
end)

MakeButton(ShapesPage, "Save to builds/ folder", PRP, function()
    local data
    local t = State.shapeType
    if     t == "Platform"  then data = MakePlatform(State.shapeBlock, State.shapeW, State.shapeL)
    elseif t == "Ball"      then data = MakeBall(State.shapeBlock, State.shapeR)
    elseif t == "BoatHull"  then data = MakeBoatHull(State.shapeBlock, State.shapeL, State.shapeW)
    elseif t == "Staircase" then data = MakeStaircase(State.shapeBlock, State.shapeSteps)
    elseif t == "Pyramid"   then data = MakePyramid(State.shapeBlock, State.shapePyramid)
    end
    if data then
        local json = HttpService:JSONEncode(data)
        if WriteFile("builds/" .. data.name .. ".build", json) then
            Notify("Saved", data.name .. ".build", 3)
        elseif setclipboard then
            setclipboard(json)
            Notify("Copied", "JSON copied to clipboard", 3)
        end
    end
end)

-- ============================================================
-- PAGE: CONVERT
-- ============================================================

local ConvertPage = MakePage("Convert")
SectionHeader(ConvertPage, "Import JSON file  (from json/ folder)")
MakeFileBrowser(ConvertPage, "json", ".json", function(fname, content)
    local ok, raw = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok then Notify("Error", "Invalid JSON file", 3); return end
    if raw.blocks and #raw.blocks > 0 then
        State.buildData = raw
        Notify("Imported", fname .. "  |  " .. #raw.blocks .. " blocks", 3)
        return
    end
    local bl = {}
    local function scan(obj, depth)
        if type(obj) ~= "table" or depth > 8 then return end
        if (obj.ClassName == "Part" or obj.ClassName == "MeshPart") then
            local bd = FindBlock(obj.Name or obj.name or "")
            bl[#bl + 1] = { name = bd.n, position = { x = 0, y = #bl * 2, z = 0 } }
        end
        for _, v in pairs(obj) do if type(v) == "table" then scan(v, depth + 1) end end
    end
    scan(raw, 0)
    if #bl > 0 then
        State.buildData = { version = "1.0", name = fname, author = LP.Name, blocks = bl, welds = {} }
        Notify("Converted", #bl .. " blocks extracted", 3)
    else
        Notify("Error", "No blocks found in file", 3)
    end
end)

MakeButton(ConvertPage, "Export my boat (zone-relative)", PRP, function()
    task.spawn(function()
        local zone = GetZone()
        local boat
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find(LP.Name, 1, true) then boat = v; break end
        end
        if not boat then Notify("Error", "Boat model not found in Workspace", 3); return end
        local bl       = {}
        local zoneTop  = zone and (zone.Position.Y + zone.Size.Y / 2) or 0
        local function scan(part)
            if part:IsA("BasePart") then
                local bd  = FindBlock(part.Name)
                local pos = part.CFrame.Position
                local ox  = zone and (pos.X - zone.Position.X) or pos.X
                local oy  = zone and (pos.Y - zoneTop) or pos.Y
                local oz  = zone and (pos.Z - zone.Position.Z) or pos.Z
                bl[#bl + 1] = {
                    name     = bd.n,
                    position = { x = math.floor(ox * 10) / 10, y = math.floor(oy * 10) / 10, z = math.floor(oz * 10) / 10 }
                }
            end
            for _, child in ipairs(part:GetChildren()) do scan(child) end
        end
        for _, child in ipairs(boat:GetChildren()) do scan(child) end
        local json = HttpService:JSONEncode({ version = "1.0", name = boat.Name, author = LP.Name, blocks = bl, welds = {} })
        local filename = boat.Name:gsub(" ", "_")
        if WriteFile("builds/" .. filename .. ".build", json) then
            Notify("Exported", filename .. ".build  |  " .. #bl .. " blocks", 4)
        elseif setclipboard then
            setclipboard(json)
            Notify("Copied", "Export JSON copied to clipboard  |  " .. #bl .. " blocks", 4)
        end
    end)
end)

-- ============================================================
-- PAGE: BLOCKS
-- ============================================================

local BlocksPage = MakePage("Blocks")
SectionHeader(BlocksPage, "Block List  (159 blocks)")

local blockSearch = MakeTextInput(BlocksPage, "Search block name...")
local blockListFrame = New("Frame", { Size = UDim2.new(1, 0, 0, 280), BackgroundColor3 = BG2, BorderSizePixel = 0, Parent = BlocksPage })
New("UICorner", { CornerRadius = UDim.new(0, 9), Parent = blockListFrame })

local blockScroll = New("ScrollingFrame", {
    Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2),
    BackgroundTransparency = 1, ScrollBarThickness = 4, ScrollBarImageColor3 = PRP,
    CanvasSize = UDim2.new(1, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = blockListFrame
})
New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = blockScroll })
New("UIPadding", { PaddingAll = UDim.new(0, 3), Parent = blockScroll })

local function RenderBlockList(filter)
    for _, child in ipairs(blockScroll:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
    end
    filter = (filter or ""):lower()
    for _, bl in ipairs(BLOCKS) do
        if filter == "" or bl.n:lower():find(filter, 1, true) then
            local row = New("Frame", { Size = UDim2.new(1, -2, 0, 26), BackgroundColor3 = c0(11, 7, 33), BorderSizePixel = 0, Parent = blockScroll })
            New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })
            New("TextLabel", {
                Size = UDim2.new(0, 30, 0, 14), Position = UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = DPRP, BorderSizePixel = 0,
                Text = "#" .. bl.id, TextColor3 = LPRP, Font = Enum.Font.GothamBold, TextSize = 8, Parent = row
            })
            New("TextLabel", {
                Size = UDim2.new(0.55, 0, 1, 0), Position = UDim2.new(0, 35, 0, 0),
                BackgroundTransparency = 1, Text = bl.n, TextColor3 = TXT0,
                Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, Parent = row
            })
            New("TextLabel", {
                Size = UDim2.new(0.3, 0, 0, 12), Position = UDim2.new(0.62, 0, 0.5, -6),
                BackgroundColor3 = BG0, BorderSizePixel = 0,
                Text = bl.cat, TextColor3 = TXT2, Font = Enum.Font.Gotham, TextSize = 8, Parent = row
            })
            row.MouseEnter:Connect(function() Tween(row, { BackgroundColor3 = BG3 }, 0.1) end)
            row.MouseLeave:Connect(function() Tween(row, { BackgroundColor3 = c0(11, 7, 33) }, 0.1) end)
        end
    end
end
RenderBlockList("")
blockSearch.Changed:Connect(function(prop)
    if prop == "Text" then pcall(function() RenderBlockList(blockSearch.Text) end) end
end)

-- ============================================================
-- PAGE: INFO
-- ============================================================

local InfoPage = MakePage("Info")
SectionHeader(InfoPage, "OxyX  v1.0  -  Build A Boat For Treasure")
New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundTransparency = 1,
    Text = table.concat({
        "Auto-builder for BABFT  |  159 blocks supported",
        "RF Engine : BuildingTool.RF (confirmed working)",
        "Coordinates in .build files are zone-relative offsets.",
        "  x / z = horizontal offset from zone center",
        "  y     = height above zone floor  (y=2 recommended)",
        "Place .build files in the executor's 'builds' folder.",
        "RightShift = toggle GUI visibility.",
    }, "\n"),
    TextColor3 = TXT1,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = InfoPage
})
MakeButton(InfoPage, "Copy loader URL", CYN, function()
    if setclipboard then
        setclipboard("https://raw.githubusercontent.com/johsua092-ui/oxyX-sc/refs/heads/main/OxyX_BABFT.lua")
        Notify("Copied", "GitHub URL copied to clipboard", 3)
    end
end)
MakeButton(InfoPage, "Reload script", PRP, function()
    Notify("OxyX", "Reloading...", 2)
    task.delay(0.4, function()
        pcall(function() ScreenGui:Destroy() end)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/johsua092-ui/oxyX-sc/refs/heads/main/OxyX_BABFT.lua"))()
    end)
end)

-- ============================================================
-- TAB SYSTEM
-- ============================================================

local TAB_DEFS = {
    { n = "Build",   label = "Build"   },
    { n = "Shapes",  label = "Shapes"  },
    { n = "Convert", label = "Convert" },
    { n = "Blocks",  label = "Blocks"  },
    { n = "Info",    label = "Info"    },
}

local function SwitchTab(name)
    State.activeTab = name
    for _, page in pairs(Pages) do
        pcall(function() page.Visible = false end)
    end
    for tabName, btn in pairs(TabBtns) do
        pcall(function()
            if tabName == name then
                Tween(btn, { BackgroundColor3 = PRP }, 0.2)
                btn.TextColor3 = WHT
            else
                Tween(btn, { BackgroundColor3 = BG3 }, 0.2)
                btn.TextColor3 = TXT2
            end
        end)
    end
    if Pages[name] then Pages[name].Visible = true end
    StatusLabel.Text = name .. "  -  OxyX v1.0"
end

for i, td in ipairs(TAB_DEFS) do
    local btn = New("TextButton", {
        Size             = UDim2.new(0, 92, 0, 28),
        Position         = UDim2.new(0, 6 + (i - 1) * 97, 0, 4),
        BackgroundColor3 = BG3,
        BorderSizePixel  = 0,
        Text             = td.label,
        TextColor3       = TXT2,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        AutoButtonColor  = false,
        ZIndex           = 15,
        Parent           = TabBar
    })
    New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = btn })
    TabBtns[td.n] = btn
    btn.MouseButton1Click:Connect(function() SwitchTab(td.n) end)
end

-- ============================================================
-- DRAGGING
-- ============================================================

local isDragging    = false
local dragOffset    = Vector2.new(0, 0)

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragOffset = Vector2.new(Mouse.X - MainFrame.AbsolutePosition.X, Mouse.Y - MainFrame.AbsolutePosition.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
end)
RunService.Heartbeat:Connect(function()
    if isDragging and MainFrame and MainFrame.Parent then
        pcall(function()
            local vp = Cam.ViewportSize
            MainFrame.Position = UDim2.new(
                0, math.clamp(Mouse.X - dragOffset.X, 0, vp.X - MainFrame.AbsoluteSize.X),
                0, math.clamp(Mouse.Y - dragOffset.Y, 0, vp.Y - MainFrame.AbsoluteSize.Y)
            )
        end)
    end
end)

-- ============================================================
-- MINIMIZE / CLOSE
-- ============================================================

MinButton.MouseButton1Click:Connect(function()
    State.minimized = not State.minimized
    if State.minimized then
        Tween(MainFrame, { Size = UDim2.new(0, 500, 0, 88) }, 0.28, Enum.EasingStyle.Back)
        MinButton.Text = "[ ]"
    else
        Tween(MainFrame, { Size = UDim2.new(0, 500, 0, 620) }, 0.30, Enum.EasingStyle.Back)
        MinButton.Text = "-"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    Tween(MainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.22)
    task.delay(0.25, function() pcall(function() ScreenGui:Destroy() end) end)
end)

-- RightShift hotkey: toggle visibility
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    pcall(function()
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
end)

-- ============================================================
-- LIVE RF STATUS LABEL
-- ============================================================

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        local rf   = GetRF()
        local zone = GetZone()
        if rf and zone then
            RFStatusLabel.Text      = "RF: Ready  |  Zone: " .. zone.Name
            RFStatusLabel.TextColor3 = GRN
        elseif rf then
            RFStatusLabel.Text      = "RF: Ready  |  Zone: not detected"
            RFStatusLabel.TextColor3 = YLW
        else
            RFStatusLabel.Text      = "RF: BuildingTool not in Backpack"
            RFStatusLabel.TextColor3 = RED
        end
        task.wait(3)
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================

SwitchTab("Build")
Notify("OxyX v1.0", "Loaded. Place .build files in the 'builds' folder.", 5)

-- ============================================================
-- END OF SCRIPT
-- ============================================================
