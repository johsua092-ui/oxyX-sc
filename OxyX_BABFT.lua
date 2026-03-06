--[[
  OxyX BABFT Tool v5.0 — GALAXY EDITION (FIXED)
  - Tab layout rapi
  - Inventory scanner otomatis
  - Auto‑build dari file .txt / .json
  - Astolfo animated (tombol lucu)
  - Kompatibel Luau + executor
]]

-- ==================== LAYANAN & UTILITY ====================
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local TweenService  = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService   = game:GetService("HttpService")
local Workspace     = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cari CoreGui atau PlayerGui (aman untuk executor)
local CoreGui = game:GetService("CoreGui")
local GP = (CoreGui and not CoreGui:FindFirstChildWhichIsA("ScreenGui")) and CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Deteksi executor (untuk fungsi file system)
local EXECUTOR = "Unknown"
pcall(function()
    if identifyexecutor then EXECUTOR = identifyexecutor()
    elseif syn then EXECUTOR = "Synapse X"
    elseif KRNL_LOADED then EXECUTOR = "Krnl"
    elseif getexecutorname then EXECUTOR = getexecutorname()
    elseif isfolder then EXECUTOR = "Executor with file functions"
    end
end)

-- ==================== WARNA TEMA ====================
local C = {
    BG0   = Color3.fromRGB(5,3,18),   BG1   = Color3.fromRGB(10,6,30),
    BG2   = Color3.fromRGB(17,10,48),  BG3   = Color3.fromRGB(28,17,68),
    PRP   = Color3.fromRGB(140,44,230), DPRP  = Color3.fromRGB(70,0,130),
    LPRP  = Color3.fromRGB(190,110,255), CYN   = Color3.fromRGB(0,205,255),
    PNK   = Color3.fromRGB(255,95,180),  GLD   = Color3.fromRGB(255,200,55),
    GRN   = Color3.fromRGB(70,225,115),  RED   = Color3.fromRGB(255,65,65),
    YLW   = Color3.fromRGB(255,210,50),  WHT   = Color3.fromRGB(255,255,255),
    TXT0  = Color3.fromRGB(238,228,255), TXT1  = Color3.fromRGB(165,148,215),
    TXT2  = Color3.fromRGB(90,72,138),
}

-- ==================== FUNGSI PEMBANTU ====================
local function New(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            pcall(function() obj[k] = v end)
        end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(obj, goal, time, easing)
    if not obj or not obj.Parent then return end
    time = time or 0.25
    easing = easing or Enum.EasingStyle.Quad
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(time, easing, Enum.EasingDirection.Out), goal):Play()
    end)
end

local function Notify(title, msg, duration)
    duration = duration or 3
    task.spawn(function()
        pcall(function()
            local ng = New("ScreenGui", {
                Name = "OxNotify" .. tick(),
                ResetOnSpawn = false,
                DisplayOrder = 99999,
                IgnoreGuiInset = true,
                Parent = GP
            })
            local nf = New("Frame", {
                Size = UDim2.new(0,288,0,66),
                Position = UDim2.new(1,10,1,-86),
                BackgroundColor3 = C.BG1,
                BorderSizePixel = 0,
                Parent = ng
            })
            New("UICorner", { CornerRadius = UDim.new(0,12), Parent = nf })
            New("UIStroke", { Color = C.PRP, Thickness = 1.5, Parent = nf })
            local lb = New("Frame", {
                Size = UDim2.new(0,4,0.76,0),
                Position = UDim2.new(0,0,0.12,0),
                BackgroundColor3 = C.LPRP,
                BorderSizePixel = 0,
                Parent = nf
            })
            New("UICorner", { CornerRadius = UDim.new(1,0), Parent = lb })
            New("UIGradient", {
                Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.CYN), ColorSequenceKeypoint.new(1, C.PRP)}),
                Rotation = 90,
                Parent = lb
            })
            New("TextLabel", {
                Size = UDim2.new(1,-14,0,20),
                Position = UDim2.new(0,10,0,4),
                BackgroundTransparency = 1,
                Text = "✦ " .. title,
                TextColor3 = C.LPRP,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = nf
            })
            New("TextLabel", {
                Size = UDim2.new(1,-14,0,30),
                Position = UDim2.new(0,10,0,24),
                BackgroundTransparency = 1,
                Text = msg,
                TextColor3 = C.TXT1,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = nf
            })
            local pg = New("Frame", {
                Size = UDim2.new(1,-6,0,3),
                Position = UDim2.new(0,3,1,-3),
                BackgroundColor3 = C.PRP,
                BorderSizePixel = 0,
                Parent = nf
            })
            New("UICorner", { CornerRadius = UDim.new(1,0), Parent = pg })
            New("UIGradient", {
                Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.PRP), ColorSequenceKeypoint.new(1, C.CYN)}),
                Parent = pg
            })
            Tween(nf, { Position = UDim2.new(1,-298,1,-86) }, 0.3)
            Tween(pg, { Size = UDim2.new(0,0,0,3) }, duration)
            task.delay(duration, function()
                Tween(nf, { Position = UDim2.new(1,10,1,-86) }, 0.25)
                task.wait(0.28)
                ng:Destroy()
            end)
        end)
    end)
end

-- ==================== DATABASE BLOK BABFT ====================
local DB = {
    {id=1, n="Back Wheel", cat="Wheels"},{id=2, n="Balloon Block", cat="Special"},
    {id=3, n="Bar", cat="Structure"},{id=4, n="Big Cannon", cat="Weapons"},
    {id=5, n="Big Switch", cat="Electronics"},{id=6, n="Blue Candy", cat="Candy"},
    {id=7, n="Boat Motor", cat="Propulsion"},{id=8, n="Bouncy Block", cat="Special"},
    {id=9, n="Boxing Glove", cat="Weapons"},{id=10, n="Bread", cat="Food"},
    {id=11, n="Brick Block", cat="Structure"},{id=12, n="Bundles of Potions", cat="Special"},
    {id=13, n="Button", cat="Electronics"},{id=14, n="Cake", cat="Food"},
    {id=15, n="Camera", cat="Special"},{id=16, n="Candle", cat="Decoration"},
    {id=17, n="Candy Cane Block", cat="Candy"},{id=18, n="Candy Cane Rod", cat="Candy"},
    {id=19, n="Cannon", cat="Weapons"},{id=20, n="Car Seat", cat="Seats"},
    {id=21, n="Chair", cat="Seats"},{id=22, n="Classic Firework", cat="Fireworks"},
    {id=23, n="Coal Block", cat="Structure"},{id=24, n="Common Chest Block", cat="Chests"},
    {id=25, n="Concrete Block", cat="Structure"},{id=26, n="Concrete Rod", cat="Structure"},
    {id=27, n="Cookie Back Wheel", cat="Wheels"},{id=28, n="Cookie Front Wheel", cat="Wheels"},
    {id=29, n="Corner Wedge", cat="Structure"},{id=30, n="Delay Block", cat="Electronics"},
    {id=31, n="Dome Camera", cat="Special"},{id=32, n="Door", cat="Structure"},
    {id=33, n="Dragon Egg", cat="Special"},{id=34, n="Dragon Harpoon", cat="Weapons"},
    {id=35, n="Dual Candy Cane Harpoon", cat="Weapons"},{id=36, n="Dynamite", cat="Weapons"},
    {id=37, n="Easter Jetpack", cat="Propulsion"},{id=38, n="Egg Cannon", cat="Weapons"},
    {id=39, n="Epic Chest Block", cat="Chests"},{id=40, n="Fabric Block", cat="Structure"},
    {id=41, n="Firework 1", cat="Fireworks"},{id=42, n="Firework 2", cat="Fireworks"},
    {id=43, n="Firework 3", cat="Fireworks"},{id=44, n="Firework 4", cat="Fireworks"},
    {id=45, n="Flag", cat="Decoration"},{id=46, n="Front Wheel", cat="Wheels"},
    {id=47, n="Gameboard", cat="Special"},{id=48, n="Glass Block", cat="Structure"},
    {id=49, n="Glue", cat="Electronics"},{id=50, n="Gold Block", cat="Structure"},
    {id=51, n="Golden Harpoon", cat="Weapons"},{id=52, n="Grass Block", cat="Structure"},
    {id=53, n="Harpoon", cat="Weapons"},{id=54, n="Hatch", cat="Structure"},
    {id=55, n="Heart", cat="Decoration"},{id=56, n="Helm", cat="Special"},
    {id=57, n="Hinge", cat="Electronics"},{id=58, n="Huge Back Wheel", cat="Wheels"},
    {id=59, n="Huge Front Wheel", cat="Wheels"},{id=60, n="Huge Wheel", cat="Wheels"},
    {id=61, n="I-Beam", cat="Structure"},{id=62, n="Ice Block", cat="Structure"},
    {id=63, n="Jet Turbine", cat="Propulsion"},{id=64, n="Jetpack", cat="Propulsion"},
    {id=65, n="Lamp", cat="Decoration"},{id=66, n="Large Treasure", cat="Treasure"},
    {id=67, n="Laser Launcher", cat="Weapons"},{id=68, n="Legendary Chest Block", cat="Chests"},
    {id=69, n="Lever", cat="Electronics"},{id=70, n="Life Preserver", cat="Special"},
    {id=71, n="Light Bulb", cat="Decoration"},{id=72, n="Locked Door", cat="Structure"},
    {id=73, n="Magnet", cat="Special"},{id=74, n="Marble Block", cat="Structure"},
    {id=75, n="Marble Rod", cat="Structure"},{id=76, n="Mast", cat="Structure"},
    {id=77, n="Master Builder Trophy", cat="Trophies"},{id=78, n="Medium Treasure", cat="Treasure"},
    {id=79, n="Mega Thruster", cat="Propulsion"},{id=80, n="Metal Block", cat="Structure"},
    {id=81, n="Metal Rod", cat="Structure"},{id=82, n="Mini Gun", cat="Weapons"},
    {id=83, n="Mounted Bow", cat="Weapons"},{id=84, n="Mounted Candy Cane Sword", cat="Weapons"},
    {id=85, n="Mounted Cannon", cat="Weapons"},{id=86, n="Mounted Flintlocks", cat="Weapons"},
    {id=87, n="Mounted Knight Sword", cat="Weapons"},{id=88, n="Mounted Sword", cat="Weapons"},
    {id=89, n="Mounted Wizard Staff", cat="Weapons"},{id=90, n="Music Note", cat="Decoration"},
    {id=91, n="Mystery Box", cat="Special"},{id=92, n="Neon Block", cat="Structure"},
    {id=93, n="Obsidian Block", cat="Structure"},{id=94, n="Orange Candy", cat="Candy"},
    {id=95, n="Parachute Block", cat="Special"},{id=96, n="Peppermint Back Wheel", cat="Wheels"},
    {id=97, n="Peppermint Front Wheel", cat="Wheels"},{id=98, n="Pilot Seat", cat="Seats"},
    {id=99, n="Pine Tree", cat="Decoration"},{id=100, n="Pink Candy", cat="Candy"},
    {id=101, n="Piston", cat="Electronics"},{id=102, n="Plastic Block", cat="Structure"},
    {id=103, n="Plushie 1", cat="Decoration"},{id=104, n="Plushie 2", cat="Decoration"},
    {id=105, n="Plushie 3", cat="Decoration"},{id=106, n="Plushie 4", cat="Decoration"},
    {id=107, n="Portal", cat="Special"},{id=108, n="Pumpkin", cat="Decoration"},
    {id=109, n="Purple Candy", cat="Candy"},{id=110, n="Rare Chest Block", cat="Chests"},
    {id=111, n="Red Candy", cat="Candy"},{id=112, n="Rope", cat="Structure"},
    {id=113, n="Rusted Block", cat="Structure"},{id=114, n="Rusted Rod", cat="Structure"},
    {id=115, n="Sand Block", cat="Structure"},{id=116, n="Seat", cat="Seats"},
    {id=117, n="Servo", cat="Electronics"},{id=118, n="Shield Generator", cat="Special"},
    {id=119, n="Sign", cat="Decoration"},{id=120, n="Small Treasure", cat="Treasure"},
    {id=121, n="Smooth Wood Block", cat="Structure"},{id=122, n="Snowball Launcher", cat="Weapons"},
    {id=123, n="Soccer Ball", cat="Special"},{id=124, n="Sonic Jet Turbine", cat="Propulsion"},
    {id=125, n="Spike Trap", cat="Weapons"},{id=126, n="Spooky Thruster", cat="Propulsion"},
    {id=127, n="Star", cat="Decoration"},{id=128, n="Star Balloon Block", cat="Special"},
    {id=129, n="Star Jetpack", cat="Propulsion"},{id=130, n="Steampunk Jetpack", cat="Propulsion"},
    {id=131, n="Step", cat="Structure"},{id=132, n="Stone Block", cat="Structure"},
    {id=133, n="Stone Rod", cat="Structure"},{id=134, n="Suspension", cat="Electronics"},
    {id=135, n="Switch", cat="Electronics"},{id=136, n="Throne", cat="Seats"},
    {id=137, n="Thruster", cat="Propulsion"},{id=138, n="Titanium Block", cat="Structure"},
    {id=139, n="Titanium Rod", cat="Structure"},{id=140, n="TNT", cat="Weapons"},
    {id=141, n="Torch", cat="Decoration"},{id=142, n="Toy Block", cat="Structure"},
    {id=143, n="Treasure Chest", cat="Treasure"},{id=144, n="Trophy 1st", cat="Trophies"},
    {id=145, n="Trophy 2nd", cat="Trophies"},{id=146, n="Trophy 3rd", cat="Trophies"},
    {id=147, n="Truss", cat="Structure"},{id=148, n="Ultra Boat Motor", cat="Propulsion"},
    {id=149, n="Ultra Jetpack", cat="Propulsion"},{id=150, n="Ultra Thruster", cat="Propulsion"},
    {id=151, n="Uncommon Chest Block", cat="Chests"},{id=152, n="Wedge", cat="Structure"},
    {id=153, n="Wheel", cat="Wheels"},{id=154, n="Window", cat="Structure"},
    {id=155, n="Winter Boat Motor", cat="Propulsion"},{id=156, n="Winter Jet Turbine", cat="Propulsion"},
    {id=157, n="Winter Thruster", cat="Propulsion"},{id=158, n="Wood Block", cat="Structure"},
    {id=159, n="Wood Rod", cat="Structure"},
}

-- Index berdasarkan nama (lowercase)
local DBByName = {}
for _, b in ipairs(DB) do
    DBByName[b.n:lower()] = b
end

local function FindBlock(name)
    if not name then return DB[158] end
    local lo = name:lower()
    if DBByName[lo] then return DBByName[lo] end
    -- fallback partial match
    for k, v in pairs(DBByName) do
        if k:find(lo, 1, true) or lo:find(k, 1, true) then
            return v
        end
    end
    return DB[158] -- wood block default
end

-- ==================== INVENTORY SCANNER ====================
local Inventory = {}  -- key = nama blok, value = { block = DB entry, btn = GUI button, count = number }

local function ScanInventory()
    Inventory = {}

    -- METHOD 1: RemoteFunction inventory (server-side)
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteFunction") then
            local lo = v.Name:lower()
            if lo:find("getinv") or lo:find("getblock") or lo:find("owned") or lo:find("inventory") then
                pcall(function()
                    local result = v:InvokeServer()
                    if type(result) == "table" then
                        for key, val in pairs(result) do
                            local name = (type(key) == "string" and key) or (type(val) == "string" and val) or nil
                            if name then
                                local bd = FindBlock(name)
                                if bd and not Inventory[bd.n] then
                                    Inventory[bd.n] = { block = bd, count = (type(val) == "number" and val) or 99 }
                                end
                            end
                        end
                    end
                end)
            end
        end
    end

    -- METHOD 2: Scan GUI inventory (tombol blok)
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and not gui.Name:match("OxyX") then
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("ImageButton") or obj:IsA("TextButton") then
                    local exact = DBByName[obj.Name:lower()]
                    if exact and not Inventory[exact.n] then
                        local visible = true
                        pcall(function() visible = obj.Visible and obj.Active ~= false end)
                        if visible then
                            Inventory[exact.n] = { block = exact, btn = obj, count = 99 }
                        end
                    end
                end
            end
        end
    end

    -- METHOD 3: Nilai di player (IntValue/NumberValue)
    for _, child in ipairs(LocalPlayer:GetChildren()) do
        pcall(function()
            for _, v in ipairs(child:GetDescendants()) do
                local exact = DBByName[v.Name:lower()]
                if exact and not Inventory[exact.n] then
                    if (v:IsA("IntValue") or v:IsA("NumberValue")) and v.Value > 0 then
                        Inventory[exact.n] = { block = exact, count = v.Value }
                    end
                end
            end
        end)
    end

    -- FALLBACK: jika tidak ada satupun, beri blok dasar
    if next(Inventory) == nil then
        local defaults = {
            "Wood Block","Metal Block","Stone Block","Glass Block","Plastic Block",
            "Brick Block","Concrete Block","Smooth Wood Block","Fabric Block",
            "Thruster","Boat Motor","Wheel","Front Wheel","Back Wheel","Helm",
            "Cannon","Button","Switch","Seat","Pilot Seat"
        }
        for _, n in ipairs(defaults) do
            local b = FindBlock(n)
            if b then Inventory[b.n] = { block = b, count = 99 } end
        end
    end

    local count = 0
    for _ in pairs(Inventory) do count = count + 1 end
    return count
end

-- ==================== REMOTE PLACE BLOCK ====================
local PlaceRemote = nil
local function GetPlaceRemote()
    if PlaceRemote and PlaceRemote.Parent then return PlaceRemote end
    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local lo = r.Name:lower()
            if lo == "placeblock" or lo == "addblock" or lo == "spawnblock" then
                PlaceRemote = r
                return r
            end
        end
    end
    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local lo = r.Name:lower()
            if (lo:find("place") or lo:find("build") or lo:find("block")) and not lo:find("break") then
                PlaceRemote = r
                return r
            end
        end
    end
    return nil
end

local function ClickBlock(blockName)
    -- Cara 1: klik tombol inventory yang sudah discan
    local entry = Inventory[blockName]
    if entry and entry.btn then
        local btn = entry.btn
        if btn and btn.Parent then
            pcall(function() btn.MouseButton1Click:Fire() end)
            return true
        end
    end

    -- Cara 2: scan ulang GUI
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and not gui.Name:match("OxyX") then
            for _, obj in ipairs(gui:GetDescendants()) do
                if (obj:IsA("ImageButton") or obj:IsA("TextButton")) then
                    local exact = DBByName[obj.Name:lower()]
                    if exact and exact.n == blockName then
                        pcall(function() obj.MouseButton1Click:Fire() end)
                        return true
                    end
                end
            end
        end
    end

    -- Cara 3: fire remote
    local rem = GetPlaceRemote()
    if rem then
        local bd = FindBlock(blockName)
        local success = pcall(function()
            rem:FireServer(bd.n)  -- coba nama saja
        end)
        if not success then
            pcall(function()
                rem:FireServer({ Name = bd.n, BlockName = bd.n, Id = bd.id, BlockId = bd.id })
            end)
        end
        return true
    end

    return false
end

-- ==================== PLACER (AUTO BUILD) ====================
local Placer = {
    delay = 0.15,
    running = false,
    placed = 0,
    failed = 0,
    currentBuild = nil,
    onProgress = nil
}

function Placer:PlaceOne(blockDef)
    local name = blockDef.n
    -- jika tidak punya, cari kategori sama
    if not Inventory[name] then
        for invName, _ in pairs(Inventory) do
            if FindBlock(invName).cat == blockDef.cat then
                name = invName
                break
            end
        end
        -- masih tidak ada, ambil blok pertama
        if not Inventory[name] then
            for invName, _ in pairs(Inventory) do
                name = invName
                break
            end
        end
    end

    local ok = ClickBlock(name)
    if ok then
        self.placed = self.placed + 1
    else
        self.failed = self.failed + 1
    end
    return ok, name
end

function Placer:Build(buildData, callback)
    if self.running then
        Notify("Build", "Proses 
