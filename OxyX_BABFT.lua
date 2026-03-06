-- ██████╗ ██╗  ██╗██╗   ██╗██╗  ██╗
-- ██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝╚██╗██╔╝
-- ██║   ██║ ╚███╔╝  ╚████╔╝  ╚███╔╝
-- ██║   ██║ ██╔██╗   ╚██╔╝   ██╔██╗
-- ╚██████╔╝██╔╝ ██╗   ██║   ██╔╝ ██╗
--  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
-- OxyX BABFT Tool v2.1.0 - FIXED
-- Galaxy UI | Astolfo Theme
-- Compatible: Xeno, Synapse X, KRNL, Fluxus, Delta, Script-Ware

-- =========================================================
-- BUG FIXES v2.1.0:
-- [FIX 1] CoreGui parenting sekarang pakai pcall fallback ke PlayerGui
-- [FIX 2] Hapus pemanggilan method chain :FindFirstChildOfClass() di return value
-- [FIX 3] Perbaiki duplicate frame (JsonInfo frame duplikat dihapus)
-- [FIX 4] Semua pcall wrapper untuk proteksi dari executor restriction
-- [FIX 5] IgnoreGuiInset = true agar UI tidak terpotong
-- [FIX 6] DisplayOrder tinggi agar UI tidak tertutup game UI
-- =========================================================

--// SERVICES (dengan pcall aman)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [FIX 1] CoreGui dengan fallback aman
local GuiParent
local coreGuiSuccess = pcall(function()
    GuiParent = game:GetService("CoreGui")
end)
if not coreGuiSuccess or not GuiParent then
    GuiParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

--// LOCAL PLAYER
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

--// EXECUTOR DETECTION (pcall aman)
local ExecutorName = "Unknown"
pcall(function()
    if identifyexecutor then
        ExecutorName = identifyexecutor()
    elseif syn then
        ExecutorName = "Synapse X"
    elseif KRNL_LOADED then
        ExecutorName = "KRNL"
    elseif getexecutorname then
        ExecutorName = getexecutorname()
    elseif isfolder or readfile then
        ExecutorName = "Executor"
    end
end)

--// UTILITY: CREATE INSTANCE
local function Create(class, props)
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

--// UTILITY: TWEEN
local function Tween(inst, props, duration)
    if not inst or not inst.Parent then return end
    pcall(function()
        local info = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(inst, info, props):Play()
    end)
end

--// UTILITY: NOTIFY
local function Notify(title, msg, dur)
    dur = dur or 3
    pcall(function()
        local ng = Create("ScreenGui", {
            Name = "OxyXNotif",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 9999,
            Parent = GuiParent
        })
        local nf = Create("Frame", {
            Size = UDim2.new(0, 270, 0, 75),
            Position = UDim2.new(1, 10, 1, -95),
            BackgroundColor3 = Color3.fromRGB(10, 6, 28),
            BorderSizePixel = 0,
            Parent = ng
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = nf})
        Create("UIStroke", {Color = Color3.fromRGB(138, 43, 226), Thickness = 1.5, Parent = nf})
        Create("TextLabel", {
            Size = UDim2.new(1, -10, 0, 24),
            Position = UDim2.new(0, 8, 0, 4),
            BackgroundTransparency = 1,
            Text = "🌌 " .. title,
            TextColor3 = Color3.fromRGB(180, 100, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = nf
        })
        Create("TextLabel", {
            Size = UDim2.new(1, -10, 0, 36),
            Position = UDim2.new(0, 8, 0, 28),
            BackgroundTransparency = 1,
            Text = msg,
            TextColor3 = Color3.fromRGB(200, 190, 230),
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = nf
        })
        local bar = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 1, -3),
            BackgroundColor3 = Color3.fromRGB(138, 43, 226),
            BorderSizePixel = 0,
            Parent = nf
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = bar})
        Tween(nf, {Position = UDim2.new(1, -280, 1, -95)}, 0.35)
        Tween(bar, {Size = UDim2.new(0, 0, 0, 3)}, dur)
        task.delay(dur, function()
            pcall(function()
                Tween(nf, {Position = UDim2.new(1, 10, 1, -95)}, 0.3)
                task.wait(0.32)
                ng:Destroy()
            end)
        end)
    end)
end

--// BLOCK DATABASE (159 blocks)
local BlockDatabase = {
    {id=1,   name="Back Wheel",               category="Wheels",      type="Model"},
    {id=2,   name="Balloon Block",            category="Special",     type="Block"},
    {id=3,   name="Bar",                      category="Structure",   type="Part"},
    {id=4,   name="Big Cannon",               category="Weapons",     type="Model"},
    {id=5,   name="Big Switch",               category="Electronics", type="Model"},
    {id=6,   name="Blue Candy",               category="Candy",       type="Block"},
    {id=7,   name="Boat Motor",               category="Propulsion",  type="Model"},
    {id=8,   name="Bouncy Block",             category="Special",     type="Block"},
    {id=9,   name="Boxing Glove",             category="Weapons",     type="Model"},
    {id=10,  name="Bread",                    category="Food",        type="Model"},
    {id=11,  name="Brick Block",              category="Structure",   type="Block"},
    {id=12,  name="Bundles of Potions",       category="Special",     type="Model"},
    {id=13,  name="Button",                   category="Electronics", type="Model"},
    {id=14,  name="Cake",                     category="Food",        type="Model"},
    {id=15,  name="Camera",                   category="Special",     type="Model"},
    {id=16,  name="Candle",                   category="Decoration",  type="Model"},
    {id=17,  name="Candy Cane Block",         category="Candy",       type="Block"},
    {id=18,  name="Candy Cane Rod",           category="Candy",       type="Part"},
    {id=19,  name="Cannon",                   category="Weapons",     type="Model"},
    {id=20,  name="Car Seat",                 category="Seats",       type="Model"},
    {id=21,  name="Chair",                    category="Seats",       type="Model"},
    {id=22,  name="Classic Firework",         category="Fireworks",   type="Model"},
    {id=23,  name="Coal Block",               category="Structure",   type="Block"},
    {id=24,  name="Common Chest Block",       category="Chests",      type="Model"},
    {id=25,  name="Concrete Block",           category="Structure",   type="Block"},
    {id=26,  name="Concrete Rod",             category="Structure",   type="Part"},
    {id=27,  name="Cookie Back Wheel",        category="Wheels",      type="Model"},
    {id=28,  name="Cookie Front Wheel",       category="Wheels",      type="Model"},
    {id=29,  name="Corner Wedge",             category="Structure",   type="Block"},
    {id=30,  name="Delay Block",              category="Electronics", type="Model"},
    {id=31,  name="Dome Camera",              category="Special",     type="Model"},
    {id=32,  name="Door",                     category="Structure",   type="Model"},
    {id=33,  name="Dragon Egg",               category="Special",     type="Model"},
    {id=34,  name="Dragon Harpoon",           category="Weapons",     type="Model"},
    {id=35,  name="Dual Candy Cane Harpoon",  category="Weapons",     type="Model"},
    {id=36,  name="Dynamite",                 category="Weapons",     type="Model"},
    {id=37,  name="Easter Jetpack",           category="Propulsion",  type="Model"},
    {id=38,  name="Egg Cannon",               category="Weapons",     type="Model"},
    {id=39,  name="Epic Chest Block",         category="Chests",      type="Model"},
    {id=40,  name="Fabric Block",             category="Structure",   type="Block"},
    {id=41,  name="Firework 1",               category="Fireworks",   type="Model"},
    {id=42,  name="Firework 2",               category="Fireworks",   type="Model"},
    {id=43,  name="Firework 3",               category="Fireworks",   type="Model"},
    {id=44,  name="Firework 4",               category="Fireworks",   type="Model"},
    {id=45,  name="Flag",                     category="Decoration",  type="Model"},
    {id=46,  name="Front Wheel",              category="Wheels",      type="Model"},
    {id=47,  name="Gameboard",                category="Special",     type="Model"},
    {id=48,  name="Glass Block",              category="Structure",   type="Block"},
    {id=49,  name="Glue",                     category="Electronics", type="Model"},
    {id=50,  name="Gold Block",               category="Structure",   type="Block"},
    {id=51,  name="Golden Harpoon",           category="Weapons",     type="Model"},
    {id=52,  name="Grass Block",              category="Structure",   type="Block"},
    {id=53,  name="Harpoon",                  category="Weapons",     type="Model"},
    {id=54,  name="Hatch",                    category="Structure",   type="Model"},
    {id=55,  name="Heart",                    category="Decoration",  type="Model"},
    {id=56,  name="Helm",                     category="Special",     type="Model"},
    {id=57,  name="Hinge",                    category="Electronics", type="Model"},
    {id=58,  name="Huge Back Wheel",          category="Wheels",      type="Model"},
    {id=59,  name="Huge Front Wheel",         category="Wheels",      type="Model"},
    {id=60,  name="Huge Wheel",               category="Wheels",      type="Model"},
    {id=61,  name="I-Beam",                   category="Structure",   type="Part"},
    {id=62,  name="Ice Block",                category="Structure",   type="Block"},
    {id=63,  name="Jet Turbine",              category="Propulsion",  type="Model"},
    {id=64,  name="Jetpack",                  category="Propulsion",  type="Model"},
    {id=65,  name="Lamp",                     category="Decoration",  type="Model"},
    {id=66,  name="Large Treasure",           category="Treasure",    type="Model"},
    {id=67,  name="Laser Launcher",           category="Weapons",     type="Model"},
    {id=68,  name="Legendary Chest Block",    category="Chests",      type="Model"},
    {id=69,  name="Lever",                    category="Electronics", type="Model"},
    {id=70,  name="Life Preserver",           category="Special",     type="Model"},
    {id=71,  name="Light Bulb",               category="Decoration",  type="Model"},
    {id=72,  name="Locked Door",              category="Structure",   type="Model"},
    {id=73,  name="Magnet",                   category="Special",     type="Model"},
    {id=74,  name="Marble Block",             category="Structure",   type="Block"},
    {id=75,  name="Marble Rod",               category="Structure",   type="Part"},
    {id=76,  name="Mast",                     category="Structure",   type="Model"},
    {id=77,  name="Master Builder Trophy",    category="Trophies",    type="Model"},
    {id=78,  name="Medium Treasure",          category="Treasure",    type="Model"},
    {id=79,  name="Mega Thruster",            category="Propulsion",  type="Model"},
    {id=80,  name="Metal Block",              category="Structure",   type="Block"},
    {id=81,  name="Metal Rod",                category="Structure",   type="Part"},
    {id=82,  name="Mini Gun",                 category="Weapons",     type="Model"},
    {id=83,  name="Mounted Bow",              category="Weapons",     type="Model"},
    {id=84,  name="Mounted Candy Cane Sword", category="Weapons",     type="Model"},
    {id=85,  name="Mounted Cannon",           category="Weapons",     type="Model"},
    {id=86,  name="Mounted Flintlocks",       category="Weapons",     type="Model"},
    {id=87,  name="Mounted Knight Sword",     category="Weapons",     type="Model"},
    {id=88,  name="Mounted Sword",            category="Weapons",     type="Model"},
    {id=89,  name="Mounted Wizard Staff",     category="Weapons",     type="Model"},
    {id=90,  name="Music Note",               category="Decoration",  type="Model"},
    {id=91,  name="Mystery Box",              category="Special",     type="Model"},
    {id=92,  name="Neon Block",               category="Structure",   type="Block"},
    {id=93,  name="Obsidian Block",           category="Structure",   type="Block"},
    {id=94,  name="Orange Candy",             category="Candy",       type="Block"},
    {id=95,  name="Parachute Block",          category="Special",     type="Block"},
    {id=96,  name="Peppermint Back Wheel",    category="Wheels",      type="Model"},
    {id=97,  name="Peppermint Front Wheel",   category="Wheels",      type="Model"},
    {id=98,  name="Pilot Seat",               category="Seats",       type="Model"},
    {id=99,  name="Pine Tree",                category="Decoration",  type="Model"},
    {id=100, name="Pink Candy",               category="Candy",       type="Block"},
    {id=101, name="Piston",                   category="Electronics", type="Model"},
    {id=102, name="Plastic Block",            category="Structure",   type="Block"},
    {id=103, name="Plushie 1",                category="Decoration",  type="Model"},
    {id=104, name="Plushie 2",                category="Decoration",  type="Model"},
    {id=105, name="Plushie 3",                category="Decoration",  type="Model"},
    {id=106, name="Plushie 4",                category="Decoration",  type="Model"},
    {id=107, name="Portal",                   category="Special",     type="Model"},
    {id=108, name="Pumpkin",                  category="Decoration",  type="Model"},
    {id=109, name="Purple Candy",             category="Candy",       type="Block"},
    {id=110, name="Rare Chest Block",         category="Chests",      type="Model"},
    {id=111, name="Red Candy",                category="Candy",       type="Block"},
    {id=112, name="Rope",                     category="Structure",   type="Part"},
    {id=113, name="Rusted Block",             category="Structure",   type="Block"},
    {id=114, name="Rusted Rod",               category="Structure",   type="Part"},
    {id=115, name="Sand Block",               category="Structure",   type="Block"},
    {id=116, name="Seat",                     category="Seats",       type="Model"},
    {id=117, name="Servo",                    category="Electronics", type="Model"},
    {id=118, name="Shield Generator",         category="Special",     type="Model"},
    {id=119, name="Sign",                     category="Decoration",  type="Model"},
    {id=120, name="Small Treasure",           category="Treasure",    type="Model"},
    {id=121, name="Smooth Wood Block",        category="Structure",   type="Block"},
    {id=122, name="Snowball Launcher",        category="Weapons",     type="Model"},
    {id=123, name="Soccer Ball",              category="Special",     type="Model"},
    {id=124, name="Sonic Jet Turbine",        category="Propulsion",  type="Model"},
    {id=125, name="Spike Trap",               category="Weapons",     type="Model"},
    {id=126, name="Spooky Thruster",          category="Propulsion",  type="Model"},
    {id=127, name="Star",                     category="Decoration",  type="Model"},
    {id=128, name="Star Balloon Block",       category="Special",     type="Block"},
    {id=129, name="Star Jetpack",             category="Propulsion",  type="Model"},
    {id=130, name="Steampunk Jetpack",        category="Propulsion",  type="Model"},
    {id=131, name="Step",                     category="Structure",   type="Block"},
    {id=132, name="Stone Block",              category="Structure",   type="Block"},
    {id=133, name="Stone Rod",                category="Structure",   type="Part"},
    {id=134, name="Suspension",               category="Electronics", type="Model"},
    {id=135, name="Switch",                   category="Electronics", type="Model"},
    {id=136, name="Throne",                   category="Seats",       type="Model"},
    {id=137, name="Thruster",                 category="Propulsion",  type="Model"},
    {id=138, name="Titanium Block",           category="Structure",   type="Block"},
    {id=139, name="Titanium Rod",             category="Structure",   type="Part"},
    {id=140, name="TNT",                      category="Weapons",     type="Model"},
    {id=141, name="Torch",                    category="Decoration",  type="Model"},
    {id=142, name="Toy Block",                category="Structure",   type="Block"},
    {id=143, name="Treasure Chest",           category="Treasure",    type="Model"},
    {id=144, name="Trophy 1st",               category="Trophies",    type="Model"},
    {id=145, name="Trophy 2nd",               category="Trophies",    type="Model"},
    {id=146, name="Trophy 3rd",               category="Trophies",    type="Model"},
    {id=147, name="Truss",                    category="Structure",   type="Part"},
    {id=148, name="Ultra Boat Motor",         category="Propulsion",  type="Model"},
    {id=149, name="Ultra Jetpack",            category="Propulsion",  type="Model"},
    {id=150, name="Ultra Thruster",           category="Propulsion",  type="Model"},
    {id=151, name="Uncommon Chest Block",     category="Chests",      type="Model"},
    {id=152, name="Wedge",                    category="Structure",   type="Block"},
    {id=153, name="Wheel",                    category="Wheels",      type="Model"},
    {id=154, name="Window",                   category="Structure",   type="Block"},
    {id=155, name="Winter Boat Motor",        category="Propulsion",  type="Model"},
    {id=156, name="Winter Jet Turbine",       category="Propulsion",  type="Model"},
    {id=157, name="Winter Thruster",          category="Propulsion",  type="Model"},
    {id=158, name="Wood Block",               category="Structure",   type="Block"},
    {id=159, name="Wood Rod",                 category="Structure",   type="Part"},
}

--// BUILD SYSTEM
local BuildSystem = {}

function BuildSystem.Parse(jsonStr)
    local ok, data = pcall(function() return HttpService:JSONDecode(jsonStr) end)
    if not ok or not data then Notify("Error","Format .build tidak valid!",3) return nil end
    if not data.blocks then Notify("Error","Tidak ada blocks di file .build!",3) return nil end
    return data
end

function BuildSystem.Serialize(name, blocks, welds)
    local d = {
        version="1.0", name=name or "MyBuild",
        author=LocalPlayer.Name,
        blocks=blocks or {}, welds=welds or {},
        metadata={blockCount=#(blocks or {}), gameVersion="BABFT", by="OxyX v2.1.0"}
    }
    local ok, json = pcall(function() return HttpService:JSONEncode(d) end)
    return ok and json or nil
end

function BuildSystem.FromBoat()
    local boat = nil
    for _, c in ipairs(Workspace:GetDescendants()) do
        if c:IsA("Model") and (c.Name:find(LocalPlayer.Name) or c.Name == "PlayerBoat") then
            boat = c break
        end
    end
    if not boat then Notify("Export","Kapal tidak ditemukan!",3) return nil end
    local blocks = {}
    local function scan(p)
        if p:IsA("BasePart") then
            local pos = p.CFrame.Position
            local matched = BlockDatabase[158]
            for _, bd in ipairs(BlockDatabase) do
                if p.Name:lower():find(bd.name:lower()) then matched = bd break end
            end
            table.insert(blocks, {
                id=matched.id, name=matched.name,
                position={x=pos.X,y=pos.Y,z=pos.Z},
                size={x=p.Size.X,y=p.Size.Y,z=p.Size.Z},
                color={r=math.floor(p.Color.R*255),g=math.floor(p.Color.G*255),b=math.floor(p.Color.B*255)}
            })
        end
        for _, ch in ipairs(p:GetChildren()) do scan(ch) end
    end
    for _, ch in ipairs(boat:GetChildren()) do scan(ch) end
    return BuildSystem.Serialize(boat.Name, blocks)
end

--// PLACER SYSTEM
local Placer = {placementDelay=0.1, placed={}}

function Placer:GetBlock(name)
    for _, b in ipairs(BlockDatabase) do
        if b.name:lower() == name:lower() or b.name:lower():find(name:lower()) then return b end
    end
    return nil
end

function Placer:Place(blockData, pos)
    local remotes = {}
    local rs = ReplicatedStorage
    for _, v in ipairs(rs:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            remotes[v.Name] = v
        end
    end
    local remote = remotes["PlaceBlock"] or remotes["AddBlock"] or remotes["SpawnBlock"] or remotes["Build"]
    if remote then
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer({BlockId=blockData.id, BlockName=blockData.name, Position=pos or Vector3.new(0,5,0)})
            end
        end)
        return true
    end
    return false
end

function Placer:AutoSetup(buildData)
    if not buildData or not buildData.blocks then Notify("Error","Data build tidak valid!",3) return false end
    local total = #buildData.blocks
    Notify("Auto Build","Memulai build "..total.." blocks...",2)
    task.spawn(function()
        for i, bi in ipairs(buildData.blocks) do
            local bd = self:GetBlock(bi.name)
            if bd then
                local pos = Vector3.new(
                    (bi.position and bi.position.x) or 0,
                    (bi.position and bi.position.y) or (i*1.2),
                    (bi.position and bi.position.z) or 0
                )
                self:Place(bd, pos)
                task.wait(self.placementDelay)
            end
            if i % 20 == 0 then
                Notify("Progress",i.."/"..total.." blocks",1)
            end
        end
        Notify("Selesai","Build "..total.." blocks selesai!",4)
    end)
    return true
end

--// SHAPE BUILDER
local Shapes = {}

function Shapes.Ball(bname, r)
    local bl, bs = {}, 2
    for x=-r,r do for y=-r,r do for z=-r,r do
        if x*x+y*y+z*z <= r*r then
            table.insert(bl,{name=bname,position={x=x*bs,y=y*bs,z=z*bs},size={x=bs,y=bs,z=bs}})
        end
    end end end
    return bl
end

function Shapes.Cylinder(bname, r, h)
    local bl, bs = {}, 2
    for y=0,h-1 do for x=-r,r do for z=-r,r do
        if x*x+z*z <= r*r then
            table.insert(bl,{name=bname,position={x=x*bs,y=y*bs,z=z*bs},size={x=bs,y=bs,z=bs}})
        end
    end end end
    return bl
end

function Shapes.Triangle(bname, base, h)
    local bl, bs = {}, 2
    for y=0,h-1 do
        local lw = math.floor(base*(1-(y/h)))
        for x=0,lw-1 do
            table.insert(bl,{name=bname,position={x=(x+((base-lw)/2))*bs,y=y*bs,z=0},size={x=bs,y=bs,z=bs}})
        end
    end
    return bl
end

function Shapes.Pyramid(bname, base)
    local bl, bs = {}, 2
    for y=0,base-1 do
        local ls = base-y
        for x=0,ls-1 do for z=0,ls-1 do
            table.insert(bl,{name=bname,position={x=(x+y)*bs,y=y*bs,z=(z+y)*bs},size={x=bs,y=bs,z=bs}})
        end end
    end
    return bl
end

function Shapes.Platform(bname, w, l)
    local bl, bs = {}, Vector3.new(4,1.2,2)
    for x=0,w-1 do for z=0,l-1 do
        table.insert(bl,{name=bname,position={x=x*bs.X,y=0,z=z*bs.Z},size={x=bs.X,y=bs.Y,z=bs.Z}})
    end end
    return bl
end

function Shapes.HollowBox(bname, w, h, d)
    local bl, bs = {}, 2
    for x=0,w-1 do for y=0,h-1 do for z=0,d-1 do
        if x==0 or x==w-1 or y==0 or y==h-1 or z==0 or z==d-1 then
            table.insert(bl,{name=bname,position={x=x*bs,y=y*bs,z=z*bs},size={x=bs,y=bs,z=bs}})
        end
    end end end
    return bl
end

function Shapes.BoatHull(bname, len, w)
    local bl, bw, bh, bd = {}, 4, 1.2, 2
    for x=0,len-1 do for z=0,w-1 do
        table.insert(bl,{name=bname,position={x=x*bw,y=0,z=z*bd},size={x=bw,y=bh,z=bd}})
    end end
    for x=0,len-1 do for y=1,2 do
        table.insert(bl,{name=bname,position={x=x*bw,y=y*bh,z=0},size={x=bw,y=bh,z=bd}})
        table.insert(bl,{name=bname,position={x=x*bw,y=y*bh,z=(w-1)*bd},size={x=bw,y=bh,z=bd}})
    end end
    return bl
end

function Shapes.Run(shape, bname, p)
    local bl = {}
    if     shape=="Ball"      then bl=Shapes.Ball(bname, p.r or 3)
    elseif shape=="Cylinder"  then bl=Shapes.Cylinder(bname, p.r or 3, p.h or 5)
    elseif shape=="Triangle"  then bl=Shapes.Triangle(bname, p.base or 5, p.h or 5)
    elseif shape=="Pyramid"   then bl=Shapes.Pyramid(bname, p.base or 5)
    elseif shape=="Platform"  then bl=Shapes.Platform(bname, p.w or 5, p.l or 5)
    elseif shape=="HollowBox" then bl=Shapes.HollowBox(bname, p.w or 5, p.h or 3, p.d or 5)
    elseif shape=="BoatHull"  then bl=Shapes.BoatHull(bname, p.l or 8, p.w or 4)
    end
    if #bl > 0 then
        return {version="1.0",name="OxyX_"..shape,author=LocalPlayer.Name,blocks=bl,welds={},metadata={blockCount=#bl}}
    end
    return nil
end

--// IMAGE LOADER
local ImgLoader = {cache={}, failed={}}

function ImgLoader.Normalize(id)
    if type(id)=="number" then return "rbxassetid://"..id end
    if type(id)=="string" then
        if id:match("^%d+$") then return "rbxassetid://"..id
        elseif id:match("rbxassetid://") then return id
        elseif id:match("roblox.com/asset") then
            local n=id:match("id=(%d+)") if n then return "rbxassetid://"..n end
        end
    end
    return nil
end

function ImgLoader.Load(lbl, id)
    if not lbl then return false end
    local nid = ImgLoader.Normalize(id)
    if not nid then return false end
    if ImgLoader.cache[nid] then lbl.Image=nid return true end
    if ImgLoader.failed[nid] then return false end
    local ok = pcall(function() lbl.Image=nid end)
    if ok then ImgLoader.cache[nid]=true return true
    else ImgLoader.failed[nid]=true return false end
end

-- =========================================================
-- GALAXY THEME
-- =========================================================
local C = {
    Bg       = Color3.fromRGB(5, 3, 20),
    Bg2      = Color3.fromRGB(12, 8, 35),
    Bg3      = Color3.fromRGB(22, 14, 55),
    Purple   = Color3.fromRGB(138, 43, 226),
    DkPurple = Color3.fromRGB(70, 0, 120),
    LtPurple = Color3.fromRGB(185, 105, 255),
    Cyan     = Color3.fromRGB(0, 200, 255),
    Pink     = Color3.fromRGB(255, 100, 180),
    White    = Color3.fromRGB(255, 255, 255),
    TextMain = Color3.fromRGB(230, 218, 255),
    TextSub  = Color3.fromRGB(155, 135, 195),
    TextDim  = Color3.fromRGB(90, 70, 130),
    Green    = Color3.fromRGB(80, 225, 120),
    Yellow   = Color3.fromRGB(255, 205, 50),
    Red      = Color3.fromRGB(255, 75, 75),
}

-- =========================================================
-- UI STATE
-- =========================================================
local State = {
    minimized   = false,
    tab         = "Build",
    buildData   = nil,
    shapeParams = {r=3, h=5, w=5, l=8, base=5, d=5},
    shapeType   = "Ball",
    shapeBlock  = "Wood Block",
    imgId       = "",
}

-- =========================================================
-- BUILD GUI
-- =========================================================
local function BuildUI()
    -- Hapus GUI lama jika ada
    pcall(function()
        local old = GuiParent:FindFirstChild("OxyX_BABFT")
        if old then old:Destroy() end
    end)

    -- [FIX] ScreenGui dengan DisplayOrder tinggi supaya di atas semua GUI game
    local SG = Create("ScreenGui", {
        Name             = "OxyX_BABFT",
        ResetOnSpawn     = false,
        IgnoreGuiInset   = true,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        DisplayOrder     = 9999,
        Parent           = GuiParent,
    })
    if not SG then
        Notify("Error","Gagal membuat GUI!",5)
        return
    end

    -- ── MAIN FRAME ──────────────────────────────────────────
    local MF = Create("Frame", {
        Name             = "Main",
        Size             = UDim2.new(0, 400, 0, 580),
        Position         = UDim2.new(0.5,-200, 0.5,-290),
        BackgroundColor3 = C.Bg,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        Parent           = SG,
    })
    Create("UICorner", {CornerRadius=UDim.new(0,16), Parent=MF})

    -- Animated galaxy border
    local BorderF = Create("Frame", {
        Name="Border", Size=UDim2.new(1,4,1,4), Position=UDim2.new(0,-2,0,-2),
        BackgroundColor3=C.Purple, BorderSizePixel=0, ZIndex=0, Parent=MF
    })
    Create("UICorner",{CornerRadius=UDim.new(0,18),Parent=BorderF})
    local BG = Create("UIGradient",{
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Purple),
            ColorSequenceKeypoint.new(0.33, C.Cyan),
            ColorSequenceKeypoint.new(0.66, C.Pink),
            ColorSequenceKeypoint.new(1, C.DkPurple),
        }), Rotation=45, Parent=BorderF
    })
    -- Inner background on top of border
    local InnerBg = Create("Frame", {
        Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Bg,
        BorderSizePixel=0, ZIndex=1, Parent=MF
    })
    Create("UICorner",{CornerRadius=UDim.new(0,16),Parent=InnerBg})
    Create("UIGradient",{
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(6,3,22)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(11,6,32)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(4,7,26)),
        }), Rotation=135, Parent=InnerBg
    })

    -- Bintang-bintang dekorasi
    for i=1,25 do
        local s=Create("Frame",{
            Size=UDim2.new(0,math.random(1,3),0,math.random(1,3)),
            Position=UDim2.new(math.random()*0.95,0,math.random()*0.95,0),
            BackgroundColor3=i%2==0 and C.White or C.LtPurple,
            BackgroundTransparency=math.random()*0.4,
            BorderSizePixel=0, ZIndex=2, Parent=InnerBg
        })
        Create("UICorner",{CornerRadius=UDim.new(1,0),Parent=s})
        task.spawn(function()
            while s and s.Parent do
                task.wait(1+math.random()*3)
                pcall(function()
                    Tween(s,{BackgroundTransparency=0.9},0.5)
                    task.wait(0.5)
                    Tween(s,{BackgroundTransparency=math.random()*0.3},0.5)
                end)
            end
        end)
    end

    -- Animasi rotate border
    local ba=0
    local bc = RunService.Heartbeat:Connect(function(dt)
        ba=(ba+dt*35)%360
        pcall(function() BG.Rotation=ba end)
    end)

    -- ── HEADER ──────────────────────────────────────────────
    local Hdr = Create("Frame", {
        Name="Header", Size=UDim2.new(1,0,0,72),
        BackgroundColor3=C.Bg2, BorderSizePixel=0, ZIndex=10, Parent=InnerBg
    })
    Create("UICorner",{CornerRadius=UDim.new(0,16),Parent=Hdr})
    Create("UIGradient",{
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(22,12,60)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(10,6,32)),
        }), Rotation=90, Parent=Hdr
    })
    -- fix pojok bawah header
    Create("Frame",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),
        BackgroundColor3=C.Bg2,BorderSizePixel=0,ZIndex=10,Parent=Hdr})

    -- Astolfo image
    local AImg = Create("ImageLabel", {
        Size=UDim2.new(0,54,0,54), Position=UDim2.new(0,10,0,9),
        BackgroundColor3=C.Bg3, BorderSizePixel=0,
        Image="rbxassetid://7078026274",
        ScaleType=Enum.ScaleType.Fit, ZIndex=15, Parent=Hdr
    })
    Create("UICorner",{CornerRadius=UDim.new(0,10),Parent=AImg})
    local AS=Create("UIStroke",{Color=C.Pink,Thickness=2,Parent=AImg})

    -- Animasi glow Astolfo
    task.spawn(function()
        local gc={C.Pink,C.Cyan,C.LtPurple,C.Purple}
        local gi=1
        while AImg and AImg.Parent do
            gi=(gi%#gc)+1
            pcall(function() Tween(AS,{Color=gc[gi]},1) end)
            task.wait(1.2)
        end
    end)

    -- Title
    local TF=Create("Frame",{Size=UDim2.new(0,200,0,54),Position=UDim2.new(0,74,0,9),
        BackgroundTransparency=1,ZIndex=15,Parent=Hdr})
    local TL=Create("TextLabel",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,
        Text="OxyX",TextColor3=C.White,Font=Enum.Font.GothamBold,TextScaled=true,ZIndex=15,Parent=TF})
    Create("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.LtPurple),
        ColorSequenceKeypoint.new(0.5,C.Cyan),
        ColorSequenceKeypoint.new(1,C.Pink),
    }),Rotation=0,Parent=TL})
    Create("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,32),
        BackgroundTransparency=1,Text="Build A Boat For Treasure Tool",
        TextColor3=C.TextSub,Font=Enum.Font.Gotham,TextScaled=true,ZIndex=15,Parent=TF})
    local VB=Create("TextLabel",{Size=UDim2.new(0,65,0,16),Position=UDim2.new(0,0,0,52),
        BackgroundColor3=C.DkPurple,BorderSizePixel=0,Text="v2.1.0 FIXED",
        TextColor3=C.LtPurple,Font=Enum.Font.GothamBold,TextSize=9,ZIndex=16,Parent=TF})
    Create("UICorner",{CornerRadius=UDim.new(0,4),Parent=VB})

    -- Tombol Minimize & Close
    local CF=Create("Frame",{Size=UDim2.new(0,68,0,28),Position=UDim2.new(1,-78,0,10),
        BackgroundTransparency=1,ZIndex=20,Parent=Hdr})

    local MinB=Create("TextButton",{Size=UDim2.new(0,28,0,28),BackgroundColor3=C.Bg3,
        BorderSizePixel=0,Text="−",TextColor3=C.Yellow,Font=Enum.Font.GothamBold,
        TextSize=18,AutoButtonColor=false,ZIndex=20,Parent=CF})
    Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=MinB})
    Create("UIStroke",{Color=C.Yellow,Thickness=1,Parent=MinB})

    local CloseB=Create("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(0,34,0,0),
        BackgroundColor3=C.Bg3,BorderSizePixel=0,Text="✕",TextColor3=C.Red,
        Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,ZIndex=20,Parent=CF})
    Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=CloseB})
    Create("UIStroke",{Color=C.Red,Thickness=1,Parent=CloseB})

    -- ── TAB BAR ─────────────────────────────────────────────
    local TabBar=Create("Frame",{Name="TabBar",Size=UDim2.new(1,0,0,38),
        Position=UDim2.new(0,0,0,72),BackgroundColor3=C.Bg2,BorderSizePixel=0,ZIndex=10,Parent=InnerBg})
    Create("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(16,9,45)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(9,6,28)),
    }),Rotation=90,Parent=TabBar})
    Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,
        SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),Parent=TabBar})
    Create("UIPadding",{PaddingLeft=UDim.new(0,5),PaddingTop=UDim.new(0,5),
        PaddingBottom=UDim.new(0,5),Parent=TabBar})

    -- ── CONTENT SCROLL ──────────────────────────────────────
    local Content=Create("ScrollingFrame",{Name="Content",
        Size=UDim2.new(1,0,1,-148),Position=UDim2.new(0,0,0,110),
        BackgroundColor3=C.Bg,BorderSizePixel=0,
        ScrollBarThickness=4,ScrollBarImageColor3=C.Purple,
        CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=5,Parent=InnerBg})

    -- ── STATUS BAR ──────────────────────────────────────────
    local SBar=Create("Frame",{Size=UDim2.new(1,0,0,32),Position=UDim2.new(0,0,1,-32),
        BackgroundColor3=C.Bg2,BorderSizePixel=0,ZIndex=10,Parent=InnerBg})
    Create("UICorner",{CornerRadius=UDim.new(0,16),Parent=SBar})
    Create("Frame",{Size=UDim2.new(1,0,0,18),BackgroundColor3=C.Bg2,BorderSizePixel=0,ZIndex=10,Parent=SBar})
    local StatusLbl=Create("TextLabel",{Size=UDim2.new(1,-110,1,0),Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,Text="🌌 Ready | "..ExecutorName,
        TextColor3=C.TextSub,Font=Enum.Font.Gotham,TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=15,Parent=SBar})
    Create("TextLabel",{Size=UDim2.new(0,100,1,0),Position=UDim2.new(1,-105,0,0),
        BackgroundTransparency=1,Text="159 Blocks ✓",TextColor3=C.LtPurple,
        Font=Enum.Font.GothamBold,TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Right,ZIndex=15,Parent=SBar})

    -- =========================================================
    -- HELPER WIDGETS
    -- =========================================================
    local TabBtns = {}
    local TabPages = {}

    local function MakePage(name)
        local p=Create("Frame",{Name="P_"..name,Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,Visible=false,Parent=Content})
        Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,7),Parent=p})
        Create("UIPadding",{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),
            PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),Parent=p})
        TabPages[name]=p
        return p
    end

    local function Section(par, txt, ico)
        local f=Create("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=C.Bg3,
            BorderSizePixel=0,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=f})
        Create("UIGradient",{Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(38,18,88)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(20,10,52)),
        }),Rotation=90,Parent=f})
        Create("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=C.Purple,BorderSizePixel=0,Parent=f})
        Create("TextLabel",{Size=UDim2.new(1,-18,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,Text=(ico or "◆").." "..txt,TextColor3=C.LtPurple,
            Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        return f
    end

    local function Btn(par, txt, ico, col, cb)
        col=col or C.Purple
        local r=col.R*255*0.3
        local g=col.G*255*0.3
        local b=col.B*255*0.3
        local btn=Create("TextButton",{Size=UDim2.new(1,0,0,36),
            BackgroundColor3=Color3.fromRGB(math.floor(r),math.floor(g),math.floor(b)),
            BorderSizePixel=0,Text=(ico and ico.." " or "")..txt,
            TextColor3=C.TextMain,Font=Enum.Font.GothamBold,TextSize=13,
            AutoButtonColor=false,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,10),Parent=btn})
        Create("UIStroke",{Color=col,Thickness=1.5,Parent=btn})
        btn.MouseEnter:Connect(function()
            Tween(btn,{BackgroundColor3=Color3.fromRGB(math.floor(r*1.8),math.floor(g*1.8),math.floor(b*1.8))},0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn,{BackgroundColor3=Color3.fromRGB(math.floor(r),math.floor(g),math.floor(b))},0.15)
        end)
        if cb then btn.MouseButton1Click:Connect(cb) end
        return btn
    end

    local function Input(par, ph, def)
        local ctr=Create("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.Bg3,
            BorderSizePixel=0,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        Create("UIStroke",{Color=C.DkPurple,Thickness=1,Parent=ctr})
        local tb=Create("TextBox",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,Text=def or "",PlaceholderText=ph or "...",
            PlaceholderColor3=C.TextDim,TextColor3=C.TextMain,Font=Enum.Font.Gotham,
            TextSize=12,ClearTextOnFocus=false,Parent=ctr})
        tb.Focused:Connect(function() pcall(function() Tween(ctr,{BackgroundColor3=Color3.fromRGB(28,16,65)},0.2) end) end)
        tb.FocusLost:Connect(function() pcall(function() Tween(ctr,{BackgroundColor3=C.Bg3},0.2) end) end)
        return tb, ctr
    end

    local function BigInput(par, ph)
        local ctr=Create("Frame",{Size=UDim2.new(1,0,0,90),BackgroundColor3=C.Bg3,
            BorderSizePixel=0,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        Create("UIStroke",{Color=C.DkPurple,Thickness=1,Parent=ctr})
        local tb=Create("TextBox",{Size=UDim2.new(1,-12,1,-8),Position=UDim2.new(0,6,0,4),
            BackgroundTransparency=1,Text="",PlaceholderText=ph or "...",
            PlaceholderColor3=C.TextDim,TextColor3=C.TextMain,Font=Enum.Font.Code,
            TextSize=10,MultiLine=true,ClearTextOnFocus=false,
            TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
            Parent=ctr})
        return tb, ctr
    end

    local function Toggle(par, lbl, def, cb)
        local ctr=Create("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.Bg3,
            BorderSizePixel=0,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        Create("TextLabel",{Size=UDim2.new(1,-60,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,Text=lbl,TextColor3=C.TextMain,Font=Enum.Font.Gotham,
            TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=ctr})
        local tbg=Create("Frame",{Size=UDim2.new(0,42,0,20),Position=UDim2.new(1,-52,0.5,-10),
            BackgroundColor3=def and C.Purple or C.Bg,BorderSizePixel=0,Parent=ctr})
        Create("UICorner",{CornerRadius=UDim.new(1,0),Parent=tbg})
        Create("UIStroke",{Color=def and C.Purple or C.TextDim,Thickness=1.5,Parent=tbg})
        local knob=Create("Frame",{Size=UDim2.new(0,14,0,14),
            Position=def and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            BackgroundColor3=C.White,BorderSizePixel=0,Parent=tbg})
        Create("UICorner",{CornerRadius=UDim.new(1,0),Parent=knob})
        local val=def or false
        local tb2=Create("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=10,Parent=ctr})
        tb2.MouseButton1Click:Connect(function()
            val=not val
            pcall(function()
                Tween(tbg,{BackgroundColor3=val and C.Purple or C.Bg},0.2)
                Tween(knob,{Position=val and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.2)
            end)
            if cb then cb(val) end
        end)
        return ctr, function() return val end
    end

    local function Slider(par, lbl, mn, mx, def, cb)
        local val=def or mn
        local ctr=Create("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=C.Bg3,BorderSizePixel=0,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        local row=Create("Frame",{Size=UDim2.new(1,-18,0,18),Position=UDim2.new(0,9,0,4),BackgroundTransparency=1,Parent=ctr})
        Create("TextLabel",{Size=UDim2.new(0.7,0,1,0),BackgroundTransparency=1,Text=lbl,
            TextColor3=C.TextMain,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
        local vl=Create("TextLabel",{Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0.7,0,0,0),
            BackgroundTransparency=1,Text=tostring(val),TextColor3=C.LtPurple,
            Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
        local trk=Create("Frame",{Size=UDim2.new(1,-18,0,6),Position=UDim2.new(0,9,0,30),
            BackgroundColor3=C.Bg,BorderSizePixel=0,Parent=ctr})
        Create("UICorner",{CornerRadius=UDim.new(1,0),Parent=trk})
        local fill=Create("Frame",{Size=UDim2.new((val-mn)/(mx-mn),0,1,0),BackgroundColor3=C.Purple,BorderSizePixel=0,Parent=trk})
        Create("UICorner",{CornerRadius=UDim.new(1,0),Parent=fill})
        Create("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.DkPurple),ColorSequenceKeypoint.new(1,C.Cyan)}),Rotation=0,Parent=fill})
        local knob=Create("Frame",{Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new((val-mn)/(mx-mn),0,0.5,0),BackgroundColor3=C.White,BorderSizePixel=0,ZIndex=10,Parent=trk})
        Create("UICorner",{CornerRadius=UDim.new(1,0),Parent=knob})
        Create("UIStroke",{Color=C.Purple,Thickness=2,Parent=knob})
        local drag=false
        local sb=Create("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,0,20),
            BackgroundTransparency=1,Text="",ZIndex=20,Parent=ctr})
        local function upd(mx2)
            local ap=trk.AbsolutePosition.X
            local as=trk.AbsoluteSize.X
            local rx=math.clamp((mx2-ap)/as,0,1)
            val=math.floor(mn+rx*(mx-mn))
            pcall(function()
                vl.Text=tostring(val)
                fill.Size=UDim2.new(rx,0,1,0)
                knob.Position=UDim2.new(rx,0,0.5,0)
            end)
            if cb then cb(val) end
        end
        sb.MouseButton1Down:Connect(function() drag=true upd(Mouse.X) end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
        RunService.Heartbeat:Connect(function() if drag then pcall(upd,Mouse.X) end end)
        return ctr, function() return val end
    end

    local function Dropdown(par, lbl, opts, def, cb)
        local sel=def or opts[1]
        local open=false
        local ctr=Create("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.Bg3,
            BorderSizePixel=0,ClipsDescendants=false,ZIndex=50,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        Create("UIStroke",{Color=C.DkPurple,Thickness=1,Parent=ctr})
        Create("TextLabel",{Size=UDim2.new(0,90,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,Text=lbl,TextColor3=C.TextSub,Font=Enum.Font.Gotham,
            TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=ctr})
        local vl=Create("TextLabel",{Size=UDim2.new(1,-110,1,0),Position=UDim2.new(0,95,0,0),
            BackgroundTransparency=1,Text=sel,TextColor3=C.LtPurple,
            Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=ctr})
        local arrow=Create("TextLabel",{Size=UDim2.new(0,18,1,0),Position=UDim2.new(1,-22,0,0),
            BackgroundTransparency=1,Text="▼",TextColor3=C.LtPurple,Font=Enum.Font.GothamBold,TextSize=10,ZIndex=51,Parent=ctr})
        local db=Create("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=52,Parent=ctr})
        local dl=Create("Frame",{Size=UDim2.new(1,0,0,math.min(#opts*28,140)),
            Position=UDim2.new(0,0,1,2),BackgroundColor3=Color3.fromRGB(18,10,46),
            BorderSizePixel=0,Visible=false,ZIndex=100,ClipsDescendants=true,Parent=ctr})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=dl})
        Create("UIStroke",{Color=C.Purple,Thickness=1,Parent=dl})
        local sc2=Create("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            ScrollBarThickness=3,ScrollBarImageColor3=C.Purple,
            CanvasSize=UDim2.new(1,0,0,#opts*28),ZIndex=101,Parent=dl})
        Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Parent=sc2})
        for _,opt in ipairs(opts) do
            local ob=Create("TextButton",{Size=UDim2.new(1,0,0,28),
                BackgroundColor3=Color3.fromRGB(18,10,46),BorderSizePixel=0,
                Text=opt,TextColor3=C.TextMain,Font=Enum.Font.Gotham,TextSize=11,
                AutoButtonColor=false,ZIndex=102,Parent=sc2})
            ob.MouseEnter:Connect(function() pcall(function() Tween(ob,{BackgroundColor3=C.Bg3},0.1) end) end)
            ob.MouseLeave:Connect(function() pcall(function() Tween(ob,{BackgroundColor3=Color3.fromRGB(18,10,46)},0.1) end) end)
            ob.MouseButton1Click:Connect(function()
                sel=opt vl.Text=opt open=false dl.Visible=false arrow.Text="▼"
                if cb then cb(opt) end
            end)
        end
        db.MouseButton1Click:Connect(function()
            open=not open dl.Visible=open arrow.Text=open and "▲" or "▼"
        end)
        return ctr, function() return sel end
    end

    local function InfoBox(par, txt)
        local f=Create("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=C.Bg3,BorderSizePixel=0,Parent=par})
        Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=f})
        Create("UIStroke",{Color=C.DkPurple,Thickness=1,Parent=f})
        local l=Create("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,Text=txt,TextColor3=C.TextSub,Font=Enum.Font.Gotham,
            TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        return f, l
    end

    -- =========================================================
    -- TAB SWITCHER
    -- =========================================================
    local TabDefs = {
        {n="Build",   label="🏗 Build"},
        {n="Shapes",  label="⬡ Shapes"},
        {n="Convert", label="🔄 Convert"},
        {n="Images",  label="🖼 Images"},
        {n="Blocks",  label="📦 Blocks"},
        {n="Info",    label="⚙ Info"},
    }

    local function SwitchTab(name)
        State.tab=name
        for _, p in pairs(TabPages) do p.Visible=false end
        for n, b in pairs(TabBtns) do
            pcall(function()
                if n==name then
                    Tween(b,{BackgroundColor3=C.Purple},0.2) b.TextColor3=C.White
                else
                    Tween(b,{BackgroundColor3=C.Bg3},0.2) b.TextColor3=C.TextDim
                end
            end)
        end
        if TabPages[name] then TabPages[name].Visible=true end
        StatusLbl.Text="🌌 Tab: "..name.." | "..ExecutorName
    end

    for _, td in ipairs(TabDefs) do
        local b=Create("TextButton",{Size=UDim2.new(0,60,1,0),BackgroundColor3=C.Bg3,
            BorderSizePixel=0,Text=td.label,TextColor3=C.TextDim,Font=Enum.Font.GothamBold,
            TextSize=8,AutoButtonColor=false,ZIndex=15,Parent=TabBar})
        Create("UICorner",{CornerRadius=UDim.new(0,6),Parent=b})
        TabBtns[td.n]=b
        b.MouseButton1Click:Connect(function() SwitchTab(td.n) end)
    end

    -- =========================================================
    -- PAGE: BUILD
    -- =========================================================
    local BuildPage = MakePage("Build")

    Section(BuildPage,"Load File .build","📂")

    local _, buildInfoBox = InfoBox(BuildPage,"💡 Paste konten file .build (JSON) di bawah ini, lalu klik Parse.")
    local buildTB, _ = BigInput(BuildPage,'{"version":"1.0","name":"MyBoat","blocks":[...]}')

    Btn(BuildPage,"Parse & Load .build","📋",C.Cyan,function()
        local txt=buildTB.Text
        if txt=="" then Notify("Error","Paste dulu konten .build nya!",3) return end
        local data=BuildSystem.Parse(txt)
        if data then
            State.buildData=data
            buildInfoBox.Text="✅ Loaded: "..(data.name or "?").." | "..#data.blocks.." blocks | By: "..(data.author or "?")
            buildInfoBox.TextColor3=C.Green
            Notify("Loaded",(data.name or "Build").." | "..#data.blocks.." blocks siap!",3)
            StatusLbl.Text="✅ Build loaded: "..#data.blocks.." blocks"
        end
    end)

    Section(BuildPage,"Opsi Auto Build","🔧")
    local _,getWeld=Toggle(BuildPage,"Auto Weld Blocks",true,function(v) Notify("Weld","Auto Weld: "..(v and"ON"or"OFF"),2) end)
    local _,getWire=Toggle(BuildPage,"Auto Wire / Setup",true,function(v) Notify("Wire","Auto Wire: "..(v and"ON"or"OFF"),2) end)
    local _,getDelay=Slider(BuildPage,"Delay Penempatan (ms)",0,500,100,function(v) Placer.placementDelay=v/1000 end)

    Section(BuildPage,"Aksi Build","▶")

    local _, buildStatusBox = InfoBox(BuildPage,"Belum ada build yang di-load.")

    RunService.Heartbeat:Connect(function()
        if State.buildData and buildStatusBox and buildStatusBox.Parent then
            pcall(function()
                buildStatusBox.Text="📦 "..(State.buildData.name or "?").." | "..#State.buildData.blocks.." blocks"
                buildStatusBox.TextColor3=C.Green
            end)
        end
    end)

    Btn(BuildPage,"▶  START AUTO BUILD","🚀",C.Green,function()
        if not State.buildData then Notify("Error","Load dulu file .build nya!",3) return end
        StatusLbl.Text="🔨 Building..."
        Placer:AutoSetup(State.buildData)
    end)

    Btn(BuildPage,"Hapus Data Build","🗑",C.Red,function()
        State.buildData=nil
        buildTB.Text=""
        buildInfoBox.Text="💡 Paste konten file .build (JSON) di bawah ini, lalu klik Parse."
        buildInfoBox.TextColor3=C.TextSub
        buildStatusBox.Text="Belum ada build yang di-load."
        buildStatusBox.TextColor3=C.TextSub
        StatusLbl.Text="🌌 Ready | "..ExecutorName
        Notify("Cleared","Data build dihapus!",2)
    end)

    -- =========================================================
    -- PAGE: SHAPES
    -- =========================================================
    local ShapesPage2 = MakePage("Shapes")

    Section(ShapesPage2,"Jenis Shape","⬡")

    local shapeList={"Ball","Cylinder","Triangle","Pyramid","Platform","HollowBox","BoatHull"}
    local _,getShape=Dropdown(ShapesPage2,"Shape:",shapeList,"Ball",function(v) State.shapeType=v end)

    local bnames={}
    for _,b in ipairs(BlockDatabase) do table.insert(bnames,b.name) end
    local _,getShapeBlock=Dropdown(ShapesPage2,"Block:",bnames,"Wood Block",function(v) State.shapeBlock=v end)

    Section(ShapesPage2,"Parameter Shape","📐")
    local _,gR=Slider(ShapesPage2,"Radius / Base",1,15,3,function(v) State.shapeParams.r=v State.shapeParams.base=v end)
    local _,gH=Slider(ShapesPage2,"Height / Tinggi",1,20,5,function(v) State.shapeParams.h=v end)
    local _,gW=Slider(ShapesPage2,"Width / Lebar",1,20,5,function(v) State.shapeParams.w=v end)
    local _,gL=Slider(ShapesPage2,"Length / Panjang",1,30,8,function(v) State.shapeParams.l=v end)

    Section(ShapesPage2,"Generate & Build","🔨")

    local _, shapeInfoBox = InfoBox(ShapesPage2,"Preview shape akan muncul di sini setelah klik Preview.")

    Btn(ShapesPage2,"👁  Preview Shape","",C.Cyan,function()
        local data=Shapes.Run(getShape(),getShapeBlock(),State.shapeParams)
        if data then
            State.buildData=data
            shapeInfoBox.Text="🔮 "..getShape().." | "..#data.blocks.." blocks | "..getShapeBlock()
            shapeInfoBox.TextColor3=C.LtPurple
            Notify("Preview",getShape().." siap: "..#data.blocks.." blocks",3)
        else
            Notify("Error","Gagal generate shape!",3)
        end
    end)

    Btn(ShapesPage2,"🚀  Build Shape Sekarang","",C.Green,function()
        local data=Shapes.Run(getShape(),getShapeBlock(),State.shapeParams)
        if data then
            State.buildData=data
            Placer:AutoSetup(data)
        else
            Notify("Error","Gagal generate shape!",3)
        end
    end)

    Btn(ShapesPage2,"💾  Export Shape → .build","",C.Purple,function()
        local data=Shapes.Run(getShape(),getShapeBlock(),State.shapeParams)
        if data then
            local json=BuildSystem.Serialize(data.name,data.blocks)
            if json then
                if setclipboard then setclipboard(json)
                elseif toclipboard then toclipboard(json) end
                Notify("Export","Shape di-copy ke clipboard sebagai .build!",3)
            end
        end
    end)

    -- =========================================================
    -- PAGE: CONVERT
    -- =========================================================
    local ConvPage = MakePage("Convert")

    Section(ConvPage,"Export Kapal → .build","🚢")
    InfoBox(ConvPage,"Scan & export kapal kamu saat ini ke format .build untuk disimpan dan dimuat ulang.")

    Btn(ConvPage,"Export Kapal Saya → .build","🚢",C.Purple,function()
        Notify("Scanning","Mencari kapal kamu...",2)
        task.spawn(function()
            local json=BuildSystem.FromBoat()
            if json then
                if setclipboard then setclipboard(json)
                elseif toclipboard then toclipboard(json) end
                Notify("Export","Kapal berhasil di-export ke clipboard!",4)
                StatusLbl.Text="✅ Kapal ter-export!"
            else
                Notify("Error","Kapal tidak ditemukan!",3)
            end
        end)
    end)

    Section(ConvPage,"JSON Studio → .build","📄")
    InfoBox(ConvPage,"Paste JSON export dari Roblox Studio di bawah untuk diconvert ke format .build.")

    local jsonTB,_=BigInput(ConvPage,"Paste Roblox Studio JSON di sini...")

    Btn(ConvPage,"Convert JSON → .build","🔄",C.Cyan,function()
        local txt=jsonTB.Text
        if txt=="" then Notify("Error","Paste JSON dulu!",3) return end
        local ok,parsed=pcall(function() return HttpService:JSONDecode(txt) end)
        if not ok then Notify("Error","JSON tidak valid!",3) return end
        local blocks={}
        local function scan(o)
            if type(o)~="table" then return end
            if o.ClassName=="Part" or o.ClassName=="MeshPart" or o.ClassName=="UnionOperation" then
                local mb=Placer:GetBlock(o.Name or "Wood Block") or BlockDatabase[158]
                table.insert(blocks,{id=mb.id,name=mb.name,
                    position={x=(o.CFrame and o.CFrame[1]) or 0,y=(o.CFrame and o.CFrame[2]) or 5,z=(o.CFrame and o.CFrame[3]) or 0},
                    size={x=(o.Size and o.Size[1]) or 4,y=(o.Size and o.Size[2]) or 1.2,z=(o.Size and o.Size[3]) or 2}})
            end
            if o.Children then for _,c in ipairs(o.Children) do scan(c) end end
        end
        scan(parsed)
        if #blocks==0 then table.insert(blocks,{id=158,name="Wood Block",position={x=0,y=5,z=0},size={x=4,y=1.2,z=2}}) end
        local json=BuildSystem.Serialize("Converted",blocks)
        if json then
            if setclipboard then setclipboard(json)
            elseif toclipboard then toclipboard(json) end
            Notify("Convert","Diconvert: "..#blocks.." parts → .build. Copy ke clipboard!",4)
        end
    end)

    Section(ConvPage,"Simpan / Load .build","💾")
    local saveNameTB,_=Input(ConvPage,"Nama build untuk simpan/load...","")

    Btn(ConvPage,"Simpan Build ke File","💾",C.Green,function()
        if not State.buildData then Notify("Error","Tidak ada build!",3) return end
        local name=saveNameTB.Text~="" and saveNameTB.Text or "MyBuild"
        local json=BuildSystem.Serialize(name,State.buildData.blocks)
        if json and writefile then
            pcall(function() writefile("OxyX_"..name..".build",json) end)
            Notify("Saved","Disimpan: OxyX_"..name..".build",3)
        elseif json and setclipboard then
            setclipboard(json)
            Notify("Saved","Copy ke clipboard (executor tidak support file)",3)
        end
    end)

    Btn(ConvPage,"Load Build dari File","📂",C.Cyan,function()
        local name=saveNameTB.Text~="" and saveNameTB.Text or ""
        if name~="" and readfile then
            local ok2,content=pcall(readfile,"OxyX_"..name..".build")
            if ok2 and content then
                local data=BuildSystem.Parse(content)
                if data then
                    State.buildData=data
                    Notify("Loaded","Build dimuat: "..#data.blocks.." blocks",3)
                end
            else
                Notify("Error","File tidak ditemukan: OxyX_"..name..".build",3)
            end
        else
            Notify("Info","Masukkan nama build & pastikan executor support readfile",3)
        end
    end)

    -- =========================================================
    -- PAGE: IMAGES
    -- =========================================================
    local ImgPage = MakePage("Images")

    Section(ImgPage,"Preview & Load Image","🖼")

    local prevCtr=Create("Frame",{Size=UDim2.new(1,0,0,140),BackgroundColor3=C.Bg3,BorderSizePixel=0,Parent=ImgPage})
    Create("UICorner",{CornerRadius=UDim.new(0,10),Parent=prevCtr})
    Create("UIStroke",{Color=C.DkPurple,Thickness=1.5,Parent=prevCtr})

    local prevImg=Create("ImageLabel",{Size=UDim2.new(0,120,0,120),Position=UDim2.new(0,10,0,10),
        BackgroundColor3=C.Bg,BorderSizePixel=0,Image="",ScaleType=Enum.ScaleType.Fit,Parent=prevCtr})
    Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=prevImg})
    Create("UIStroke",{Color=C.Purple,Thickness=1,Parent=prevImg})

    local imgInfoF=Create("Frame",{Size=UDim2.new(1,-148,1,-16),Position=UDim2.new(0,140,0,8),
        BackgroundTransparency=1,Parent=prevCtr})
    local imgStat=Create("TextLabel",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,
        Text="Belum ada image",TextColor3=C.TextDim,Font=Enum.Font.Gotham,TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=imgInfoF})
    local imgId=Create("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,22),
        BackgroundTransparency=1,Text="ID: —",TextColor3=C.LtPurple,Font=Enum.Font.Code,TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=imgInfoF})
    local cacheInfo=Create("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,42),
        BackgroundTransparency=1,Text="Cache: 0",TextColor3=C.TextSub,Font=Enum.Font.Gotham,TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=imgInfoF})

    Section(ImgPage,"Masukkan Asset ID","📥")
    local assetTB,_=Input(ImgPage,"Asset ID atau rbxassetid://...","")

    Btn(ImgPage,"👁  Preview Image","",C.Cyan,function()
        local id=assetTB.Text
        if id=="" then Notify("Error","Masukkan Asset ID!",3) return end
        local ok3=ImgLoader.Load(prevImg,id)
        local nid=ImgLoader.Normalize(id)
        if ok3 then
            imgStat.Text="✅ Image berhasil dimuat" imgStat.TextColor3=C.Green
            imgId.Text="ID: "..(nid or id)
            local cn=0 for _ in pairs(ImgLoader.cache) do cn=cn+1 end
            cacheInfo.Text="Cache: "..cn.." image"
            Notify("Image","Image dimuat!",2)
        else
            imgStat.Text="❌ Gagal memuat image" imgStat.TextColor3=C.Red
            Notify("Error","Gagal: "..id,3)
        end
    end)

    Section(ImgPage,"Terapkan ke Block / Part","🎨")
    local partTB,_=Input(ImgPage,"Nama Part di Workspace...","")
    local faceList={"Front","Back","Left","Right","Top","Bottom"}
    local _,getFace=Dropdown(ImgPage,"Face:",faceList,"Front",function(v) end)

    Btn(ImgPage,"Terapkan sebagai Decal","🖼",C.Purple,function()
        local id=assetTB.Text local pname=partTB.Text
        if id==""or pname=="" then Notify("Error","Isi Asset ID dan Nama Part!",3) return end
        local part=Workspace:FindFirstChild(pname,true)
        if not part then Notify("Error","Part tidak ditemukan: "..pname,3) return end
        local nid=ImgLoader.Normalize(id)
        if nid then
            local d=Instance.new("Decal")
            d.Texture=nid d.Face=Enum.NormalId[getFace()] or Enum.NormalId.Front
            d.Parent=part
            Notify("Decal","Decal diterapkan ke "..pname,3)
        end
    end)

    Btn(ImgPage,"Hapus Cache Image","🗑",C.Red,function()
        ImgLoader.cache={} ImgLoader.failed={}
        prevImg.Image=""
        imgStat.Text="Cache dihapus" imgStat.TextColor3=C.TextDim
        cacheInfo.Text="Cache: 0"
        Notify("Cache","Image cache dihapus!",2)
    end)

    -- =========================================================
    -- PAGE: BLOCKS
    -- =========================================================
    local BlocksPage2 = MakePage("Blocks")

    Section(BlocksPage2,"Database Block BABFT (159)","📦")

    local searchTB,_=Input(BlocksPage2,"Cari nama block...","")

    local catList={"Semua"}
    local catMap={}
    for _,b in ipairs(BlockDatabase) do
        if not catMap[b.category] then catMap[b.category]=true table.insert(catList,b.category) end
    end
    local _,getCatF=Dropdown(BlocksPage2,"Kategori:",catList,"Semua",function(v) end)

    local blkListF=Create("Frame",{Size=UDim2.new(1,0,0,260),BackgroundColor3=C.Bg3,BorderSizePixel=0,Parent=BlocksPage2})
    Create("UICorner",{CornerRadius=UDim.new(0,10),Parent=blkListF})

    local blkScroll=Create("ScrollingFrame",{Size=UDim2.new(1,-2,1,-2),Position=UDim2.new(0,1,0,1),
        BackgroundTransparency=1,ScrollBarThickness=4,ScrollBarImageColor3=C.Purple,
        CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=blkListF})
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=blkScroll})
    Create("UIPadding",{PaddingAll=UDim.new(0,4),Parent=blkScroll})

    local selLbl=Create("TextLabel",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.Bg3,
        BorderSizePixel=0,Text="Pilih block untuk place | Ketuk untuk place 1 block",
        TextColor3=C.TextDim,Font=Enum.Font.Gotham,TextSize=10,Parent=BlocksPage2})
    Create("UICorner",{CornerRadius=UDim.new(0,6),Parent=selLbl})

    local function RefreshBlocks(filter, cat)
        for _,c in ipairs(blkScroll:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        local count=0
        for _,bl in ipairs(BlockDatabase) do
            local nm=(filter=="" or bl.name:lower():find(filter:lower()))
            local cm=(cat=="Semua" or bl.category==cat)
            if nm and cm then
                count=count+1
                local row=Create("TextButton",{Size=UDim2.new(1,-2,0,26),
                    BackgroundColor3=Color3.fromRGB(14,8,36),BorderSizePixel=0,
                    Text="",AutoButtonColor=false,Parent=blkScroll})
                Create("UICorner",{CornerRadius=UDim.new(0,5),Parent=row})
                local idB=Create("TextLabel",{Size=UDim2.new(0,32,0,18),Position=UDim2.new(0,2,0.5,-9),
                    BackgroundColor3=C.DkPurple,BorderSizePixel=0,Text="#"..bl.id,
                    TextColor3=C.LtPurple,Font=Enum.Font.GothamBold,TextSize=8,Parent=row})
                Create("UICorner",{CornerRadius=UDim.new(0,4),Parent=idB})
                Create("TextLabel",{Size=UDim2.new(0.5,-38,1,0),Position=UDim2.new(0,38,0,0),
                    BackgroundTransparency=1,Text=bl.name,TextColor3=C.TextMain,Font=Enum.Font.Gotham,
                    TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
                local catB=Create("TextLabel",{Size=UDim2.new(0.28,0,0,14),Position=UDim2.new(0.52,0,0.5,-7),
                    BackgroundColor3=C.Bg,BorderSizePixel=0,Text=bl.category,TextColor3=C.TextSub,
                    Font=Enum.Font.Gotham,TextSize=8,Parent=row})
                Create("UICorner",{CornerRadius=UDim.new(0,3),Parent=catB})
                local typeB=Create("TextLabel",{Size=UDim2.new(0.15,0,0,14),Position=UDim2.new(0.83,0,0.5,-7),
                    BackgroundColor3=C.Bg3,BorderSizePixel=0,Text=bl.type,TextColor3=C.LtPurple,
                    Font=Enum.Font.GothamBold,TextSize=7,Parent=row})
                Create("UICorner",{CornerRadius=UDim.new(0,3),Parent=typeB})
                row.MouseEnter:Connect(function() pcall(function() Tween(row,{BackgroundColor3=Color3.fromRGB(22,12,54)},0.1) end) end)
                row.MouseLeave:Connect(function() pcall(function() Tween(row,{BackgroundColor3=Color3.fromRGB(14,8,36)},0.1) end) end)
                row.MouseButton1Click:Connect(function()
                    selLbl.Text="✅ Selected: "..bl.name.." (ID: "..bl.id..") | "..bl.category
                    selLbl.TextColor3=C.LtPurple
                    local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local pos=hrp and hrp.Position+Vector3.new(0,5,-8) or Vector3.new(0,5,0)
                    Placer:Place(bl,pos)
                    Notify("Block","Place: "..bl.name,2)
                end)
            end
        end
        if count==0 then
            Create("TextLabel",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,
                Text="Tidak ada block ditemukan untuk '"..filter.."'",
                TextColor3=C.TextDim,Font=Enum.Font.Gotham,TextSize=11,Parent=blkScroll})
        end
    end

    RefreshBlocks("","Semua")

    searchTB.Changed:Connect(function(prop)
        if prop=="Text" then pcall(function() RefreshBlocks(searchTB.Text,getCatF()) end) end
    end)

    Btn(BlocksPage2,"🔄  Refresh List","",C.Cyan,function()
        RefreshBlocks(searchTB.Text,getCatF())
        Notify("Refresh","List diperbarui!",2)
    end)

    -- =========================================================
    -- PAGE: INFO / SETTINGS
    -- =========================================================
    local InfoPage = MakePage("Info")

    Section(InfoPage,"Tentang OxyX","ℹ")

    local abtF=Create("Frame",{Size=UDim2.new(1,0,0,110),BackgroundColor3=C.Bg3,BorderSizePixel=0,Parent=InfoPage})
    Create("UICorner",{CornerRadius=UDim.new(0,10),Parent=abtF})
    Create("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(26,12,65)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(10,6,32)),
    }),Rotation=135,Parent=abtF})

    local aImg2=Create("ImageLabel",{Size=UDim2.new(0,76,0,76),Position=UDim2.new(0,10,0,17),
        BackgroundColor3=C.DkPurple,BorderSizePixel=0,Image="rbxassetid://7078026274",
        ScaleType=Enum.ScaleType.Fit,Parent=abtF})
    Create("UICorner",{CornerRadius=UDim.new(0,10),Parent=aImg2})
    Create("UIStroke",{Color=C.Pink,Thickness=2,Parent=aImg2})

    local infoLines={
        {"OxyX BABFT Tool", Enum.Font.GothamBold, 14, C.White},
        {"Version 2.1.0 | Galaxy Edition", Enum.Font.GothamBold, 10, C.LtPurple},
        {"159 Blocks | Auto Build | Shapes", Enum.Font.Gotham, 10, C.TextSub},
        {"Convert | Image Loader | Galaxy UI", Enum.Font.Gotham, 10, C.TextSub},
        {"Executor: "..ExecutorName, Enum.Font.Gotham, 10, C.Cyan},
    }
    for i,ln in ipairs(infoLines) do
        Create("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.new(0,100,0,4+(i-1)*18),
            BackgroundTransparency=1,Text=ln[1],TextColor3=ln[4],Font=ln[2],TextSize=ln[3],
            TextXAlignment=Enum.TextXAlignment.Left,Parent=abtF})
    end

    Section(InfoPage,"Hotkeys","⌨")

    local hkF=Create("Frame",{Size=UDim2.new(1,0,0,100),BackgroundColor3=C.Bg3,BorderSizePixel=0,Parent=InfoPage})
    Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=hkF})
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=hkF})
    Create("UIPadding",{PaddingAll=UDim.new(0,7),Parent=hkF})

    local hklist={
        {"Right Shift","Toggle UI (tampilkan/sembunyikan)"},
        {"Ctrl + B","Quick Build (build data sekarang)"},
        {"Ctrl + E","Export kapal ke clipboard"},
    }
    for _,hk in ipairs(hklist) do
        local hrow=Create("Frame",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,Parent=hkF})
        local kb=Create("TextLabel",{Size=UDim2.new(0,95,0,18),Position=UDim2.new(0,0,0.5,-9),
            BackgroundColor3=C.DkPurple,BorderSizePixel=0,Text=hk[1],TextColor3=C.LtPurple,
            Font=Enum.Font.Code,TextSize=9,Parent=hrow})
        Create("UICorner",{CornerRadius=UDim.new(0,4),Parent=kb})
        Create("TextLabel",{Size=UDim2.new(1,-103,1,0),Position=UDim2.new(0,100,0,0),
            BackgroundTransparency=1,Text=hk[2],TextColor3=C.TextSub,Font=Enum.Font.Gotham,
            TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=hrow})
    end

    Section(InfoPage,"Pengaturan UI","⚙")
    Toggle(InfoPage,"Tampilkan Notifikasi",true,function(v) end)
    Slider(InfoPage,"Transparansi UI",0,80,5,function(v) pcall(function() InnerBg.BackgroundTransparency=v/100 end) end)

    Btn(InfoPage,"Copy GitHub URL","📋",C.Cyan,function()
        if setclipboard then
            setclipboard("https://raw.githubusercontent.com/johsua092-ui/oxyX-sc/refs/heads/main/OxyX_BABFT.lua")
            Notify("GitHub","URL di-copy ke clipboard!",3)
        end
    end)

    Btn(InfoPage,"Reload Script","🔄",C.Purple,function()
        Notify("Reload","Memuat ulang OxyX...",2)
        task.delay(0.5,function()
            pcall(function() SG:Destroy() end)
            pcall(function() bc:Disconnect() end)
            BuildUI()
        end)
    end)

    -- =========================================================
    -- DRAG WINDOW
    -- =========================================================
    local drag2=false
    local doff=Vector2.new(0,0)

    Hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            drag2=true
            doff=Vector2.new(Mouse.X-MF.AbsolutePosition.X, Mouse.Y-MF.AbsolutePosition.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag2=false end
    end)
    RunService.Heartbeat:Connect(function()
        if drag2 and MF and MF.Parent then
            pcall(function()
                local vp=Camera.ViewportSize
                local nx=math.clamp(Mouse.X-doff.X,0,vp.X-MF.AbsoluteSize.X)
                local ny=math.clamp(Mouse.Y-doff.Y,0,vp.Y-MF.AbsoluteSize.Y)
                MF.Position=UDim2.new(0,nx,0,ny)
            end)
        end
    end)

    -- =========================================================
    -- MINIMIZE / CLOSE
    -- =========================================================
    MinB.MouseButton1Click:Connect(function()
        State.minimized=not State.minimized
        if State.minimized then
            Tween(MF,{Size=UDim2.new(0,400,0,72)},0.3)
            MinB.Text="□"
        else
            Tween(MF,{Size=UDim2.new(0,400,0,580)},0.3)
            MinB.Text="−"
        end
    end)

    CloseB.MouseButton1Click:Connect(function()
        Tween(MF,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.25)
        task.delay(0.26,function()
            pcall(function() bc:Disconnect() end)
            pcall(function() SG:Destroy() end)
        end)
    end)

    -- =========================================================
    -- HOTKEYS
    -- =========================================================
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        pcall(function()
            if inp.KeyCode==Enum.KeyCode.RightShift then
                MF.Visible=not MF.Visible
            end
            if inp.KeyCode==Enum.KeyCode.B and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                if State.buildData then Placer:AutoSetup(State.buildData)
                else Notify("Error","Tidak ada build!",3) end
            end
            if inp.KeyCode==Enum.KeyCode.E and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                task.spawn(function()
                    local j=BuildSystem.FromBoat()
                    if j and setclipboard then setclipboard(j) Notify("Export","Kapal di-copy!",3) end
                end)
            end
        end)
    end)

    -- =========================================================
    -- START ON BUILD TAB
    -- =========================================================
    SwitchTab("Build")

    Notify("OxyX v2.1.0","UI Galaxy berhasil dimuat! 🌌 159 blocks ready",4)
    print("[OxyX] ✅ UI loaded successfully | Tab: Build | Executor: "..ExecutorName)

    return SG
end

-- =========================================================
-- JALANKAN UI
-- =========================================================
local ok2, err2 = pcall(BuildUI)
if not ok2 then
    warn("[OxyX] ❌ UI Error: " .. tostring(err2))
    -- Fallback minimal notice
    pcall(function()
        local fg=Instance.new("ScreenGui")
        fg.DisplayOrder=9999 fg.IgnoreGuiInset=true
        fg.Parent=GuiParent
        local ff=Instance.new("Frame")
        ff.Size=UDim2.new(0,320,0,55) ff.Position=UDim2.new(0.5,-160,0,20)
        ff.BackgroundColor3=Color3.fromRGB(20,0,0) ff.BorderSizePixel=0 ff.Parent=fg
        local fl=Instance.new("TextLabel")
        fl.Size=UDim2.new(1,-10,1,0) fl.Position=UDim2.new(0,5,0,0)
        fl.BackgroundTransparency=1 fl.Text="[OxyX] Error: "..tostring(err2)
        fl.TextColor3=Color3.fromRGB(255,100,100) fl.Font=Enum.Font.Gotham
        fl.TextSize=11 fl.TextWrapped=true fl.Parent=ff
        game:GetService("Debris"):AddItem(fg,8)
    end)
end

print([[
╔══════════════════════════════════════╗
║   OxyX BABFT v2.1.0 - FIXED  🌌     ║
║   Galaxy Edition | Astolfo UI       ║
║   159 Blocks | Auto Build Ready     ║
║   Right Shift = Toggle UI           ║
╚══════════════════════════════════════╝]])
