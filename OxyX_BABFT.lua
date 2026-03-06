--[[
╔══════════════════════════════════════════════════════╗
║   ██████╗ ██╗  ██╗██╗   ██╗██╗  ██╗                 ║
║  ██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝╚██╗██╔╝                 ║
║  ██║   ██║ ╚███╔╝  ╚████╔╝  ╚███╔╝                  ║
║  ██║   ██║ ██╔██╗   ╚██╔╝   ██╔██╗                  ║
║  ╚██████╔╝██╔╝ ██╗   ██║   ██╔╝ ██╗                 ║
║   ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝                 ║
║                                                      ║
║   OxyX BABFT Tool  v3.0  ── GALAXY FINAL EDITION     ║
║   File Browser .build & .json | Inventory Auto-Build ║
║   Astolfo GIF Header | Premium Galaxy UI             ║
║   Compatible: Xeno, Synapse X, KRNL, Delta, Fluxus   ║
╚══════════════════════════════════════════════════════╝

FITUR v3.0:
  ✦ File Browser → folder "builds/" untuk .build saja
  ✦ File Browser → folder "json/"   untuk .json saja
  ✦ Auto Build memakai block dari INVENTORY player sendiri
  ✦ Progress bar animasi saat build berlangsung
  ✦ Astolfo GIF animated di header (shimmer + glow)
  ✦ UI Premium: glassmorphism, glow border, nebula BG
  ✦ 159 block database + warna inventory (hijau=punya)
  ✦ Scan inventory BABFT otomatis via RemoteFunction
]]

-- ═══════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UIS            = game:GetService("UserInputService")
local HttpService    = game:GetService("HttpService")
local WS             = game:GetService("Workspace")
local RS             = game:GetService("ReplicatedStorage")
local Debris         = game:GetService("Debris")

-- Safe CoreGui fallback
local GUI_PARENT
pcall(function() GUI_PARENT = game:GetService("CoreGui") end)
if not GUI_PARENT then
    GUI_PARENT = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local LP    = Players.LocalPlayer
local PGui  = LP:WaitForChild("PlayerGui")
local Mouse = LP:GetMouse()
local Cam   = WS.CurrentCamera

-- Executor detect
local EXE = "Unknown"
pcall(function()
    if identifyexecutor  then EXE = identifyexecutor()
    elseif syn           then EXE = "Synapse X"
    elseif KRNL_LOADED   then EXE = "KRNL"
    elseif getexecutorname then EXE = getexecutorname()
    elseif isfolder or readfile then EXE = "Executor"
    end
end)

-- ═══════════════════════════════════════════════════════
-- COLOUR PALETTE  (Galaxy Premium)
-- ═══════════════════════════════════════════════════════
local C = {
    BG0  = Color3.fromRGB(5,  3,  18),
    BG1  = Color3.fromRGB(10, 6,  30),
    BG2  = Color3.fromRGB(16, 10, 46),
    BG3  = Color3.fromRGB(26, 16, 65),
    PRP  = Color3.fromRGB(140, 44, 230),
    DPRP = Color3.fromRGB(72,  0, 138),
    LPRP = Color3.fromRGB(192,112, 255),
    CYN  = Color3.fromRGB(0,  205, 255),
    PNK  = Color3.fromRGB(255, 95, 180),
    GLD  = Color3.fromRGB(255, 200,  55),
    GRN  = Color3.fromRGB(72,  225, 115),
    RED  = Color3.fromRGB(255,  65,  65),
    YLW  = Color3.fromRGB(255, 210,  50),
    WHT  = Color3.fromRGB(255, 255, 255),
    TXT0 = Color3.fromRGB(238, 228, 255),
    TXT1 = Color3.fromRGB(165, 148, 215),
    TXT2 = Color3.fromRGB(92,  74, 140),
}

-- ═══════════════════════════════════════════════════════
-- CORE HELPERS
-- ═══════════════════════════════════════════════════════
local function New(cls, props)
    local ok, inst = pcall(Instance.new, cls)
    if not ok then return nil end
    for k, v in pairs(props) do
        if k ~= "Parent" then pcall(function() inst[k] = v end) end
    end
    if props.Parent then pcall(function() inst.Parent = props.Parent end) end
    return inst
end

local function Tw(obj, goal, t, es, ed)
    if not obj or not obj.Parent then return end
    pcall(function()
        TweenService:Create(obj,
            TweenInfo.new(t or .25, es or Enum.EasingStyle.Quad,
                          ed or Enum.EasingDirection.Out), goal):Play()
    end)
end

-- ── Notification ──────────────────────────────────────
local function Notify(title, msg, dur)
    dur = dur or 3
    task.spawn(function()
        pcall(function()
            local ng = New("ScreenGui", {Name="OxN_"..tick(), ResetOnSpawn=false,
                DisplayOrder=99999, IgnoreGuiInset=true,
                ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=GUI_PARENT})
            local nf = New("Frame", {Size=UDim2.new(0,295,0,72),
                Position=UDim2.new(1,10,1,-92), BackgroundColor3=C.BG1,
                BorderSizePixel=0, Parent=ng})
            New("UICorner",{CornerRadius=UDim.new(0,13), Parent=nf})
            New("UIStroke",{Color=C.PRP, Thickness=1.5, Parent=nf})
            -- left colour bar
            local lb = New("Frame",{Size=UDim2.new(0,4,0.8,0), Position=UDim2.new(0,0,0.1,0),
                BackgroundColor3=C.LPRP, BorderSizePixel=0, Parent=nf})
            New("UICorner",{CornerRadius=UDim.new(1,0), Parent=lb})
            New("UIGradient",{Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,C.CYN),
                ColorSequenceKeypoint.new(1,C.PRP)}), Rotation=90, Parent=lb})
            New("TextLabel",{Size=UDim2.new(1,-18,0,22), Position=UDim2.new(0,12,0,4),
                BackgroundTransparency=1, Text="✦  "..title,
                TextColor3=C.LPRP, Font=Enum.Font.GothamBold, TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=nf})
            New("TextLabel",{Size=UDim2.new(1,-18,0,36), Position=UDim2.new(0,12,0,26),
                BackgroundTransparency=1, Text=msg, TextColor3=C.TXT1,
                Font=Enum.Font.Gotham, TextSize=11, TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=nf})
            local prog = New("Frame",{Size=UDim2.new(1,-6,0,3),
                Position=UDim2.new(0,3,1,-3), BackgroundColor3=C.PRP,
                BorderSizePixel=0, Parent=nf})
            New("UICorner",{CornerRadius=UDim.new(1,0), Parent=prog})
            New("UIGradient",{Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,C.PRP),
                ColorSequenceKeypoint.new(1,C.CYN)}), Parent=prog})
            Tw(nf,{Position=UDim2.new(1,-305,1,-92)},.35)
            Tw(prog,{Size=UDim2.new(0,0,0,3)},dur)
            task.delay(dur,function()
                pcall(function()
                    Tw(nf,{Position=UDim2.new(1,10,1,-92)},.25)
                    task.wait(.28)
                    ng:Destroy()
                end)
            end)
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- 159 BLOCK DATABASE
-- ═══════════════════════════════════════════════════════
local DB = {
    {id=1,  n="Back Wheel",               cat="Wheels"},
    {id=2,  n="Balloon Block",            cat="Special"},
    {id=3,  n="Bar",                      cat="Structure"},
    {id=4,  n="Big Cannon",               cat="Weapons"},
    {id=5,  n="Big Switch",               cat="Electronics"},
    {id=6,  n="Blue Candy",               cat="Candy"},
    {id=7,  n="Boat Motor",               cat="Propulsion"},
    {id=8,  n="Bouncy Block",             cat="Special"},
    {id=9,  n="Boxing Glove",             cat="Weapons"},
    {id=10, n="Bread",                    cat="Food"},
    {id=11, n="Brick Block",              cat="Structure"},
    {id=12, n="Bundles of Potions",       cat="Special"},
    {id=13, n="Button",                   cat="Electronics"},
    {id=14, n="Cake",                     cat="Food"},
    {id=15, n="Camera",                   cat="Special"},
    {id=16, n="Candle",                   cat="Decoration"},
    {id=17, n="Candy Cane Block",         cat="Candy"},
    {id=18, n="Candy Cane Rod",           cat="Candy"},
    {id=19, n="Cannon",                   cat="Weapons"},
    {id=20, n="Car Seat",                 cat="Seats"},
    {id=21, n="Chair",                    cat="Seats"},
    {id=22, n="Classic Firework",         cat="Fireworks"},
    {id=23, n="Coal Block",               cat="Structure"},
    {id=24, n="Common Chest Block",       cat="Chests"},
    {id=25, n="Concrete Block",           cat="Structure"},
    {id=26, n="Concrete Rod",             cat="Structure"},
    {id=27, n="Cookie Back Wheel",        cat="Wheels"},
    {id=28, n="Cookie Front Wheel",       cat="Wheels"},
    {id=29, n="Corner Wedge",             cat="Structure"},
    {id=30, n="Delay Block",              cat="Electronics"},
    {id=31, n="Dome Camera",              cat="Special"},
    {id=32, n="Door",                     cat="Structure"},
    {id=33, n="Dragon Egg",               cat="Special"},
    {id=34, n="Dragon Harpoon",           cat="Weapons"},
    {id=35, n="Dual Candy Cane Harpoon",  cat="Weapons"},
    {id=36, n="Dynamite",                 cat="Weapons"},
    {id=37, n="Easter Jetpack",           cat="Propulsion"},
    {id=38, n="Egg Cannon",               cat="Weapons"},
    {id=39, n="Epic Chest Block",         cat="Chests"},
    {id=40, n="Fabric Block",             cat="Structure"},
    {id=41, n="Firework 1",               cat="Fireworks"},
    {id=42, n="Firework 2",               cat="Fireworks"},
    {id=43, n="Firework 3",               cat="Fireworks"},
    {id=44, n="Firework 4",               cat="Fireworks"},
    {id=45, n="Flag",                     cat="Decoration"},
    {id=46, n="Front Wheel",              cat="Wheels"},
    {id=47, n="Gameboard",                cat="Special"},
    {id=48, n="Glass Block",              cat="Structure"},
    {id=49, n="Glue",                     cat="Electronics"},
    {id=50, n="Gold Block",               cat="Structure"},
    {id=51, n="Golden Harpoon",           cat="Weapons"},
    {id=52, n="Grass Block",              cat="Structure"},
    {id=53, n="Harpoon",                  cat="Weapons"},
    {id=54, n="Hatch",                    cat="Structure"},
    {id=55, n="Heart",                    cat="Decoration"},
    {id=56, n="Helm",                     cat="Special"},
    {id=57, n="Hinge",                    cat="Electronics"},
    {id=58, n="Huge Back Wheel",          cat="Wheels"},
    {id=59, n="Huge Front Wheel",         cat="Wheels"},
    {id=60, n="Huge Wheel",               cat="Wheels"},
    {id=61, n="I-Beam",                   cat="Structure"},
    {id=62, n="Ice Block",                cat="Structure"},
    {id=63, n="Jet Turbine",              cat="Propulsion"},
    {id=64, n="Jetpack",                  cat="Propulsion"},
    {id=65, n="Lamp",                     cat="Decoration"},
    {id=66, n="Large Treasure",           cat="Treasure"},
    {id=67, n="Laser Launcher",           cat="Weapons"},
    {id=68, n="Legendary Chest Block",    cat="Chests"},
    {id=69, n="Lever",                    cat="Electronics"},
    {id=70, n="Life Preserver",           cat="Special"},
    {id=71, n="Light Bulb",               cat="Decoration"},
    {id=72, n="Locked Door",              cat="Structure"},
    {id=73, n="Magnet",                   cat="Special"},
    {id=74, n="Marble Block",             cat="Structure"},
    {id=75, n="Marble Rod",               cat="Structure"},
    {id=76, n="Mast",                     cat="Structure"},
    {id=77, n="Master Builder Trophy",    cat="Trophies"},
    {id=78, n="Medium Treasure",          cat="Treasure"},
    {id=79, n="Mega Thruster",            cat="Propulsion"},
    {id=80, n="Metal Block",              cat="Structure"},
    {id=81, n="Metal Rod",                cat="Structure"},
    {id=82, n="Mini Gun",                 cat="Weapons"},
    {id=83, n="Mounted Bow",              cat="Weapons"},
    {id=84, n="Mounted Candy Cane Sword", cat="Weapons"},
    {id=85, n="Mounted Cannon",           cat="Weapons"},
    {id=86, n="Mounted Flintlocks",       cat="Weapons"},
    {id=87, n="Mounted Knight Sword",     cat="Weapons"},
    {id=88, n="Mounted Sword",            cat="Weapons"},
    {id=89, n="Mounted Wizard Staff",     cat="Weapons"},
    {id=90, n="Music Note",               cat="Decoration"},
    {id=91, n="Mystery Box",              cat="Special"},
    {id=92, n="Neon Block",               cat="Structure"},
    {id=93, n="Obsidian Block",           cat="Structure"},
    {id=94, n="Orange Candy",             cat="Candy"},
    {id=95, n="Parachute Block",          cat="Special"},
    {id=96, n="Peppermint Back Wheel",    cat="Wheels"},
    {id=97, n="Peppermint Front Wheel",   cat="Wheels"},
    {id=98, n="Pilot Seat",               cat="Seats"},
    {id=99, n="Pine Tree",                cat="Decoration"},
    {id=100,n="Pink Candy",               cat="Candy"},
    {id=101,n="Piston",                   cat="Electronics"},
    {id=102,n="Plastic Block",            cat="Structure"},
    {id=103,n="Plushie 1",                cat="Decoration"},
    {id=104,n="Plushie 2",                cat="Decoration"},
    {id=105,n="Plushie 3",                cat="Decoration"},
    {id=106,n="Plushie 4",                cat="Decoration"},
    {id=107,n="Portal",                   cat="Special"},
    {id=108,n="Pumpkin",                  cat="Decoration"},
    {id=109,n="Purple Candy",             cat="Candy"},
    {id=110,n="Rare Chest Block",         cat="Chests"},
    {id=111,n="Red Candy",                cat="Candy"},
    {id=112,n="Rope",                     cat="Structure"},
    {id=113,n="Rusted Block",             cat="Structure"},
    {id=114,n="Rusted Rod",               cat="Structure"},
    {id=115,n="Sand Block",               cat="Structure"},
    {id=116,n="Seat",                     cat="Seats"},
    {id=117,n="Servo",                    cat="Electronics"},
    {id=118,n="Shield Generator",         cat="Special"},
    {id=119,n="Sign",                     cat="Decoration"},
    {id=120,n="Small Treasure",           cat="Treasure"},
    {id=121,n="Smooth Wood Block",        cat="Structure"},
    {id=122,n="Snowball Launcher",        cat="Weapons"},
    {id=123,n="Soccer Ball",              cat="Special"},
    {id=124,n="Sonic Jet Turbine",        cat="Propulsion"},
    {id=125,n="Spike Trap",               cat="Weapons"},
    {id=126,n="Spooky Thruster",          cat="Propulsion"},
    {id=127,n="Star",                     cat="Decoration"},
    {id=128,n="Star Balloon Block",       cat="Special"},
    {id=129,n="Star Jetpack",             cat="Propulsion"},
    {id=130,n="Steampunk Jetpack",        cat="Propulsion"},
    {id=131,n="Step",                     cat="Structure"},
    {id=132,n="Stone Block",              cat="Structure"},
    {id=133,n="Stone Rod",                cat="Structure"},
    {id=134,n="Suspension",               cat="Electronics"},
    {id=135,n="Switch",                   cat="Electronics"},
    {id=136,n="Throne",                   cat="Seats"},
    {id=137,n="Thruster",                 cat="Propulsion"},
    {id=138,n="Titanium Block",           cat="Structure"},
    {id=139,n="Titanium Rod",             cat="Structure"},
    {id=140,n="TNT",                      cat="Weapons"},
    {id=141,n="Torch",                    cat="Decoration"},
    {id=142,n="Toy Block",                cat="Structure"},
    {id=143,n="Treasure Chest",           cat="Treasure"},
    {id=144,n="Trophy 1st",               cat="Trophies"},
    {id=145,n="Trophy 2nd",               cat="Trophies"},
    {id=146,n="Trophy 3rd",               cat="Trophies"},
    {id=147,n="Truss",                    cat="Structure"},
    {id=148,n="Ultra Boat Motor",         cat="Propulsion"},
    {id=149,n="Ultra Jetpack",            cat="Propulsion"},
    {id=150,n="Ultra Thruster",           cat="Propulsion"},
    {id=151,n="Uncommon Chest Block",     cat="Chests"},
    {id=152,n="Wedge",                    cat="Structure"},
    {id=153,n="Wheel",                    cat="Wheels"},
    {id=154,n="Window",                   cat="Structure"},
    {id=155,n="Winter Boat Motor",        cat="Propulsion"},
    {id=156,n="Winter Jet Turbine",       cat="Propulsion"},
    {id=157,n="Winter Thruster",          cat="Propulsion"},
    {id=158,n="Wood Block",               cat="Structure"},
    {id=159,n="Wood Rod",                 cat="Structure"},
}

-- lookup helpers
local DBbyName = {}
local DBbyId   = {}
for _, b in ipairs(DB) do
    DBbyName[b.n:lower()] = b
    DBbyId[b.id] = b
end

local function FindBlock(name)
    if not name then return DB[158] end
    local lo = name:lower()
    if DBbyName[lo] then return DBbyName[lo] end
    for k, v in pairs(DBbyName) do
        if k:find(lo, 1, true) or lo:find(k, 1, true) then return v end
    end
    return DB[158]
end

-- ═══════════════════════════════════════════════════════
-- INVENTORY SYSTEM
-- Baca block yang player PUNYA di BABFT
-- ═══════════════════════════════════════════════════════
local Inventory = {}   -- { [blockName] = {block=DB, count=N} }

local function ScanInventory()
    Inventory = {}

    -- 1) Coba ambil dari RemoteFunction BABFT (GetInventory / GetBlocks)
    local function tryRemote()
        for _, rem in ipairs(RS:GetDescendants()) do
            if rem:IsA("RemoteFunction") then
                local nm = rem.Name:lower()
                if nm:find("inventory") or nm:find("getblock") or nm:find("ownedblock") then
                    local ok, result = pcall(function() return rem:InvokeServer() end)
                    if ok and type(result) == "table" then
                        for k, v in pairs(result) do
                            local bname = type(k) == "string" and k or (type(v) == "string" and v)
                            if bname then
                                local bd = FindBlock(bname)
                                if bd then
                                    Inventory[bd.n] = {block=bd,
                                        count=type(v)=="number" and v or 99}
                                end
                            end
                        end
                        if next(Inventory) then return true end
                    end
                end
            end
        end
        return false
    end

    -- 2) Scan nilai di bawah LP (DataStore cache dll)
    local function tryLPChildren()
        local paths = {}
        for _, c in ipairs(LP:GetChildren()) do paths[#paths+1] = c end
        for _, path in ipairs(paths) do
            for _, item in ipairs(path:GetDescendants()) do
                local bd = FindBlock(item.Name)
                if bd and not Inventory[bd.n] then
                    local cnt = 99
                    pcall(function()
                        if item:IsA("IntValue") or item:IsA("NumberValue") then
                            cnt = item.Value
                        end
                    end)
                    if cnt > 0 then Inventory[bd.n] = {block=bd, count=cnt} end
                end
            end
        end
    end

    -- 3) Scan tombol di GUI BABFT (paling reliable)
    local function tryGUIButtons()
        for _, gui in ipairs(PGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, obj in ipairs(gui:GetDescendants()) do
                    if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                        local bd = FindBlock(obj.Name)
                        if bd and not Inventory[bd.n] then
                            -- cek visible/active (kalau tidak bisa diklik, berarti tidak punya)
                            local canUse = true
                            pcall(function()
                                canUse = obj.Visible and obj.Active ~= false
                            end)
                            if canUse then
                                Inventory[bd.n] = {block=bd, count=99, obj=obj}
                            end
                        end
                    end
                end
            end
        end
    end

    tryRemote()
    tryLPChildren()
    tryGUIButtons()

    -- Fallback: jika benar-benar kosong, beri block dasar
    if not next(Inventory) then
        local defaults = {
            "Wood Block","Plastic Block","Stone Block","Metal Block",
            "Glass Block","Brick Block","Thruster","Boat Motor","Wheel",
            "Front Wheel","Back Wheel","Cannon","Button","Switch","Helm",
        }
        for _, nm in ipairs(defaults) do
            local bd = FindBlock(nm)
            if bd then Inventory[bd.n] = {block=bd, count=99} end
        end
    end

    local count = 0
    for _ in pairs(Inventory) do count = count + 1 end
    return count
end

-- ═══════════════════════════════════════════════════════
-- PLACER  – place pakai block MILIK player
-- ═══════════════════════════════════════════════════════
local Placer = { delay=0.12, placed=0, failed=0, running=false }

local _cachedRemote = nil
local function GetRemote()
    if _cachedRemote and _cachedRemote.Parent then return _cachedRemote end
    local names = {
        "PlaceBlock","AddBlock","SpawnBlock","Build",
        "PlacePart","CreateBlock","BlockPlace","PlaceItem",
    }
    for _, nm in ipairs(names) do
        local r = RS:FindFirstChild(nm, true)
        if r then _cachedRemote = r return r end
    end
    for _, v in ipairs(RS:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
            local lo = v.Name:lower()
            if lo:find("place") or lo:find("block") or lo:find("build") then
                _cachedRemote = v return v
            end
        end
    end
    return nil
end

-- Klik tombol block di GUI BABFT
local function ClickInventoryButton(blockName)
    for _, gui in ipairs(PGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, obj in ipairs(gui:GetDescendants()) do
                if (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
                    local bd = FindBlock(obj.Name)
                    if bd and bd.n == blockName then
                        pcall(function()
                            obj.MouseButton1Click:Fire()
                            -- atau simulate mouse click
                            local vclick = Instance.new("InputObject")
                            vclick.UserInputType = Enum.UserInputType.MouseButton1
                            pcall(function() obj:SimulateClick() end)
                        end)
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Placer:PlaceOne(blockDef, pos, col)
    -- Cari block di inventory, kalau tidak ada cari yang mirip
    local bd = blockDef
    if not Inventory[bd.n] then
        -- cari di kategori yang sama
        for invName, invData in pairs(Inventory) do
            if invData.block.cat == bd.cat then
                bd = invData.block
                break
            end
        end
        -- kalau masih tidak ada, pakai block pertama yang ada
        if not Inventory[bd.n] then
            for _, invData in pairs(Inventory) do
                bd = invData.block
                break
            end
        end
    end

    local success = false
    local remote = GetRemote()

    -- Cara 1: RemoteEvent/Function
    if remote then
        pcall(function()
            local payload = {
                BlockId   = bd.id,
                BlockName = bd.n,
                Name      = bd.n,
                Id        = bd.id,
                Position  = pos or Vector3.new(0,5,0),
                Color     = col or Color3.fromRGB(163,102,51),
            }
            if remote:IsA("RemoteEvent") then
                remote:FireServer(payload)
                success = true
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(payload)
                success = true
            end
        end)
    end

    -- Cara 2: Klik tombol inventory
    if not success then
        success = ClickInventoryButton(bd.n)
    end

    if success then self.placed += 1 else self.failed += 1 end
    return success, bd.n
end

function Placer:Build(buildData, onProgress)
    if self.running then Notify("Build","Build sedang berjalan!",2) return end
    if not buildData or not buildData.blocks then return false end
    self.running = true
    self.placed  = 0
    self.failed  = 0
    local total  = #buildData.blocks

    task.spawn(function()
        Notify("Auto Build","Memulai "..total.." blocks... 🚀",3)
        for i, bi in ipairs(buildData.blocks) do
            if not self.running then break end

            local bname = bi.name or bi.n or "Wood Block"
            local bDef  = FindBlock(bname)

            local pos = Vector3.new(
                (bi.position and bi.position.x) or 0,
                (bi.position and bi.position.y) or (i * 1.25),
                (bi.position and bi.position.z) or 0)

            local col = bi.color and
                Color3.fromRGB(bi.color.r or 163, bi.color.g or 102, bi.color.b or 51) or
                Color3.fromRGB(163,102,51)

            local ok2, usedName = self:PlaceOne(bDef, pos, col)

            if onProgress then
                pcall(onProgress, i, total, usedName or bname, ok2)
            end

            task.wait(self.delay)
        end

        self.running = false
        if onProgress then pcall(onProgress, total, total, "DONE", true) end
        Notify("Selesai! ✅","Build "..total.." blocks selesai! Placed:"..self.placed,4)
    end)
    return true
end

function Placer:Stop()
    self.running = false
    Notify("Stop","Build dihentikan.",2)
end

-- ═══════════════════════════════════════════════════════
-- BUILD FILE SYSTEM
-- ═══════════════════════════════════════════════════════
local BFS = {}

-- Parse .build (JSON dengan struktur BABFT)
function BFS.ParseBuild(txt)
    if txt == "" then return nil, "Konten kosong" end
    local ok, d = pcall(function() return HttpService:JSONDecode(txt) end)
    if not ok or type(d) ~= "table" then return nil, "Bukan JSON yang valid" end
    if not d.blocks or #d.blocks == 0   then return nil, "Tidak ada array 'blocks'" end
    return d, nil
end

-- Parse .json (Roblox Studio model export)
function BFS.ParseJSON(txt)
    if txt == "" then return nil, "Konten kosong" end
    local ok, raw = pcall(function() return HttpService:JSONDecode(txt) end)
    if not ok or type(raw) ~= "table" then return nil, "Bukan JSON yang valid" end

    -- Jika sudah format .build langsung
    if raw.blocks and #raw.blocks > 0 then return raw, nil end

    -- Convert dari Studio format
    local blocks = {}
    local function scan(o, depth)
        if type(o) ~= "table" or depth > 12 then return end
        local cls = o.ClassName or o.class or ""
        if cls == "Part" or cls == "MeshPart" or cls == "UnionOperation"
            or cls == "SpecialMesh" or cls == "WedgePart" then
            local bd = FindBlock(o.Name or "")
            local px = (o.CFrame and o.CFrame[1]) or (o.Position and o.Position[1]) or 0
            local py = (o.CFrame and o.CFrame[2]) or (o.Position and o.Position[2]) or 5
            local pz = (o.CFrame and o.CFrame[3]) or (o.Position and o.Position[3]) or 0
            table.insert(blocks, {
                id=bd.id, name=bd.n,
                position={x=px,y=py,z=pz},
                size={
                    x=(o.Size and o.Size[1]) or 4,
                    y=(o.Size and o.Size[2]) or 1.2,
                    z=(o.Size and o.Size[3]) or 2,
                },
                color={
                    r=(o.Color and math.floor((o.Color[1] or .64)*255)) or 163,
                    g=(o.Color and math.floor((o.Color[2] or .40)*255)) or 102,
                    b=(o.Color and math.floor((o.Color[3] or .20)*255)) or 51,
                }
            })
        end
        if o.Children then for _, c in ipairs(o.Children) do scan(c, depth+1) end end
        for k, v in pairs(o) do
            if type(v)=="table" and k~="Children" then scan(v, depth+1) end
        end
    end
    scan(raw, 0)

    if #blocks == 0 then
        blocks = {{id=158,name="Wood Block",
            position={x=0,y=5,z=0},size={x=4,y=1.2,z=2},color={r=163,g=102,b=51}}}
    end
    return {version="1.0", name="Imported_JSON", author=LP.Name,
        blocks=blocks, welds={}, metadata={blockCount=#blocks}}, nil
end

-- Serialize ke .build
function BFS.Serialize(name, blocks)
    local d = {
        version="1.0", name=name or "MyBuild", author=LP.Name,
        blocks=blocks or {}, welds={},
        metadata={blockCount=#(blocks or {}), by="OxyX v3.0", game="BABFT"}
    }
    local ok, j = pcall(function() return HttpService:JSONEncode(d) end)
    return ok and j or nil
end

-- ── FILE BROWSER (hanya baca 1 ekstensi) ──────────────
-- Folder default: "builds/" untuk .build, "json/" untuk .json
-- Jika tidak ada folder, fallback ke root workspace
local BUILD_FOLDER = "builds"
local JSON_FOLDER  = "json"

local function EnsureFolder(folder)
    if makefolder then
        pcall(function()
            if not isfolder(folder) then makefolder(folder) end
        end)
    end
end

local function ListFilesExt(folder, ext)
    local results = {}
    -- coba folder khusus
    local function tryList(f)
        if listfiles then
            pcall(function()
                local list = listfiles(f)
                for _, path in ipairs(list) do
                    local fname = path:match("([^/\\]+)$") or path
                    if fname:lower():sub(-#ext) == ext:lower() then
                        results[#results+1] = {name=fname, path=path}
                    end
                end
            end)
        end
    end
    tryList(folder)
    tryList(folder.."/")
    -- fallback root
    if #results == 0 then tryList("") end
    -- deduplicate
    local seen, clean = {}, {}
    for _, f in ipairs(results) do
        if not seen[f.name] then seen[f.name]=true clean[#clean+1]=f end
    end
    return clean
end

local function ReadFileSafe(path)
    if readfile then
        local ok, txt = pcall(readfile, path)
        if ok and txt then return txt end
    end
    return nil
end

local function WriteFileSafe(path, content)
    if writefile then
        pcall(writefile, path, content)
        return true
    end
    return false
end

-- ═══════════════════════════════════════════════════════
-- SHAPE BUILDER
-- ═══════════════════════════════════════════════════════
local SB = {}
function SB.Ball(bn,r)      local b={} for x=-r,r do for y=-r,r do for z=-r,r do if x*x+y*y+z*z<=r*r then b[#b+1]={name=bn,position={x=x*2,y=y*2,z=z*2}} end end end end return b end
function SB.Cylinder(bn,r,h) local b={} for y=0,h-1 do for x=-r,r do for z=-r,r do if x*x+z*z<=r*r then b[#b+1]={name=bn,position={x=x*2,y=y*2,z=z*2}} end end end end return b end
function SB.Triangle(bn,ba,h) local b={} for y=0,h-1 do local lw=math.max(1,math.floor(ba*(1-y/h))) for x=0,lw-1 do b[#b+1]={name=bn,position={x=(x+(ba-lw)/2)*2,y=y*2,z=0}} end end return b end
function SB.Pyramid(bn,ba)   local b={} for y=0,ba-1 do for x=0,ba-1-y do for z=0,ba-1-y do b[#b+1]={name=bn,position={x=(x+y)*2,y=y*2,z=(z+y)*2}} end end end return b end
function SB.Platform(bn,w,l) local b={} for x=0,w-1 do for z=0,l-1 do b[#b+1]={name=bn,position={x=x*4,y=0,z=z*2},size={x=4,y=1.2,z=2}} end end return b end
function SB.HollowBox(bn,w,h,d) local b={} for x=0,w-1 do for y=0,h-1 do for z=0,d-1 do if x==0 or x==w-1 or y==0 or y==h-1 or z==0 or z==d-1 then b[#b+1]={name=bn,position={x=x*2,y=y*2,z=z*2}} end end end end return b end
function SB.BoatHull(bn,len,w) local b={} for x=0,len-1 do for z=0,w-1 do b[#b+1]={name=bn,position={x=x*4,y=0,z=z*2},size={x=4,y=1.2,z=2}} end end for x=0,len-1 do for y=1,2 do b[#b+1]={name=bn,position={x=x*4,y=y*1.2,z=0},size={x=4,y=1.2,z=2}} b[#b+1]={name=bn,position={x=x*4,y=y*1.2,z=(w-1)*2},size={x=4,y=1.2,z=2}} end end return b end
function SB.Run(shape,bn,p)
    local bl={}
    if     shape=="Ball"      then bl=SB.Ball(bn,p.r or 3)
    elseif shape=="Cylinder"  then bl=SB.Cylinder(bn,p.r or 3,p.h or 5)
    elseif shape=="Triangle"  then bl=SB.Triangle(bn,p.base or 5,p.h or 5)
    elseif shape=="Pyramid"   then bl=SB.Pyramid(bn,p.base or 5)
    elseif shape=="Platform"  then bl=SB.Platform(bn,p.w or 5,p.l or 5)
    elseif shape=="HollowBox" then bl=SB.HollowBox(bn,p.w or 5,p.h or 3,p.d or 5)
    elseif shape=="BoatHull"  then bl=SB.BoatHull(bn,p.l or 8,p.w or 4)
    end
    if #bl>0 then return {version="1.0",name="OxyX_"..shape,author=LP.Name,
        blocks=bl,welds={},metadata={blockCount=#bl}} end
    return nil
end

-- ═══════════════════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════════════════
local St = {
    minimized = false,
    tab       = "Build",
    buildData = nil,
    sp        = {r=3,h=5,w=5,l=8,base=5,d=5},
    stype     = "Ball",
    sblock    = "Wood Block",
}

-- ═══════════════════════════════════════════════════════
-- ███  MAIN UI  ███
-- ═══════════════════════════════════════════════════════
local function BuildUI()
    -- destroy existing
    pcall(function()
        local old = GUI_PARENT:FindFirstChild("OxyX_v3_FINAL")
        if old then old:Destroy() end
    end)

    -- Ensure folders exist
    EnsureFolder(BUILD_FOLDER)
    EnsureFolder(JSON_FOLDER)

    local invCount = ScanInventory()

    -- ── ROOT ────────────────────────────────────────────
    local SG = New("ScreenGui",{
        Name="OxyX_v3_FINAL", ResetOnSpawn=false,
        IgnoreGuiInset=true, DisplayOrder=9999,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        Parent=GUI_PARENT,
    })
    if not SG then Notify("Error","Gagal membuat GUI!",5) return end

    -- ── MAIN FRAME ──────────────────────────────────────
    local MF = New("Frame",{
        Name="Main",
        Size=UDim2.new(0,440,0,620),
        Position=UDim2.new(0.5,-220,0.5,-310),
        BackgroundColor3=C.BG0,
        BorderSizePixel=0,
        ClipsDescendants=false,
        Parent=SG,
    })
    New("UICorner",{CornerRadius=UDim.new(0,20),Parent=MF})

    -- Animated outer border
    local BordF = New("Frame",{
        Size=UDim2.new(1,8,1,8), Position=UDim2.new(0,-4,0,-4),
        BackgroundColor3=C.PRP, BorderSizePixel=0, ZIndex=0, Parent=MF,
    })
    New("UICorner",{CornerRadius=UDim.new(0,24),Parent=BordF})
    local BordGrad = New("UIGradient",{
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,   C.PRP),
            ColorSequenceKeypoint.new(0.2, C.CYN),
            ColorSequenceKeypoint.new(0.5, C.PNK),
            ColorSequenceKeypoint.new(0.8, C.GLD),
            ColorSequenceKeypoint.new(1,   C.PRP),
        }), Rotation=0, Parent=BordF,
    })

    -- Inner BG
    local Inner = New("Frame",{
        Size=UDim2.new(1,0,1,0), BackgroundColor3=C.BG0,
        BorderSizePixel=0, ZIndex=1, Parent=MF,
    })
    New("UICorner",{CornerRadius=UDim.new(0,20),Parent=Inner})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,  Color3.fromRGB(6,3,22)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(13,7,36)),
        ColorSequenceKeypoint.new(1,  Color3.fromRGB(5,9,28)),
    }),Rotation=150,Parent=Inner})

    -- Stars decoration
    for i=1,32 do
        local sz = math.random(1,3)
        local st = New("Frame",{
            Size=UDim2.new(0,sz,0,sz),
            Position=UDim2.new(math.random()*0.94,0,math.random()*0.94,0),
            BackgroundColor3= i%3==0 and C.CYN or i%2==0 and C.LPRP or C.WHT,
            BackgroundTransparency=math.random()*0.5+0.15,
            BorderSizePixel=0, ZIndex=2, Parent=Inner,
        })
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=st})
        task.spawn(function()
            while st and st.Parent do
                task.wait(1+math.random()*3)
                pcall(function()
                    Tw(st,{BackgroundTransparency=0.92},0.45)
                    task.wait(0.5)
                    Tw(st,{BackgroundTransparency=math.random()*0.4+0.05},0.45)
                end)
            end
        end)
    end

    -- Nebula blobs
    for _, info in ipairs({
        {Color3.fromRGB(40,0,80),  0.88, 160, 90,  UDim2.new(0.05,0,0.1,0)},
        {Color3.fromRGB(0,30,75),  0.90, 130, 100, UDim2.new(0.5,0,0.55,0)},
        {Color3.fromRGB(70,0,60),  0.88, 110, 80,  UDim2.new(0.7,0,0.08,0)},
    }) do
        local nb = New("Frame",{
            Size=UDim2.new(0,info[3],0,info[4]),
            Position=info[5],
            BackgroundColor3=info[1], BackgroundTransparency=info[2],
            BorderSizePixel=0, ZIndex=2, Parent=Inner,
        })
        New("UICorner",{CornerRadius=UDim.new(0.5,0),Parent=nb})
    end

    -- Border rotation
    local ba = 0
    local bconn = RunService.Heartbeat:Connect(function(dt)
        ba = (ba + dt*38)%360
        pcall(function() BordGrad.Rotation = ba end)
    end)

    -- ══════════════════════════════════════════
    -- HEADER  (90px tall)
    -- ══════════════════════════════════════════
    local HDR = New("Frame",{
        Size=UDim2.new(1,0,0,90), BackgroundColor3=C.BG1,
        BorderSizePixel=0, ZIndex=10, Parent=Inner,
    })
    New("UICorner",{CornerRadius=UDim.new(0,20),Parent=HDR})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(30,14,80)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(11,6,34)),
    }),Rotation=90,Parent=HDR})
    -- patch bottom round corners
    New("Frame",{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,1,-22),
        BackgroundColor3=C.BG1,BorderSizePixel=0,ZIndex=10,Parent=HDR})

    -- ── ASTOLFO ANIMATED GIF CONTAINER ──────────────────
    local AFrame = New("Frame",{
        Size=UDim2.new(0,72,0,72), Position=UDim2.new(0,12,0,9),
        BackgroundColor3=C.BG2, BorderSizePixel=0, ZIndex=15, Parent=HDR,
    })
    New("UICorner",{CornerRadius=UDim.new(0,16),Parent=AFrame})

    -- Rotating gradient ring (simulates GIF glow)
    local RingF = New("Frame",{
        Size=UDim2.new(1,10,1,10), Position=UDim2.new(0,-5,0,-5),
        BackgroundTransparency=1, BorderSizePixel=0, ZIndex=14, Parent=AFrame,
    })
    New("UICorner",{CornerRadius=UDim.new(0,21),Parent=RingF})
    local RingStroke = New("UIStroke",{Color=C.PNK, Thickness=3,
        Transparency=0.2, Parent=RingF})
    local RingGrad = New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,  C.PNK),
        ColorSequenceKeypoint.new(0.3,C.CYN),
        ColorSequenceKeypoint.new(0.7,C.LPRP),
        ColorSequenceKeypoint.new(1,  C.PNK),
    }),Rotation=0,Parent=RingStroke})

    -- Inner glow
    local AInnerGlow = New("Frame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=C.DPRP, BackgroundTransparency=0.5,
        BorderSizePixel=0, ZIndex=15, Parent=AFrame,
    })
    New("UICorner",{CornerRadius=UDim.new(0,16),Parent=AInnerGlow})

    -- Astolfo image (Roblox ImageLabel – animasikan via shimmer karena GIF tidak didukung)
    local AImg = New("ImageLabel",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Image="rbxassetid://7078026274",   -- astolfo asset
        ScaleType=Enum.ScaleType.Crop,
        ZIndex=16, Parent=AFrame,
    })
    New("UICorner",{CornerRadius=UDim.new(0,14),Parent=AImg})

    -- Shimmer sweep (simulates GIF animation)
    local Shimmer = New("Frame",{
        Size=UDim2.new(0.35,0,1.2,0), Position=UDim2.new(-0.35,0,-0.1,0),
        BackgroundColor3=C.WHT, BackgroundTransparency=0.75,
        BorderSizePixel=0, ZIndex=17, Parent=AFrame,
    })
    New("UICorner",{CornerRadius=UDim.new(0,6),Parent=Shimmer})
    -- Shimmer loop
    task.spawn(function()
        while Shimmer and Shimmer.Parent do
            Tw(Shimmer,{Position=UDim2.new(1.1,0,-0.1,0)},0.75,Enum.EasingStyle.Sine)
            task.wait(0.8)
            pcall(function() Shimmer.Position = UDim2.new(-0.35,0,-0.1,0) end)
            task.wait(2.2+math.random()*1.5)
        end
    end)

    -- Ring colour cycle + rotation (GIF simulation)
    local rba = 0
    local ringConn = RunService.Heartbeat:Connect(function(dt)
        rba = (rba+dt*90)%360
        pcall(function() RingGrad.Rotation = rba end)
    end)
    task.spawn(function()
        local gc = {C.PNK,C.CYN,C.LPRP,C.GLD,C.PRP}
        local gi = 1
        while RingStroke and RingStroke.Parent do
            gi = (gi%#gc)+1
            Tw(RingStroke,{Color=gc[gi]},1.0,Enum.EasingStyle.Sine)
            task.wait(1.2)
        end
    end)

    -- ── TITLE ────────────────────────────────────────────
    local TArea = New("Frame",{
        Size=UDim2.new(0,220,0,72), Position=UDim2.new(0,94,0,9),
        BackgroundTransparency=1, ZIndex=15, Parent=HDR,
    })

    local TL = New("TextLabel",{
        Size=UDim2.new(1,0,0,38), BackgroundTransparency=1,
        Text="OxyX", TextColor3=C.WHT,
        Font=Enum.Font.GothamBold, TextScaled=true,
        ZIndex=15, Parent=TArea,
    })
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,  C.LPRP),
        ColorSequenceKeypoint.new(0.3,C.CYN),
        ColorSequenceKeypoint.new(0.7,C.PNK),
        ColorSequenceKeypoint.new(1,  C.GLD),
    }),Rotation=5,Parent=TL})

    New("TextLabel",{
        Size=UDim2.new(1,0,0,18), Position=UDim2.new(0,0,0,40),
        BackgroundTransparency=1,
        Text="Build A Boat For Treasure Tool",
        TextColor3=C.TXT1, Font=Enum.Font.Gotham,
        TextScaled=true, ZIndex=15, Parent=TArea,
    })

    -- Badge row
    local BadgeRow = New("Frame",{
        Size=UDim2.new(1,0,0,18), Position=UDim2.new(0,0,0,60),
        BackgroundTransparency=1, ZIndex=15, Parent=TArea,
    })
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,
        SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=BadgeRow})

    local function Badge(par, txt, bg)
        local b = New("TextLabel",{
            Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X,
            BackgroundColor3=bg, BorderSizePixel=0,
            Text=" "..txt.." ",
            TextColor3=C.WHT, Font=Enum.Font.GothamBold, TextSize=9,
            ZIndex=16, Parent=par,
        })
        New("UICorner",{CornerRadius=UDim.new(0,4),Parent=b})
        return b
    end
    Badge(BadgeRow,"v3.0 FINAL",C.DPRP)
    Badge(BadgeRow,"GALAXY",C.PRP)
    Badge(BadgeRow,"159 BLOCKS",Color3.fromRGB(0,105,55))

    -- ── CONTROLS (minimize, close) ───────────────────────
    local CtrlF = New("Frame",{
        Size=UDim2.new(0,70,0,32), Position=UDim2.new(1,-78,0,12),
        BackgroundTransparency=1, ZIndex=20, Parent=HDR,
    })
    local MinB = New("TextButton",{
        Size=UDim2.new(0,30,0,30), BackgroundColor3=C.BG3,
        BorderSizePixel=0, Text="−",
        TextColor3=C.YLW, Font=Enum.Font.GothamBold, TextSize=22,
        AutoButtonColor=false, ZIndex=20, Parent=CtrlF,
    })
    New("UICorner",{CornerRadius=UDim.new(0,9),Parent=MinB})
    New("UIStroke",{Color=C.YLW,Thickness=1.5,Parent=MinB})

    local CloseB = New("TextButton",{
        Size=UDim2.new(0,30,0,30), Position=UDim2.new(0,36,0,0),
        BackgroundColor3=C.BG3, BorderSizePixel=0,
        Text="✕", TextColor3=C.RED,
        Font=Enum.Font.GothamBold, TextSize=14,
        AutoButtonColor=false, ZIndex=20, Parent=CtrlF,
    })
    New("UICorner",{CornerRadius=UDim.new(0,9),Parent=CloseB})
    New("UIStroke",{Color=C.RED,Thickness=1.5,Parent=CloseB})

    -- Hover effects for control buttons
    for _, btn in ipairs({MinB, CloseB}) do
        local orig = btn.BackgroundColor3
        btn.MouseEnter:Connect(function()
            Tw(btn,{BackgroundColor3=C.BG2},.12)
        end)
        btn.MouseLeave:Connect(function()
            Tw(btn,{BackgroundColor3=orig},.12)
        end)
    end

    -- ══════════════════════════════════════════
    -- TAB BAR
    -- ══════════════════════════════════════════
    local TabBar = New("Frame",{
        Size=UDim2.new(1,0,0,38), Position=UDim2.new(0,0,0,90),
        BackgroundColor3=C.BG1, BorderSizePixel=0, ZIndex=10, Parent=Inner,
    })
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(20,11,55)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(10,6,30)),
    }),Rotation=90,Parent=TabBar})
    -- top divider line
    New("Frame",{Size=UDim2.new(1,-20,0,1),Position=UDim2.new(0,10,0,0),
        BackgroundColor3=C.BG3,BorderSizePixel=0,Parent=TabBar})
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,
        SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),Parent=TabBar})
    New("UIPadding",{PaddingLeft=UDim.new(0,5),PaddingTop=UDim.new(0,5),
        PaddingBottom=UDim.new(0,5),Parent=TabBar})

    -- ══════════════════════════════════════════
    -- CONTENT SCROLL
    -- ══════════════════════════════════════════
    local Content = New("ScrollingFrame",{
        Size=UDim2.new(1,0,1,-168), Position=UDim2.new(0,0,0,128),
        BackgroundColor3=C.BG0, BorderSizePixel=0,
        ScrollBarThickness=4, ScrollBarImageColor3=C.PRP,
        CanvasSize=UDim2.new(1,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=5, Parent=Inner,
    })

    -- ── PROGRESS BAR (hidden until build) ───────────────
    local ProgBG = New("Frame",{
        Size=UDim2.new(1,-20,0,9), Position=UDim2.new(0,10,0,132),
        BackgroundColor3=C.BG3, BorderSizePixel=0,
        Visible=false, ZIndex=12, Parent=Inner,
    })
    New("UICorner",{CornerRadius=UDim.new(1,0),Parent=ProgBG})
    local ProgFill = New("Frame",{
        Size=UDim2.new(0,0,1,0), BackgroundColor3=C.GRN,
        BorderSizePixel=0, Parent=ProgBG,
    })
    New("UICorner",{CornerRadius=UDim.new(1,0),Parent=ProgFill})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.CYN),
        ColorSequenceKeypoint.new(1,C.GRN),
    }),Rotation=0,Parent=ProgFill})

    local ProgLbl = New("TextLabel",{
        Size=UDim2.new(1,-20,0,13), Position=UDim2.new(0,10,0,143),
        BackgroundTransparency=1, Text="",
        TextColor3=C.TXT1, Font=Enum.Font.Gotham, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left,
        Visible=false, ZIndex=12, Parent=Inner,
    })

    -- ── STATUS BAR ───────────────────────────────────────
    local SBar = New("Frame",{
        Size=UDim2.new(1,0,0,36), Position=UDim2.new(0,0,1,-36),
        BackgroundColor3=C.BG1, BorderSizePixel=0, ZIndex=10, Parent=Inner,
    })
    New("UICorner",{CornerRadius=UDim.new(0,20),Parent=SBar})
    New("Frame",{Size=UDim2.new(1,0,0,20),BackgroundColor3=C.BG1,BorderSizePixel=0,ZIndex=10,Parent=SBar})
    New("Frame",{Size=UDim2.new(1,-20,0,1),Position=UDim2.new(0,10,0,1),
        BackgroundColor3=C.BG3,BorderSizePixel=0,Parent=SBar})

    local StatusLbl = New("TextLabel",{
        Size=UDim2.new(1,-125,1,0), Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1,
        Text="✦  Ready  |  "..EXE,
        TextColor3=C.TXT1, Font=Enum.Font.Gotham, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=15, Parent=SBar,
    })
    New("TextLabel",{
        Size=UDim2.new(0,115,1,0), Position=UDim2.new(1,-118,0,0),
        BackgroundTransparency=1,
        Text="Inv: "..invCount.." blk  ✓",
        TextColor3=C.LPRP, Font=Enum.Font.GothamBold, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Right,
        ZIndex=15, Parent=SBar,
    })

    -- ══════════════════════════════════════════
    -- WIDGET FACTORIES
    -- ══════════════════════════════════════════
    local TabBtns  = {}
    local TabPages = {}

    local function Page(name)
        local p = New("Frame",{Name="P_"..name,Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,Visible=false,Parent=Content})
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=p})
        New("UIPadding",{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),
            PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,14),Parent=p})
        TabPages[name] = p
        return p
    end

    local function Sec(par, txt, ico)
        local f = New("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=C.BG2,
            BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=f})
        New("UIGradient",{Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(45,18,108)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(20,10,58)),
        }),Rotation=90,Parent=f})
        local bar = New("Frame",{Size=UDim2.new(0,4,0.75,0),Position=UDim2.new(0,0,0.125,0),
            BackgroundColor3=C.PRP,BorderSizePixel=0,Parent=f})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=bar})
        New("UIGradient",{Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.CYN),ColorSequenceKeypoint.new(1,C.PRP),
        }),Rotation=90,Parent=bar})
        New("TextLabel",{Size=UDim2.new(1,-18,1,0),Position=UDim2.new(0,12,0,0),
            BackgroundTransparency=1, Text=(ico or "◆").."  "..txt,
            TextColor3=C.LPRP, Font=Enum.Font.GothamBold, TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=f})
        return f
    end

    local function Btn(par, txt, col, cb, ico)
        col = col or C.PRP
        local r2,g2,b2 = col.R*255, col.G*255, col.B*255
        local dark = Color3.fromRGB(math.floor(r2*.2), math.floor(g2*.2), math.floor(b2*.2))
        local mid  = Color3.fromRGB(math.floor(r2*.38),math.floor(g2*.38),math.floor(b2*.38))
        local btn  = New("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=dark,
            BorderSizePixel=0, Text=(ico and ico.."  " or "")..txt,
            TextColor3=C.TXT0, Font=Enum.Font.GothamBold, TextSize=13,
            AutoButtonColor=false, Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,10),Parent=btn})
        New("UIStroke",{Color=col,Thickness=1.5,Parent=btn})
        local shine = New("Frame",{Size=UDim2.new(1,0,0.48,0),
            BackgroundColor3=C.WHT,BackgroundTransparency=0.91,
            BorderSizePixel=0,ZIndex=2,Parent=btn})
        New("UICorner",{CornerRadius=UDim.new(0,10),Parent=shine})
        btn.MouseEnter:Connect(function()   Tw(btn,{BackgroundColor3=mid},.12) end)
        btn.MouseLeave:Connect(function()   Tw(btn,{BackgroundColor3=dark},.12) end)
        btn.MouseButton1Down:Connect(function() Tw(btn,{BackgroundColor3=col},.07) end)
        btn.MouseButton1Up:Connect(function()   Tw(btn,{BackgroundColor3=mid},.1)  end)
        if cb then btn.MouseButton1Click:Connect(cb) end
        return btn
    end

    local function InputBox(par, ph, def, h)
        local ctr = New("Frame",{Size=UDim2.new(1,0,0,h or 34),BackgroundColor3=C.BG2,
            BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=ctr})
        local st = New("UIStroke",{Color=C.BG3,Thickness=1.5,Parent=ctr})
        local tb = New("TextBox",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,Text=def or "",PlaceholderText=ph or "...",
            PlaceholderColor3=C.TXT2,TextColor3=C.TXT0,Font=Enum.Font.Gotham,
            TextSize=12,ClearTextOnFocus=false,Parent=ctr})
        tb.Focused:Connect(function()
            pcall(function() Tw(st,{Color=C.PRP},.2) Tw(ctr,{BackgroundColor3=C.BG3},.2) end)
        end)
        tb.FocusLost:Connect(function()
            pcall(function() Tw(st,{Color=C.BG3},.2) Tw(ctr,{BackgroundColor3=C.BG2},.2) end)
        end)
        return tb, ctr
    end

    local function BigInputBox(par, ph, h)
        local ctr = New("Frame",{Size=UDim2.new(1,0,0,h or 88),BackgroundColor3=C.BG2,
            BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=ctr})
        New("UIStroke",{Color=C.BG3,Thickness=1.5,Parent=ctr})
        local tb = New("TextBox",{Size=UDim2.new(1,-12,1,-8),Position=UDim2.new(0,6,0,4),
            BackgroundTransparency=1,Text="",PlaceholderText=ph or "...",
            PlaceholderColor3=C.TXT2,TextColor3=C.TXT0,Font=Enum.Font.Code,
            TextSize=10,MultiLine=true,ClearTextOnFocus=false,
            TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
            Parent=ctr})
        return tb, ctr
    end

    local function Card(par, txt, col)
        local f = New("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=col or C.BG2,
            BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=f})
        New("UIStroke",{Color=C.BG3,Thickness=1,Parent=f})
        local l = New("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,Text=txt,TextColor3=C.TXT1,Font=Enum.Font.Gotham,
            TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        return f, l
    end

    local function Toggle(par, lbl, def, cb)
        local ctr = New("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.BG2,
            BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=ctr})
        New("TextLabel",{Size=UDim2.new(1,-62,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,Text=lbl,TextColor3=C.TXT0,Font=Enum.Font.Gotham,
            TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=ctr})
        local tbg = New("Frame",{Size=UDim2.new(0,44,0,22),Position=UDim2.new(1,-54,0.5,-11),
            BackgroundColor3=def and C.PRP or C.BG0,BorderSizePixel=0,Parent=ctr})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=tbg})
        New("UIStroke",{Color=def and C.PRP or C.TXT2,Thickness=1.5,Parent=tbg})
        local kn = New("Frame",{Size=UDim2.new(0,16,0,16),
            Position=def and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3=C.WHT,BorderSizePixel=0,Parent=tbg})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=kn})
        local v = def or false
        local tb2 = New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            Text="",ZIndex=10,Parent=ctr})
        tb2.MouseButton1Click:Connect(function()
            v = not v
            pcall(function()
                Tw(tbg,{BackgroundColor3=v and C.PRP or C.BG0},.2)
                Tw(kn,{Position=v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)},.2)
            end)
            if cb then cb(v) end
        end)
        return ctr, function() return v end
    end

    local function Slider(par, lbl, mn, mx, def, cb)
        local v = def or mn
        local ctr = New("Frame",{Size=UDim2.new(1,0,0,50),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=ctr})
        local row = New("Frame",{Size=UDim2.new(1,-16,0,18),Position=UDim2.new(0,8,0,4),BackgroundTransparency=1,Parent=ctr})
        New("TextLabel",{Size=UDim2.new(.72,0,1,0),BackgroundTransparency=1,Text=lbl,TextColor3=C.TXT0,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
        local vl = New("TextLabel",{Size=UDim2.new(.28,0,1,0),Position=UDim2.new(.72,0,0,0),BackgroundTransparency=1,Text=tostring(v),TextColor3=C.CYN,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
        local trk = New("Frame",{Size=UDim2.new(1,-16,0,7),Position=UDim2.new(0,8,0,32),BackgroundColor3=C.BG0,BorderSizePixel=0,Parent=ctr})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=trk})
        local fill = New("Frame",{Size=UDim2.new((v-mn)/(mx-mn),0,1,0),BackgroundColor3=C.PRP,BorderSizePixel=0,Parent=trk})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=fill})
        New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.DPRP),ColorSequenceKeypoint.new(1,C.CYN)}),Rotation=0,Parent=fill})
        local kn = New("Frame",{Size=UDim2.new(0,15,0,15),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new((v-mn)/(mx-mn),0,.5,0),BackgroundColor3=C.WHT,BorderSizePixel=0,ZIndex=10,Parent=trk})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=kn})
        New("UIStroke",{Color=C.PRP,Thickness=2,Parent=kn})
        local drag = false
        local sb = New("TextButton",{Size=UDim2.new(1,0,0,32),Position=UDim2.new(0,0,0,18),BackgroundTransparency=1,Text="",ZIndex=20,Parent=ctr})
        local function upd(mx2)
            local ap=trk.AbsolutePosition.X local as=trk.AbsoluteSize.X
            local rx=math.clamp((mx2-ap)/as,0,1)
            v=math.floor(mn+rx*(mx-mn))
            pcall(function() vl.Text=tostring(v) fill.Size=UDim2.new(rx,0,1,0) kn.Position=UDim2.new(rx,0,.5,0) end)
            if cb then cb(v) end
        end
        sb.MouseButton1Down:Connect(function() drag=true upd(Mouse.X) end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
        RunService.Heartbeat:Connect(function() if drag then pcall(upd,Mouse.X) end end)
        return ctr, function() return v end
    end

    local function Dropdown(par, lbl, opts, def, cb)
        local sel=def or opts[1] local open=false
        local ctr = New("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.BG2,
            BorderSizePixel=0,ClipsDescendants=false,ZIndex=50,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=ctr})
        New("UIStroke",{Color=C.BG3,Thickness=1,Parent=ctr})
        New("TextLabel",{Size=UDim2.new(0,82,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,Text=lbl,TextColor3=C.TXT1,Font=Enum.Font.Gotham,
            TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=ctr})
        local vl = New("TextLabel",{Size=UDim2.new(1,-103,1,0),Position=UDim2.new(0,88,0,0),
            BackgroundTransparency=1,Text=sel,TextColor3=C.LPRP,Font=Enum.Font.GothamBold,
            TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=ctr})
        local arr = New("TextLabel",{Size=UDim2.new(0,16,1,0),Position=UDim2.new(1,-20,0,0),
            BackgroundTransparency=1,Text="▼",TextColor3=C.LPRP,Font=Enum.Font.GothamBold,
            TextSize=9,ZIndex=51,Parent=ctr})
        local db2 = New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=52,Parent=ctr})
        local maxH = math.min(#opts*27, 148)
        local dl = New("Frame",{Size=UDim2.new(1,0,0,maxH),
            Position=UDim2.new(0,0,1,2),BackgroundColor3=Color3.fromRGB(16,9,44),
            BorderSizePixel=0,Visible=false,ZIndex=300,ClipsDescendants=true,Parent=ctr})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=dl})
        New("UIStroke",{Color=C.PRP,Thickness=1,Parent=dl})
        local sc = New("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            ScrollBarThickness=3,ScrollBarImageColor3=C.PRP,
            CanvasSize=UDim2.new(1,0,0,#opts*27),ZIndex=301,Parent=dl})
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Parent=sc})
        for _, opt in ipairs(opts) do
            local ob = New("TextButton",{Size=UDim2.new(1,0,0,27),
                BackgroundColor3=Color3.fromRGB(16,9,44),BorderSizePixel=0,
                Text=opt,TextColor3=C.TXT0,Font=Enum.Font.Gotham,TextSize=11,
                AutoButtonColor=false,ZIndex=302,Parent=sc})
            ob.MouseEnter:Connect(function() pcall(function()Tw(ob,{BackgroundColor3=C.BG3},.1)end) end)
            ob.MouseLeave:Connect(function() pcall(function()Tw(ob,{BackgroundColor3=Color3.fromRGB(16,9,44)},.1)end) end)
            ob.MouseButton1Click:Connect(function()
                sel=opt vl.Text=opt open=false dl.Visible=false arr.Text="▼"
                if cb then cb(opt) end
            end)
        end
        db2.MouseButton1Click:Connect(function()
            open=not open dl.Visible=open arr.Text=open and "▲" or "▼"
        end)
        return ctr, function() return sel end
    end

    -- ══════════════════════════════════════════
    -- FILE BROWSER  ← HANYA BACA 1 EKSTENSI
    -- folder: BUILD_FOLDER untuk .build
    --         JSON_FOLDER  untuk .json
    -- ══════════════════════════════════════════
    local function FileBrowser(par, folder, ext, onLoad)
        local accentCol = ext==".build" and C.PRP or C.CYN
        local icon      = ext==".build" and "🏗" or "📄"

        local wrap = New("Frame",{Size=UDim2.new(1,0,0,175),BackgroundColor3=C.BG2,
            BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,12),Parent=wrap})
        New("UIStroke",{Color=accentCol,Thickness=1.5,Parent=wrap})

        -- header strip
        local hstrip = New("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=accentCol,
            BorderSizePixel=0,Parent=wrap})
        New("UICorner",{CornerRadius=UDim.new(0,12),Parent=hstrip})
        New("Frame",{Size=UDim2.new(1,0,0,15),Position=UDim2.new(0,0,1,-15),
            BackgroundColor3=accentCol,BorderSizePixel=0,Parent=hstrip})

        New("TextLabel",{Size=UDim2.new(1,-90,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,
            Text=icon.."  Folder: "..folder.."   ["..ext.." only]",
            TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=hstrip})

        local refBtn = New("TextButton",{Size=UDim2.new(0,72,0,22),
            Position=UDim2.new(1,-76,0.5,-11),
            BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.45,
            BorderSizePixel=0,Text="🔄  Refresh",TextColor3=C.WHT,
            Font=Enum.Font.GothamBold,TextSize=10,AutoButtonColor=false,Parent=hstrip})
        New("UICorner",{CornerRadius=UDim.new(0,6),Parent=refBtn})

        -- file list
        local listScroll = New("ScrollingFrame",{
            Size=UDim2.new(1,-6,0,134), Position=UDim2.new(0,3,0,35),
            BackgroundTransparency=1,ScrollBarThickness=4,
            ScrollBarImageColor3=accentCol,
            CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
            Parent=wrap})
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=listScroll})
        New("UIPadding",{PaddingAll=UDim.new(0,4),Parent=listScroll})

        local function Refresh()
            for _, c in ipairs(listScroll:GetChildren()) do
                if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
            end
            local files = ListFilesExt(folder, ext)
            if #files == 0 then
                New("TextLabel",{Size=UDim2.new(1,0,0,50),BackgroundTransparency=1,
                    Text="Tidak ada file "..ext.." di folder '"..folder.."'\nLetakkan file di sana lalu Refresh.",
                    TextColor3=C.TXT2,Font=Enum.Font.Gotham,TextSize=11,
                    TextWrapped=true,Parent=listScroll})
                return
            end
            for _, f in ipairs(files) do
                local row = New("Frame",{Size=UDim2.new(1,-2,0,30),
                    BackgroundColor3=Color3.fromRGB(14,8,40),
                    BorderSizePixel=0,Parent=listScroll})
                New("UICorner",{CornerRadius=UDim.new(0,7),Parent=row})

                -- icon
                New("TextLabel",{Size=UDim2.new(0,24,1,0),Position=UDim2.new(0,4,0,0),
                    BackgroundTransparency=1,Text=icon,TextColor3=accentCol,
                    Font=Enum.Font.GothamBold,TextSize=13,Parent=row})
                -- filename
                New("TextLabel",{Size=UDim2.new(1,-88,1,0),Position=UDim2.new(0,28,0,0),
                    BackgroundTransparency=1,Text=f.name,TextColor3=C.TXT0,
                    Font=Enum.Font.Gotham,TextSize=11,
                    TextTruncate=Enum.TextTruncate.AtEnd,
                    TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
                -- load button
                local loadBtn = New("TextButton",{Size=UDim2.new(0,55,0,20),
                    Position=UDim2.new(1,-59,0.5,-10),
                    BackgroundColor3=accentCol,BorderSizePixel=0,
                    Text="▶ Load",TextColor3=C.WHT,
                    Font=Enum.Font.GothamBold,TextSize=10,
                    AutoButtonColor=false,Parent=row})
                New("UICorner",{CornerRadius=UDim.new(0,6),Parent=loadBtn})
                loadBtn.MouseEnter:Connect(function()
                    Tw(loadBtn,{BackgroundColor3=Color3.fromRGB(
                        math.min(255,math.floor(accentCol.R*255*1.3)),
                        math.min(255,math.floor(accentCol.G*255*1.3)),
                        math.min(255,math.floor(accentCol.B*255*1.3)))},.12)
                end)
                loadBtn.MouseLeave:Connect(function() Tw(loadBtn,{BackgroundColor3=accentCol},.12) end)

                -- hover row
                local clickBtn = New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=row})
                row.MouseEnter:Connect(function() Tw(row,{BackgroundColor3=C.BG3},.1) end)
                row.MouseLeave:Connect(function() Tw(row,{BackgroundColor3=Color3.fromRGB(14,8,40)},.1) end)

                local function doLoad()
                    local content = ReadFileSafe(f.path)
                    if not content then
                        -- try with folder prefix
                        content = ReadFileSafe(folder.."/"..f.name)
                    end
                    if not content then
                        Notify("Error","Gagal baca file: "..f.name,3)
                        return
                    end
                    if onLoad then onLoad(f.name, content) end
                end
                loadBtn.MouseButton1Click:Connect(doLoad)
                clickBtn.MouseButton1Click:Connect(doLoad)
            end
        end

        Refresh()
        refBtn.MouseButton1Click:Connect(function()
            Refresh()
            Notify("Refresh","File list '"..ext.."' diperbarui",2)
        end)
        return wrap, Refresh
    end

    -- ══════════════════════════════════════════
    -- TAB SWITCH LOGIC
    -- ══════════════════════════════════════════
    local tabDefs = {
        {n="Build",  lbl="🏗 Build"},
        {n="Shapes", lbl="⬡ Shape"},
        {n="Convert",lbl="🔄 Convert"},
        {n="Images", lbl="🖼 Image"},
        {n="Blocks", lbl="📦 Blocks"},
        {n="Info",   lbl="⚙ Info"},
    }

    local function SwitchTab(name)
        St.tab = name
        for _, p in pairs(TabPages)  do pcall(function() p.Visible=false end) end
        for nm, b in pairs(TabBtns) do
            pcall(function()
                if nm==name then
                    Tw(b,{BackgroundColor3=C.PRP},.2)
                    b.TextColor3=C.WHT
                else
                    Tw(b,{BackgroundColor3=C.BG2},.2)
                    b.TextColor3=C.TXT2
                end
            end)
        end
        if TabPages[name] then TabPages[name].Visible=true end
        StatusLbl.Text="✦  Tab: "..name.."  |  "..EXE
    end

    for _, td in ipairs(tabDefs) do
        local b = New("TextButton",{Size=UDim2.new(0,63,1,0),BackgroundColor3=C.BG2,
            BorderSizePixel=0,Text=td.lbl,TextColor3=C.TXT2,
            Font=Enum.Font.GothamBold,TextSize=8,AutoButtonColor=false,
            ZIndex=15,Parent=TabBar})
        New("UICorner",{CornerRadius=UDim.new(0,7),Parent=b})
        TabBtns[td.n] = b
        b.MouseButton1Click:Connect(function() SwitchTab(td.n) end)
    end

    -- ══════════════════════════════════════════
    -- PAGE: BUILD
    -- Folder builds/ → .build saja
    -- ══════════════════════════════════════════
    local BuildPage = Page("Build")

    Sec(BuildPage,"📂  Pilih File .build dari Folder '"..BUILD_FOLDER.."'","")

    local _,refreshBuildBrowser = FileBrowser(BuildPage, BUILD_FOLDER, ".build",
        function(fname, content)
            local data, err2 = BFS.ParseBuild(content)
            if data then
                St.buildData = data
                ScanInventory()
                Notify("Loaded ✓",fname.." | "..#data.blocks.." blocks",3)
                StatusLbl.Text="✅  "..fname.."  |  "..#data.blocks.." blocks"
            else
                Notify("Error","Gagal: "..(err2 or "?"),3)
            end
        end)

    Sec(BuildPage,"✏️  Atau Paste Teks .build","")
    local buildTB,_ = BigInputBox(BuildPage,'{"version":"1.0","name":"MyBoat","blocks":[...]}')
    Btn(BuildPage,"📋  Parse & Load dari Teks",C.CYN,function()
        local data,err2 = BFS.ParseBuild(buildTB.Text)
        if data then
            St.buildData=data
            ScanInventory()
            Notify("Loaded",data.name.." | "..#data.blocks.." blocks",3)
        else
            Notify("Error",err2 or "Format tidak valid",3)
        end
    end,"📋")

    Sec(BuildPage,"⚙️  Opsi Build","")
    Toggle(BuildPage,"Auto Weld setelah build",true)
    Toggle(BuildPage,"Auto Wire / Setup",true)
    Slider(BuildPage,"Delay per block (ms)",0,500,120,function(v) Placer.delay=v/1000 end)

    Sec(BuildPage,"🚀  Status & Build","")
    local _,buildStatLbl = Card(BuildPage,"Belum ada build. Pilih file .build di atas.")

    RunService.Heartbeat:Connect(function()
        if St.buildData then
            pcall(function()
                buildStatLbl.Text="📦  "..(St.buildData.name or "?").."  |  "
                    ..#St.buildData.blocks.." blocks  |  By: "..(St.buildData.author or LP.Name)
                buildStatLbl.TextColor3=C.GRN
            end)
        end
    end)

    Btn(BuildPage,"▶▶  MULAI AUTO BUILD  ◀◀",C.GRN,function()
        if not St.buildData then Notify("Error","Pilih file .build dulu!",3) return end
        ScanInventory()
        local total = #St.buildData.blocks
        StatusLbl.Text = "🔨  Building 0/"..total.."..."
        ProgBG.Visible  = true
        ProgLbl.Visible = true
        ProgFill.Size   = UDim2.new(0,0,1,0)

        Placer:Build(St.buildData, function(i, tot, bname, ok2)
            pcall(function()
                local pct = i/tot
                Tw(ProgFill,{Size=UDim2.new(pct,0,1,0)},.12)
                if bname=="DONE" then
                    ProgLbl.Text = "✅  Build selesai!  "..tot.." blocks"
                    StatusLbl.Text = "✅  Build selesai!  "..tot.." blocks"
                    task.delay(3.5,function()
                        pcall(function()
                            ProgBG.Visible=false
                            ProgLbl.Visible=false
                        end)
                    end)
                else
                    ProgLbl.Text = "🔨  ["..i.."/"..tot.."]  "..bname..(ok2 and "" or "  ⚠")
                    StatusLbl.Text = "🔨  Building ["..i.."/"..tot.."]"
                end
            end)
        end)
    end,"▶")

    Btn(BuildPage,"⏹  Stop Build",C.YLW,function() Placer:Stop() end,"⏹")
    Btn(BuildPage,"🗑  Hapus Data",C.RED,function()
        St.buildData=nil
        buildTB.Text=""
        buildStatLbl.Text="Belum ada build."
        buildStatLbl.TextColor3=C.TXT1
        StatusLbl.Text="✦  Ready  |  "..EXE
        Notify("Clear","Build data dihapus",2)
    end,"🗑")

    -- ══════════════════════════════════════════
    -- PAGE: SHAPES
    -- ══════════════════════════════════════════
    local ShapesPage2 = Page("Shapes")
    Sec(ShapesPage2,"⬡  Pilih Shape","")
    local shapeOpts = {"Ball","Cylinder","Triangle","Pyramid","Platform","HollowBox","BoatHull"}
    local _,getShape = Dropdown(ShapesPage2,"Shape:",shapeOpts,"Ball",function(v) St.stype=v end)
    local bnames={}
    for _,b in ipairs(DB) do bnames[#bnames+1]=b.n end
    local _,getSBlock = Dropdown(ShapesPage2,"Block:",bnames,"Wood Block",function(v) St.sblock=v end)
    Sec(ShapesPage2,"📐  Parameter","")
    Slider(ShapesPage2,"Radius / Base",1,15,3,function(v)St.sp.r=v St.sp.base=v end)
    Slider(ShapesPage2,"Height",1,20,5,function(v)St.sp.h=v end)
    Slider(ShapesPage2,"Width",1,20,5,function(v)St.sp.w=v end)
    Slider(ShapesPage2,"Length",1,30,8,function(v)St.sp.l=v end)
    Sec(ShapesPage2,"🔨  Generate","")
    local _,prevLbl = Card(ShapesPage2,"Preview muncul di sini.")
    Btn(ShapesPage2,"👁  Preview",C.CYN,function()
        local d=SB.Run(getShape(),getSBlock(),St.sp)
        if d then
            St.buildData=d
            prevLbl.Text="🔮  "..getShape().."  |  "..#d.blocks.." blocks  |  "..getSBlock()
            prevLbl.TextColor3=C.LPRP
            Notify("Preview",getShape().." → "..#d.blocks.." blocks",3)
        end
    end,"👁")
    Btn(ShapesPage2,"🚀  Build Shape",C.GRN,function()
        local d=SB.Run(getShape(),getSBlock(),St.sp)
        if not d then Notify("Error","Gagal generate shape",3) return end
        St.buildData=d
        Placer:Build(d,function(i,tot,bn)
            if bn=="DONE" then Notify("Done","Shape selesai! "..tot.." blocks",3)
            else StatusLbl.Text="🔨 ["..i.."/"..tot.."]" end
        end)
    end,"🚀")
    Btn(ShapesPage2,"💾  Export → .build",C.PRP,function()
        local d=SB.Run(getShape(),getSBlock(),St.sp)
        if d then
            local j=BFS.Serialize(d.name,d.blocks)
            if j then
                local saved=WriteFileSafe(BUILD_FOLDER.."/"..d.name..".build",j)
                if saved then Notify("Saved","Disimpan ke "..BUILD_FOLDER.."/"..d.name..".build",3)
                elseif setclipboard then setclipboard(j) Notify("Copied","Di-copy ke clipboard",3) end
            end
        end
    end,"💾")

    -- ══════════════════════════════════════════
    -- PAGE: CONVERT
    -- Folder json/ → .json saja
    -- ══════════════════════════════════════════
    local ConvPage = Page("Convert")
    Sec(ConvPage,"📄  Pilih File .json dari Folder '"..JSON_FOLDER.."'","")

    FileBrowser(ConvPage, JSON_FOLDER, ".json",
        function(fname, content)
            local data, err2 = BFS.ParseJSON(content)
            if data then
                St.buildData=data
                Notify("Converted ✓",fname.." → "..#data.blocks.." blocks",3)
                StatusLbl.Text="✅  "..fname.."  →  "..#data.blocks.." blocks"
            else
                Notify("Error","Gagal: "..(err2 or "?"),3)
            end
        end)

    Sec(ConvPage,"✏️  Atau Paste JSON Manual","")
    local jsonTB,_=BigInputBox(ConvPage,"Paste JSON Roblox Studio di sini...")
    Btn(ConvPage,"🔄  Convert JSON → Build",C.CYN,function()
        local data,err2=BFS.ParseJSON(jsonTB.Text)
        if data then St.buildData=data Notify("Converted","→ "..#data.blocks.." blocks",3)
        else Notify("Error",err2 or "JSON tidak valid",3) end
    end,"🔄")

    Sec(ConvPage,"🚢  Export Kapalku","")
    local _,exportStatLbl=Card(ConvPage,"Export kapal ke file .build")
    Btn(ConvPage,"🚢  Export Kapal Saya",C.PRP,function()
        Notify("Scan","Mencari kapalmu...",2)
        task.spawn(function()
            local boat=nil
            for _,c in ipairs(WS:GetDescendants()) do
                if c:IsA("Model") and c.Name:find(LP.Name,1,true) then boat=c break end
            end
            if not boat then Notify("Error","Kapal tidak ditemukan!",3) return end
            local blocks={}
            local function sc(p)
                if p:IsA("BasePart") then
                    local bd=FindBlock(p.Name)
                    local pos=p.CFrame.Position
                    blocks[#blocks+1]={id=bd.id,name=bd.n,
                        position={x=pos.X,y=pos.Y,z=pos.Z},
                        size={x=p.Size.X,y=p.Size.Y,z=p.Size.Z},
                        color={r=math.floor(p.Color.R*255),g=math.floor(p.Color.G*255),b=math.floor(p.Color.B*255)}}
                end
                for _,ch in ipairs(p:GetChildren()) do sc(ch) end
            end
            for _,ch in ipairs(boat:GetChildren()) do sc(ch) end
            local json=BFS.Serialize(boat.Name,blocks)
            if json then
                local name=boat.Name:gsub(" ","_")
                local saved=WriteFileSafe(BUILD_FOLDER.."/"..name..".build",json)
                if saved then
                    Notify("Export ✓","Disimpan ke "..BUILD_FOLDER.."/"..name..".build",4)
                    exportStatLbl.Text="✅ Saved: "..BUILD_FOLDER.."/"..name..".build  ("..#blocks.." blocks)"
                    exportStatLbl.TextColor3=C.GRN
                elseif setclipboard then
                    setclipboard(json)
                    Notify("Export","Di-copy ke clipboard ("..#blocks.." blocks)",4)
                end
            end
        end)
    end,"🚢")

    -- ══════════════════════════════════════════
    -- PAGE: IMAGES
    -- ══════════════════════════════════════════
    local ImgPage = Page("Images")
    Sec(ImgPage,"🖼  Preview Image","")
    local prevC=New("Frame",{Size=UDim2.new(1,0,0,130),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=ImgPage})
    New("UICorner",{CornerRadius=UDim.new(0,10),Parent=prevC})
    New("UIStroke",{Color=C.BG3,Thickness=1.5,Parent=prevC})
    local pImg=New("ImageLabel",{Size=UDim2.new(0,108,0,108),Position=UDim2.new(0,10,0,11),BackgroundColor3=C.BG0,BorderSizePixel=0,Image="",ScaleType=Enum.ScaleType.Fit,Parent=prevC})
    New("UICorner",{CornerRadius=UDim.new(0,9),Parent=pImg})
    New("UIStroke",{Color=C.PRP,Thickness=1,Parent=pImg})
    local pInfoF=New("Frame",{Size=UDim2.new(1,-132,1,-14),Position=UDim2.new(0,126,0,7),BackgroundTransparency=1,Parent=prevC})
    local pStat=New("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text="Belum ada image",TextColor3=C.TXT2,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=pInfoF})
    local pId=New("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,20),BackgroundTransparency=1,Text="ID: —",TextColor3=C.LPRP,Font=Enum.Font.Code,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=pInfoF})
    local imgCache={}
    Sec(ImgPage,"📥  Masukkan Asset ID","")
    local assetTB,_=InputBox(ImgPage,"Asset ID atau rbxassetid://...")
    Btn(ImgPage,"👁  Preview Image",C.CYN,function()
        local id=assetTB.Text if id=="" then Notify("Error","Masukkan ID!",3) return end
        local nid=id:match("^%d+$") and "rbxassetid://"..id or id:match("rbxassetid://") and id or nil
        if not nid then Notify("Error","Format tidak valid",3) return end
        pcall(function() pImg.Image=nid end)
        imgCache[nid]=true pStat.Text="✅ Dimuat" pStat.TextColor3=C.GRN pId.Text="ID: "..nid
        Notify("Image","Dimuat!",2)
    end,"👁")
    Sec(ImgPage,"🎨  Terapkan ke Part","")
    local partTB,_=InputBox(ImgPage,"Nama Part di Workspace...")
    local faceOpts={"Front","Back","Left","Right","Top","Bottom"}
    local _,getFace=Dropdown(ImgPage,"Face:",faceOpts,"Front")
    Btn(ImgPage,"🖼  Terapkan Decal",C.PRP,function()
        local id=assetTB.Text local pn=partTB.Text
        if id==""or pn=="" then Notify("Error","Isi ID dan nama Part!",3) return end
        local part=WS:FindFirstChild(pn,true)
        if not part then Notify("Error","Part tidak ditemukan",3) return end
        local nid=id:match("^%d+$") and "rbxassetid://"..id or id
        pcall(function()
            local d=Instance.new("Decal")
            d.Texture=nid d.Face=Enum.NormalId[getFace()] or Enum.NormalId.Front d.Parent=part
        end)
        Notify("Decal","Diterapkan ke "..pn,3)
    end,"🖼")
    Btn(ImgPage,"🗑  Hapus Cache",C.RED,function()
        imgCache={} pImg.Image=""
        pStat.Text="Cache dihapus" pStat.TextColor3=C.TXT2 pId.Text="ID: —"
        Notify("Cache","Dihapus!",2)
    end,"🗑")

    -- ══════════════════════════════════════════
    -- PAGE: BLOCKS
    -- ══════════════════════════════════════════
    local BlkPage = Page("Blocks")
    Sec(BlkPage,"📋  Inventory Kamu","")
    local _,invLbl=Card(BlkPage,"Klik Scan untuk membaca inventory BABFT kamu.")
    Btn(BlkPage,"🔄  Scan Inventory",C.CYN,function()
        local cnt=ScanInventory()
        invLbl.Text="✅  "..cnt.." jenis block tersedia di inventory-mu"
        invLbl.TextColor3=C.GRN
        Notify("Inventory",cnt.." block ditemukan",3)
    end,"🔄")

    Sec(BlkPage,"📦  Database 159 Blocks","")
    local srchTB,_=InputBox(BlkPage,"Cari nama block...")
    local catList={"Semua"}
    local catSeen={}
    for _,b in ipairs(DB) do
        if not catSeen[b.cat] then catSeen[b.cat]=true catList[#catList+1]=b.cat end
    end
    local _,getCat=Dropdown(BlkPage,"Kategori:",catList,"Semua")

    local blkFrame=New("Frame",{Size=UDim2.new(1,0,0,250),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=BlkPage})
    New("UICorner",{CornerRadius=UDim.new(0,10),Parent=blkFrame})
    local blkScr=New("ScrollingFrame",{Size=UDim2.new(1,-4,1,-4),Position=UDim2.new(0,2,0,2),
        BackgroundTransparency=1,ScrollBarThickness=4,ScrollBarImageColor3=C.PRP,
        CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=blkFrame})
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=blkScr})
    New("UIPadding",{PaddingAll=UDim.new(0,4),Parent=blkScr})

    local _,selLbl2=Card(BlkPage,"Klik block untuk place")

    local function RefreshBlocks(filter, cat)
        for _,c in ipairs(blkScr:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        local cnt=0
        for _,bl in ipairs(DB) do
            local nm=(filter=="" or bl.n:lower():find(filter:lower(),1,true))
            local cm=(cat=="Semua" or bl.cat==cat)
            if nm and cm then
                cnt=cnt+1
                local inInv = Inventory[bl.n]~=nil
                local row=New("Frame",{Size=UDim2.new(1,-2,0,28),
                    BackgroundColor3=inInv and Color3.fromRGB(10,22,14) or Color3.fromRGB(12,8,36),
                    BorderSizePixel=0,Parent=blkScr})
                New("UICorner",{CornerRadius=UDim.new(0,6),Parent=row})
                if inInv then New("UIStroke",{Color=C.GRN,Thickness=1,Parent=row}) end

                local idb=New("TextLabel",{Size=UDim2.new(0,30,0,16),Position=UDim2.new(0,2,0.5,-8),
                    BackgroundColor3=C.DPRP,BorderSizePixel=0,Text="#"..bl.id,
                    TextColor3=C.LPRP,Font=Enum.Font.GothamBold,TextSize=8,Parent=row})
                New("UICorner",{CornerRadius=UDim.new(0,4),Parent=idb})

                if inInv then
                    local cnt2=Inventory[bl.n].count or 0
                    local ib=New("TextLabel",{Size=UDim2.new(0,26,0,14),Position=UDim2.new(0,34,0.5,-7),
                        BackgroundColor3=C.GRN,BorderSizePixel=0,
                        Text=(cnt2>0 and "x"..cnt2 or "✓"),
                        TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextSize=8,Parent=row})
                    New("UICorner",{CornerRadius=UDim.new(0,3),Parent=ib})
                end

                local nx=inInv and 64 or 36
                New("TextLabel",{Size=UDim2.new(0.48,-nx,1,0),Position=UDim2.new(0,nx,0,0),
                    BackgroundTransparency=1,Text=bl.n,
                    TextColor3=inInv and C.GRN or C.TXT0,Font=Enum.Font.Gotham,TextSize=10,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    TextTruncate=Enum.TextTruncate.AtEnd,Parent=row})

                local catb=New("TextLabel",{Size=UDim2.new(0.26,0,0,13),Position=UDim2.new(0.52,0,0.5,-6.5),
                    BackgroundColor3=C.BG0,BorderSizePixel=0,Text=bl.cat,TextColor3=C.TXT2,
                    Font=Enum.Font.Gotham,TextSize=8,Parent=row})
                New("UICorner",{CornerRadius=UDim.new(0,3),Parent=catb})

                local clickBtn2=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=row})
                row.MouseEnter:Connect(function() Tw(row,{BackgroundColor3=C.BG3},.1) end)
                row.MouseLeave:Connect(function() Tw(row,{BackgroundColor3=inInv and Color3.fromRGB(10,22,14) or Color3.fromRGB(12,8,36)},.1) end)
                clickBtn2.MouseButton1Click:Connect(function()
                    selLbl2.Text=(inInv and "✅ " or "⚠ ")..bl.n.."  #"..bl.id.."  "..bl.cat..(inInv and "  ✓ di inventory" or "  ✗ tidak di inventory")
                    selLbl2.TextColor3=inInv and C.GRN or C.YLW
                    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    local pos=hrp and hrp.Position+Vector3.new(0,5,-8) or Vector3.new(0,5,0)
                    Placer:PlaceOne(bl,pos,nil)
                    Notify("Place",bl.n,2)
                end)
            end
        end
        if cnt==0 then
            New("TextLabel",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,
                Text="Tidak ada block untuk '"..filter.."'",TextColor3=C.TXT2,
                Font=Enum.Font.Gotham,TextSize=11,Parent=blkScr})
        end
    end
    RefreshBlocks("","Semua")
    srchTB.Changed:Connect(function(p) if p=="Text" then pcall(function()RefreshBlocks(srchTB.Text,getCat())end) end end)
    Btn(BlkPage,"🔄  Refresh List",C.CYN,function() RefreshBlocks(srchTB.Text,getCat()) Notify("Refresh","List diperbarui",2) end,"🔄")

    -- ══════════════════════════════════════════
    -- PAGE: INFO
    -- ══════════════════════════════════════════
    local InfoPage2 = Page("Info")
    Sec(InfoPage2,"ℹ️  Tentang OxyX","")

    local abtF=New("Frame",{Size=UDim2.new(1,0,0,118),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=InfoPage2})
    New("UICorner",{CornerRadius=UDim.new(0,12),Parent=abtF})
    New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(34,14,84)),ColorSequenceKeypoint.new(1,Color3.fromRGB(11,6,35))}),Rotation=135,Parent=abtF})

    local a2=New("ImageLabel",{Size=UDim2.new(0,82,0,82),Position=UDim2.new(0,10,0,18),BackgroundColor3=C.DPRP,BorderSizePixel=0,Image="rbxassetid://7078026274",ScaleType=Enum.ScaleType.Crop,Parent=abtF})
    New("UICorner",{CornerRadius=UDim.new(0,14),Parent=a2})
    New("UIStroke",{Color=C.PNK,Thickness=2,Parent=a2})

    local lines={{"OxyX BABFT Tool",Enum.Font.GothamBold,15,C.WHT},
        {"Galaxy Final Edition  v3.0",Enum.Font.GothamBold,11,C.LPRP},
        {"File Browser .build & .json  |  159 Blocks",Enum.Font.Gotham,10,C.TXT1},
        {"Auto Build dari Inventory Player",Enum.Font.Gotham,10,C.TXT1},
        {"Executor: "..EXE,Enum.Font.Gotham,10,C.CYN}}
    for i,ln in ipairs(lines) do
        New("TextLabel",{Size=UDim2.new(1,-108,0,19),Position=UDim2.new(0,104,0,2+(i-1)*21),
            BackgroundTransparency=1,Text=ln[1],TextColor3=ln[4],Font=ln[2],TextSize=ln[3],
            TextXAlignment=Enum.TextXAlignment.Left,Parent=abtF})
    end

    Sec(InfoPage2,"⌨️  Hotkeys","")
    local hkF=New("Frame",{Size=UDim2.new(1,0,0,100),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=InfoPage2})
    New("UICorner",{CornerRadius=UDim.new(0,9),Parent=hkF})
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=hkF})
    New("UIPadding",{PaddingAll=UDim.new(0,8),Parent=hkF})
    for _,hk in ipairs({
        {"Right Shift","Toggle UI (tampil/sembunyikan)"},
        {"Ctrl + B",   "Quick Build (build data sekarang)"},
        {"Ctrl + E",   "Export kapal ke file .build"},
        {"Ctrl + R",   "Reset / hapus build data"},
    }) do
        local r2=New("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Parent=hkF})
        local kb=New("TextLabel",{Size=UDim2.new(0,96,0,18),Position=UDim2.new(0,0,0.5,-9),
            BackgroundColor3=C.DPRP,BorderSizePixel=0,Text=hk[1],TextColor3=C.LPRP,
            Font=Enum.Font.Code,TextSize=9,Parent=r2})
        New("UICorner",{CornerRadius=UDim.new(0,4),Parent=kb})
        New("TextLabel",{Size=UDim2.new(1,-104,1,0),Position=UDim2.new(0,102,0,0),
            BackgroundTransparency=1,Text=hk[2],TextColor3=C.TXT1,Font=Enum.Font.Gotham,
            TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=r2})
    end

    Sec(InfoPage2,"⚙️  Pengaturan","")
    Slider(InfoPage2,"Transparansi UI",0,70,5,function(v) pcall(function()Inner.BackgroundTransparency=v/100 end) end)
    Toggle(InfoPage2,"Notifikasi aktif",true)

    Btn(InfoPage2,"📋  Copy GitHub URL",C.CYN,function()
        local url="https://raw.githubusercontent.com/johsua092-ui/oxyX-sc/refs/heads/main/OxyX_BABFT.lua"
        if setclipboard then setclipboard(url) Notify("GitHub","URL di-copy!",3) end
    end,"📋")
    Btn(InfoPage2,"🔄  Reload Script",C.PRP,function()
        Notify("Reload","Memuat ulang OxyX...",2)
        task.delay(0.4,function()
            pcall(function() bconn:Disconnect() ringConn:Disconnect() end)
            pcall(function() SG:Destroy() end)
            BuildUI()
        end)
    end,"🔄")

    -- ══════════════════════════════════════════
    -- DRAG WINDOW
    -- ══════════════════════════════════════════
    local dragging=false local dOff=Vector2.new(0,0)
    HDR.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dOff=Vector2.new(Mouse.X-MF.AbsolutePosition.X, Mouse.Y-MF.AbsolutePosition.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging and MF and MF.Parent then
            pcall(function()
                local vp=Cam.ViewportSize
                MF.Position=UDim2.new(0,
                    math.clamp(Mouse.X-dOff.X,0,vp.X-MF.AbsoluteSize.X),0,
                    math.clamp(Mouse.Y-dOff.Y,0,vp.Y-MF.AbsoluteSize.Y))
            end)
        end
    end)

    -- ══════════════════════════════════════════
    -- MINIMIZE / CLOSE
    -- ══════════════════════════════════════════
    MinB.MouseButton1Click:Connect(function()
        St.minimized=not St.minimized
        if St.minimized then
            Tw(MF,{Size=UDim2.new(0,440,0,90)},.3,Enum.EasingStyle.Back)
            MinB.Text="□"
        else
            Tw(MF,{Size=UDim2.new(0,440,0,620)},.35,Enum.EasingStyle.Back)
            MinB.Text="−"
        end
    end)
    CloseB.MouseButton1Click:Connect(function()
        Tw(MF,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},.25,Enum.EasingStyle.Back)
        task.delay(.28,function()
            pcall(function() bconn:Disconnect() ringConn:Disconnect() SG:Destroy() end)
        end)
    end)

    -- ══════════════════════════════════════════
    -- HOTKEYS
    -- ══════════════════════════════════════════
    UIS.InputBegan:Connect(function(inp,gp)
        if gp then return end
        pcall(function()
            if inp.KeyCode==Enum.KeyCode.RightShift then
                MF.Visible=not MF.Visible
            end
            if inp.KeyCode==Enum.KeyCode.B and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                if St.buildData then
                    Placer:Build(St.buildData,function(i,tot,bn)
                        if bn=="DONE" then Notify("Done","Build selesai! "..tot.." blocks",3)
                        else StatusLbl.Text="🔨 ["..i.."/"..tot.."]" end
                    end)
                else Notify("Error","Tidak ada build!",3) end
            end
            if inp.KeyCode==Enum.KeyCode.E and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                task.spawn(function()
                    local boat=nil
                    for _,c in ipairs(WS:GetDescendants()) do
                        if c:IsA("Model") and c.Name:find(LP.Name,1,true) then boat=c break end
                    end
                    if not boat then Notify("Error","Kapal tidak ditemukan",3) return end
                    local blocks={}
                    local function sc(p) if p:IsA("BasePart") then local bd=FindBlock(p.Name) local pos=p.CFrame.Position blocks[#blocks+1]={id=bd.id,name=bd.n,position={x=pos.X,y=pos.Y,z=pos.Z},size={x=p.Size.X,y=p.Size.Y,z=p.Size.Z},color={r=math.floor(p.Color.R*255),g=math.floor(p.Color.G*255),b=math.floor(p.Color.B*255)}} end for _,ch in ipairs(p:GetChildren()) do sc(ch) end end
                    for _,ch in ipairs(boat:GetChildren()) do sc(ch) end
                    local json=BFS.Serialize(boat.Name,blocks)
                    if json then
                        local nm=boat.Name:gsub(" ","_")
                        if not WriteFileSafe(BUILD_FOLDER.."/"..nm..".build",json) then
                            if setclipboard then setclipboard(json) end
                        end
                        Notify("Export","Kapal di-export!",3)
                    end
                end)
            end
            if inp.KeyCode==Enum.KeyCode.R and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                St.buildData=nil Notify("Reset","Build data dihapus",2)
            end
        end)
    end)

    -- ══════════════════════════════════════════
    -- STARTUP
    -- ══════════════════════════════════════════
    SwitchTab("Build")
    task.spawn(function()
        local cnt=ScanInventory()
        pcall(function()
            invLbl.Text="✅  "..cnt.." jenis block tersedia di inventory-mu"
            invLbl.TextColor3=C.GRN
        end)
    end)

    Notify("OxyX v3.0 FINAL 🌌",
        "Galaxy Edition loaded! File browser aktif.\nFolder: "..BUILD_FOLDER.." & "..JSON_FOLDER, 5)
    print("[OxyX v3.0 FINAL] ✅ UI Loaded | Executor: "..EXE)
    return SG
end

-- ═══════════════════════════════════════════════════════
-- LAUNCH
-- ═══════════════════════════════════════════════════════
local ok2, err2 = pcall(BuildUI)
if not ok2 then
    warn("[OxyX v3.0] ❌ "..tostring(err2))
    pcall(function()
        local fg=Instance.new("ScreenGui")
        fg.DisplayOrder=99999 fg.IgnoreGuiInset=true fg.Parent=GUI_PARENT
        local ff=Instance.new("Frame")
        ff.Size=UDim2.new(0,360,0,52) ff.Position=UDim2.new(0.5,-180,0,20)
        ff.BackgroundColor3=Color3.fromRGB(25,0,0) ff.BorderSizePixel=0 ff.Parent=fg
        local fl=Instance.new("TextLabel")
        fl.Size=UDim2.new(1,-10,1,0) fl.Position=UDim2.new(0,5,0,0)
        fl.BackgroundTransparency=1
        fl.Text="[OxyX] Error: "..tostring(err2)
        fl.TextColor3=Color3.fromRGB(255,80,80) fl.Font=Enum.Font.Gotham
        fl.TextSize=11 fl.TextWrapped=true fl.Parent=ff
        Debris:AddItem(fg,10)
    end)
end

print([[
╔══════════════════════════════════════════════════╗
║   OxyX BABFT  v3.0  ─  GALAXY FINAL EDITION     ║
║   🏗 File Browser:  builds/ → .build saja       ║
║   📄 File Browser:  json/   → .json saja        ║
║   📦 Build dari Inventory BABFT player sendiri   ║
║   🌌 Astolfo UI  |  159 Blocks  |  Right Shift  ║
╚══════════════════════════════════════════════════╝]])
