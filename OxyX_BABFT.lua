--[[
  OxyX BABFT Tool v5.0 — GALAXY EDITION
  Fix: Tab layout, inventory build, Astolfo animated
]]

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Http         = game:GetService("HttpService")
local WS           = game:GetService("Workspace")
local RS           = game:GetService("ReplicatedStorage")

local GP
pcall(function() GP = game:GetService("CoreGui") end)
if not GP then GP = Players.LocalPlayer:WaitForChild("PlayerGui") end

local LP   = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")
local Mouse= LP:GetMouse()
local Cam  = WS.CurrentCamera

local EXE = "Unknown"
pcall(function()
    if identifyexecutor  then EXE = identifyexecutor()
    elseif syn           then EXE = "Synapse X"
    elseif KRNL_LOADED   then EXE = "KRNL"
    elseif getexecutorname then EXE = getexecutorname()
    elseif isfolder      then EXE = "Executor" end
end)

-- ═══ COLOURS ═══════════════════════════════════
local C={
    BG0=Color3.fromRGB(5,3,18),   BG1=Color3.fromRGB(10,6,30),
    BG2=Color3.fromRGB(17,10,48), BG3=Color3.fromRGB(28,17,68),
    PRP=Color3.fromRGB(140,44,230),  DPRP=Color3.fromRGB(70,0,130),
    LPRP=Color3.fromRGB(190,110,255),CYN=Color3.fromRGB(0,205,255),
    PNK=Color3.fromRGB(255,95,180),  GLD=Color3.fromRGB(255,200,55),
    GRN=Color3.fromRGB(70,225,115),  RED=Color3.fromRGB(255,65,65),
    YLW=Color3.fromRGB(255,210,50),  WHT=Color3.fromRGB(255,255,255),
    TXT0=Color3.fromRGB(238,228,255),TXT1=Color3.fromRGB(165,148,215),
    TXT2=Color3.fromRGB(90,72,138),
}

-- ═══ HELPERS ════════════════════════════════════
local function New(cls,props)
    local ok,i=pcall(Instance.new,cls)
    if not ok then return nil end
    for k,v in pairs(props) do
        if k~="Parent" then pcall(function() i[k]=v end) end
    end
    if props.Parent then pcall(function() i.Parent=props.Parent end) end
    return i
end
local function Tw(o,g,t,es)
    if not o or not o.Parent then return end
    pcall(function()
        TweenService:Create(o,TweenInfo.new(t or .25,es or Enum.EasingStyle.Quad,Enum.EasingDirection.Out),g):Play()
    end)
end
local function Notify(title,msg,dur)
    dur=dur or 3
    task.spawn(function() pcall(function()
        local ng=New("ScreenGui",{Name="OxN"..tick(),ResetOnSpawn=false,DisplayOrder=99999,IgnoreGuiInset=true,Parent=GP})
        local nf=New("Frame",{Size=UDim2.new(0,288,0,66),Position=UDim2.new(1,10,1,-86),BackgroundColor3=C.BG1,BorderSizePixel=0,Parent=ng})
        New("UICorner",{CornerRadius=UDim.new(0,12),Parent=nf})
        New("UIStroke",{Color=C.PRP,Thickness=1.5,Parent=nf})
        local lb=New("Frame",{Size=UDim2.new(0,4,0.76,0),Position=UDim2.new(0,0,0.12,0),BackgroundColor3=C.LPRP,BorderSizePixel=0,Parent=nf})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=lb})
        New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.CYN),ColorSequenceKeypoint.new(1,C.PRP)}),Rotation=90,Parent=lb})
        New("TextLabel",{Size=UDim2.new(1,-14,0,20),Position=UDim2.new(0,10,0,4),BackgroundTransparency=1,Text="✦ "..title,TextColor3=C.LPRP,Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=nf})
        New("TextLabel",{Size=UDim2.new(1,-14,0,30),Position=UDim2.new(0,10,0,24),BackgroundTransparency=1,Text=msg,TextColor3=C.TXT1,Font=Enum.Font.Gotham,TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=nf})
        local pg=New("Frame",{Size=UDim2.new(1,-6,0,3),Position=UDim2.new(0,3,1,-3),BackgroundColor3=C.PRP,BorderSizePixel=0,Parent=nf})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=pg})
        New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.PRP),ColorSequenceKeypoint.new(1,C.CYN)}),Parent=pg})
        Tw(nf,{Position=UDim2.new(1,-298,1,-86)},.3)
        Tw(pg,{Size=UDim2.new(0,0,0,3)},dur)
        task.delay(dur,function() pcall(function() Tw(nf,{Position=UDim2.new(1,10,1,-86)},.25) task.wait(.28) ng:Destroy() end) end)
    end) end)
end

-- ═══ BLOCK DB ═══════════════════════════════════
local DB={
    {id=1,n="Back Wheel",cat="Wheels"},{id=2,n="Balloon Block",cat="Special"},
    {id=3,n="Bar",cat="Structure"},{id=4,n="Big Cannon",cat="Weapons"},
    {id=5,n="Big Switch",cat="Electronics"},{id=6,n="Blue Candy",cat="Candy"},
    {id=7,n="Boat Motor",cat="Propulsion"},{id=8,n="Bouncy Block",cat="Special"},
    {id=9,n="Boxing Glove",cat="Weapons"},{id=10,n="Bread",cat="Food"},
    {id=11,n="Brick Block",cat="Structure"},{id=12,n="Bundles of Potions",cat="Special"},
    {id=13,n="Button",cat="Electronics"},{id=14,n="Cake",cat="Food"},
    {id=15,n="Camera",cat="Special"},{id=16,n="Candle",cat="Decoration"},
    {id=17,n="Candy Cane Block",cat="Candy"},{id=18,n="Candy Cane Rod",cat="Candy"},
    {id=19,n="Cannon",cat="Weapons"},{id=20,n="Car Seat",cat="Seats"},
    {id=21,n="Chair",cat="Seats"},{id=22,n="Classic Firework",cat="Fireworks"},
    {id=23,n="Coal Block",cat="Structure"},{id=24,n="Common Chest Block",cat="Chests"},
    {id=25,n="Concrete Block",cat="Structure"},{id=26,n="Concrete Rod",cat="Structure"},
    {id=27,n="Cookie Back Wheel",cat="Wheels"},{id=28,n="Cookie Front Wheel",cat="Wheels"},
    {id=29,n="Corner Wedge",cat="Structure"},{id=30,n="Delay Block",cat="Electronics"},
    {id=31,n="Dome Camera",cat="Special"},{id=32,n="Door",cat="Structure"},
    {id=33,n="Dragon Egg",cat="Special"},{id=34,n="Dragon Harpoon",cat="Weapons"},
    {id=35,n="Dual Candy Cane Harpoon",cat="Weapons"},{id=36,n="Dynamite",cat="Weapons"},
    {id=37,n="Easter Jetpack",cat="Propulsion"},{id=38,n="Egg Cannon",cat="Weapons"},
    {id=39,n="Epic Chest Block",cat="Chests"},{id=40,n="Fabric Block",cat="Structure"},
    {id=41,n="Firework 1",cat="Fireworks"},{id=42,n="Firework 2",cat="Fireworks"},
    {id=43,n="Firework 3",cat="Fireworks"},{id=44,n="Firework 4",cat="Fireworks"},
    {id=45,n="Flag",cat="Decoration"},{id=46,n="Front Wheel",cat="Wheels"},
    {id=47,n="Gameboard",cat="Special"},{id=48,n="Glass Block",cat="Structure"},
    {id=49,n="Glue",cat="Electronics"},{id=50,n="Gold Block",cat="Structure"},
    {id=51,n="Golden Harpoon",cat="Weapons"},{id=52,n="Grass Block",cat="Structure"},
    {id=53,n="Harpoon",cat="Weapons"},{id=54,n="Hatch",cat="Structure"},
    {id=55,n="Heart",cat="Decoration"},{id=56,n="Helm",cat="Special"},
    {id=57,n="Hinge",cat="Electronics"},{id=58,n="Huge Back Wheel",cat="Wheels"},
    {id=59,n="Huge Front Wheel",cat="Wheels"},{id=60,n="Huge Wheel",cat="Wheels"},
    {id=61,n="I-Beam",cat="Structure"},{id=62,n="Ice Block",cat="Structure"},
    {id=63,n="Jet Turbine",cat="Propulsion"},{id=64,n="Jetpack",cat="Propulsion"},
    {id=65,n="Lamp",cat="Decoration"},{id=66,n="Large Treasure",cat="Treasure"},
    {id=67,n="Laser Launcher",cat="Weapons"},{id=68,n="Legendary Chest Block",cat="Chests"},
    {id=69,n="Lever",cat="Electronics"},{id=70,n="Life Preserver",cat="Special"},
    {id=71,n="Light Bulb",cat="Decoration"},{id=72,n="Locked Door",cat="Structure"},
    {id=73,n="Magnet",cat="Special"},{id=74,n="Marble Block",cat="Structure"},
    {id=75,n="Marble Rod",cat="Structure"},{id=76,n="Mast",cat="Structure"},
    {id=77,n="Master Builder Trophy",cat="Trophies"},{id=78,n="Medium Treasure",cat="Treasure"},
    {id=79,n="Mega Thruster",cat="Propulsion"},{id=80,n="Metal Block",cat="Structure"},
    {id=81,n="Metal Rod",cat="Structure"},{id=82,n="Mini Gun",cat="Weapons"},
    {id=83,n="Mounted Bow",cat="Weapons"},{id=84,n="Mounted Candy Cane Sword",cat="Weapons"},
    {id=85,n="Mounted Cannon",cat="Weapons"},{id=86,n="Mounted Flintlocks",cat="Weapons"},
    {id=87,n="Mounted Knight Sword",cat="Weapons"},{id=88,n="Mounted Sword",cat="Weapons"},
    {id=89,n="Mounted Wizard Staff",cat="Weapons"},{id=90,n="Music Note",cat="Decoration"},
    {id=91,n="Mystery Box",cat="Special"},{id=92,n="Neon Block",cat="Structure"},
    {id=93,n="Obsidian Block",cat="Structure"},{id=94,n="Orange Candy",cat="Candy"},
    {id=95,n="Parachute Block",cat="Special"},{id=96,n="Peppermint Back Wheel",cat="Wheels"},
    {id=97,n="Peppermint Front Wheel",cat="Wheels"},{id=98,n="Pilot Seat",cat="Seats"},
    {id=99,n="Pine Tree",cat="Decoration"},{id=100,n="Pink Candy",cat="Candy"},
    {id=101,n="Piston",cat="Electronics"},{id=102,n="Plastic Block",cat="Structure"},
    {id=103,n="Plushie 1",cat="Decoration"},{id=104,n="Plushie 2",cat="Decoration"},
    {id=105,n="Plushie 3",cat="Decoration"},{id=106,n="Plushie 4",cat="Decoration"},
    {id=107,n="Portal",cat="Special"},{id=108,n="Pumpkin",cat="Decoration"},
    {id=109,n="Purple Candy",cat="Candy"},{id=110,n="Rare Chest Block",cat="Chests"},
    {id=111,n="Red Candy",cat="Candy"},{id=112,n="Rope",cat="Structure"},
    {id=113,n="Rusted Block",cat="Structure"},{id=114,n="Rusted Rod",cat="Structure"},
    {id=115,n="Sand Block",cat="Structure"},{id=116,n="Seat",cat="Seats"},
    {id=117,n="Servo",cat="Electronics"},{id=118,n="Shield Generator",cat="Special"},
    {id=119,n="Sign",cat="Decoration"},{id=120,n="Small Treasure",cat="Treasure"},
    {id=121,n="Smooth Wood Block",cat="Structure"},{id=122,n="Snowball Launcher",cat="Weapons"},
    {id=123,n="Soccer Ball",cat="Special"},{id=124,n="Sonic Jet Turbine",cat="Propulsion"},
    {id=125,n="Spike Trap",cat="Weapons"},{id=126,n="Spooky Thruster",cat="Propulsion"},
    {id=127,n="Star",cat="Decoration"},{id=128,n="Star Balloon Block",cat="Special"},
    {id=129,n="Star Jetpack",cat="Propulsion"},{id=130,n="Steampunk Jetpack",cat="Propulsion"},
    {id=131,n="Step",cat="Structure"},{id=132,n="Stone Block",cat="Structure"},
    {id=133,n="Stone Rod",cat="Structure"},{id=134,n="Suspension",cat="Electronics"},
    {id=135,n="Switch",cat="Electronics"},{id=136,n="Throne",cat="Seats"},
    {id=137,n="Thruster",cat="Propulsion"},{id=138,n="Titanium Block",cat="Structure"},
    {id=139,n="Titanium Rod",cat="Structure"},{id=140,n="TNT",cat="Weapons"},
    {id=141,n="Torch",cat="Decoration"},{id=142,n="Toy Block",cat="Structure"},
    {id=143,n="Treasure Chest",cat="Treasure"},{id=144,n="Trophy 1st",cat="Trophies"},
    {id=145,n="Trophy 2nd",cat="Trophies"},{id=146,n="Trophy 3rd",cat="Trophies"},
    {id=147,n="Truss",cat="Structure"},{id=148,n="Ultra Boat Motor",cat="Propulsion"},
    {id=149,n="Ultra Jetpack",cat="Propulsion"},{id=150,n="Ultra Thruster",cat="Propulsion"},
    {id=151,n="Uncommon Chest Block",cat="Chests"},{id=152,n="Wedge",cat="Structure"},
    {id=153,n="Wheel",cat="Wheels"},{id=154,n="Window",cat="Structure"},
    {id=155,n="Winter Boat Motor",cat="Propulsion"},{id=156,n="Winter Jet Turbine",cat="Propulsion"},
    {id=157,n="Winter Thruster",cat="Propulsion"},{id=158,n="Wood Block",cat="Structure"},
    {id=159,n="Wood Rod",cat="Structure"},
}
local DBlo={}
for _,b in ipairs(DB) do DBlo[b.n:lower()]=b end
local function FindBlock(name)
    if not name then return DB[158] end
    local lo=name:lower()
    if DBlo[lo] then return DBlo[lo] end
    for k,v in pairs(DBlo) do
        if k:find(lo,1,true) or lo:find(k,1,true) then return v end
    end
    return DB[158]
end

-- ═══ INVENTORY ══════════════════════════════════
-- Inventory BABFT: block yang player punya disimpan sebagai:
-- 1. Tombol di ScreenGui "BlocksGui" / "InventoryGui" (ImageButton dengan Name = block name)
-- 2. Kadang IntValue di LP.Data.Blocks atau LP.PlayerData
-- Cara place: BABFT pakai RemoteEvent "PlaceBlock" dengan parameter {Name=blockName}
-- ATAU klik langsung tombol block-nya

local INV={}  -- { [blockName] = { block=DB, btn=GuiObj, count=N } }

local function ScanInventory()
    INV={}

    -- METHOD 1: Cari RemoteFunction GetInventory / GetBlocks dari BABFT server
    for _,v in ipairs(RS:GetDescendants()) do
        if v:IsA("RemoteFunction") then
            local lo=v.Name:lower()
            if lo:find("getinv") or lo:find("getblock") or lo:find("owned") or lo:find("inventory") then
                pcall(function()
                    local result=v:InvokeServer()
                    if type(result)=="table" then
                        for k,val in pairs(result) do
                            local name=type(k)=="string" and k or (type(val)=="string" and val) or nil
                            if name then
                                local bd=FindBlock(name)
                                if bd then INV[bd.n]={block=bd,count=type(val)=="number" and val or 99} end
                            end
                        end
                    end
                end)
            end
        end
    end

    -- METHOD 2: Scan semua ScreenGui BABFT untuk ImageButton/TextButton per block
    -- BABFT inventory = tombol dengan Name persis sama dengan nama block
    for _,gui in ipairs(PGui:GetChildren()) do
        if gui:IsA("ScreenGui") and not gui.Name:match("OxyX") then
            for _,obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("ImageButton") or obj:IsA("TextButton") then
                    local exact=DBlo[obj.Name:lower()]
                    if exact and not INV[exact.n] then
                        local vis=true
                        pcall(function() vis=obj.Visible and obj.Active~=false end)
                        if vis then INV[exact.n]={block=exact,btn=obj} end
                    end
                end
            end
        end
    end

    -- METHOD 3: IntValue/NumberValue di LP children
    for _,child in ipairs(LP:GetChildren()) do
        pcall(function()
            for _,v in ipairs(child:GetDescendants()) do
                local exact=DBlo[v.Name:lower()]
                if exact and not INV[exact.n] then
                    if (v:IsA("IntValue") or v:IsA("NumberValue")) and v.Value>0 then
                        INV[exact.n]={block=exact,count=v.Value}
                    end
                end
            end
        end)
    end

    -- FALLBACK jika tidak ada yang ketemu
    if not next(INV) then
        local defaults={"Wood Block","Metal Block","Stone Block","Glass Block","Plastic Block",
            "Brick Block","Concrete Block","Smooth Wood Block","Fabric Block",
            "Thruster","Boat Motor","Wheel","Front Wheel","Back Wheel","Helm",
            "Cannon","Button","Switch","Seat","Pilot Seat"}
        for _,n in ipairs(defaults) do
            local b=FindBlock(n); if b then INV[b.n]={block=b,count=99} end
        end
    end

    local cnt=0; for _ in pairs(INV) do cnt=cnt+1 end
    return cnt
end

-- ─── CARA PLACE BLOCK DI BABFT ───────────────────────────
-- BABFT build system: player pilih block dari inventory GUI → server place block
-- Kita simulasi dengan:
-- 1. Klik tombol block di inventory GUI (paling mirip user asli)
-- 2. Fallback: FireServer ke RemoteEvent PlaceBlock
local _placeRemote=nil
local function GetPlaceRemote()
    if _placeRemote and _placeRemote.Parent then return _placeRemote end
    -- BABFT pakai nama spesifik untuk remote place block
    for _,r in ipairs(RS:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local lo=r.Name:lower()
            -- cari yang paling spesifik dulu
            if lo=="placeblock" or lo=="addblock" or lo=="spawnblock" then
                _placeRemote=r; return r
            end
        end
    end
    -- Kalau tidak ketemu nama spesifik, cari yang mengandung kata kunci
    for _,r in ipairs(RS:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local lo=r.Name:lower()
            if (lo:find("place") or lo:find("build") or lo:find("block")) and not lo:find("break") then
                _placeRemote=r; return r
            end
        end
    end
    return nil
end

local function ClickBABFTBlock(blockName)
    -- Cara 1: Klik tombol di inventory GUI BABFT (paling reliable)
    local entry=INV[blockName]
    if entry and entry.btn then
        local btn=entry.btn
        -- Coba berbagai cara fire klik
        local clicked=false
        pcall(function()
            if btn and btn.Parent then
                btn.MouseButton1Click:Fire()
                clicked=true
            end
        end)
        if clicked then return true end
    end

    -- Cara 2: Scan ulang GUI, cari tombol dengan nama persis
    for _,gui in ipairs(PGui:GetChildren()) do
        if gui:IsA("ScreenGui") and not gui.Name:match("OxyX") then
            for _,obj in ipairs(gui:GetDescendants()) do
                if (obj:IsA("ImageButton") or obj:IsA("TextButton")) then
                    if DBlo[obj.Name:lower()] and DBlo[obj.Name:lower()].n==blockName then
                        pcall(function() obj.MouseButton1Click:Fire() end)
                        return true
                    end
                end
            end
        end
    end

    -- Cara 3: FireServer ke RemoteEvent PlaceBlock
    local rem=GetPlaceRemote()
    if rem then
        local bd=FindBlock(blockName)
        -- BABFT biasanya nerima: {Name, BlockName, Id, BlockId} atau string nama saja
        local fired=false
        pcall(function()
            rem:FireServer(bd.n)  -- coba kirim nama saja dulu
            fired=true
        end)
        if not fired then
            pcall(function()
                rem:FireServer({Name=bd.n, BlockName=bd.n, Id=bd.id, BlockId=bd.id})
                fired=true
            end)
        end
        if fired then return true end
    end

    return false
end

-- ═══ PLACER ═════════════════════════════════════
local Placer={delay=0.15,running=false,placed=0,failed=0}

function Placer:PlaceOne(blockDef)
    local name=blockDef.n
    -- Kalau tidak punya block ini, cari pengganti dari inventory
    if not INV[name] then
        -- Cari sekategori
        for k,_ in pairs(INV) do
            if FindBlock(k).cat==blockDef.cat then name=k; break end
        end
        -- Masih tidak ada → pakai block pertama yg ada
        if not INV[name] then
            for k,_ in pairs(INV) do name=k; break end
        end
    end
    local ok=ClickBABFTBlock(name)
    if ok then self.placed=self.placed+1 else self.failed=self.failed+1 end
    return ok,name
end

function Placer:Build(data,cb)
    if self.running then Notify("Build","Sudah berjalan!",2); return end
    if not data or not data.blocks then return end
    self.running=true; self.placed=0; self.failed=0
    local total=#data.blocks
    task.spawn(function()
        Notify("Build","Memulai "..total.." blocks 🚀",2)
        for i,bi in ipairs(data.blocks) do
            if not self.running then break end
            local bd=FindBlock(bi.name or bi.n or "")
            local ok2,used=self:PlaceOne(bd)
            if cb then pcall(cb,i,total,used,ok2) end
            task.wait(self.delay)
        end
        self.running=false
        if cb then pcall(cb,total,total,"DONE",true) end
    end)
end

function Placer:Stop()
    self.running=false
    Notify("Stop","Build dihentikan",2)
end

-- ═══ FILE SYSTEM ════════════════════════════════
local function MkDir(f) if makefolder then pcall(function() if not isfolder(f) then makefolder(f) end end) end end
local function LsExt(folder,ext)
    local res={}
    if not listfiles then return res end
    for _,path in ipairs({folder,folder.."/",""}) do
        pcall(function()
            for _,p in ipairs(listfiles(path)) do
                local fn=p:match("([^/\\]+)$") or p
                if fn:lower():sub(-#ext)==ext:lower() then res[#res+1]={name=fn,path=p} end
            end
        end)
    end
    local seen,out={},{}
    for _,f in ipairs(res) do if not seen[f.name] then seen[f.name]=true; out[#out+1]=f end end
    return out
end
local function RdF(path)
    if readfile then local ok,t=pcall(readfile,path); if ok and t then return t end end
end
local function WrF(path,content)
    if writefile then pcall(writefile,path,content); return true end
    return false
end
local function ParseBuild(txt)
    if txt=="" then return nil,"Kosong" end
    local ok,d=pcall(function() return Http:JSONDecode(txt) end)
    if not ok or type(d)~="table" then return nil,"Bukan JSON valid" end
    if not d.blocks or #d.blocks==0 then return nil,"Tidak ada blocks" end
    return d
end
local function ParseJSON(txt)
    if txt=="" then return nil,"Kosong" end
    local ok,raw=pcall(function() return Http:JSONDecode(txt) end)
    if not ok or type(raw)~="table" then return nil,"Bukan JSON valid" end
    if raw.blocks and #raw.blocks>0 then return raw end
    local blocks={}
    local function scan(o,d)
        if type(o)~="table" or d>10 then return end
        local cls=o.ClassName or ""
        if cls=="Part" or cls=="MeshPart" or cls=="WedgePart" or cls=="UnionOperation" then
            local bd=FindBlock(o.Name or "")
            blocks[#blocks+1]={id=bd.id,name=bd.n,
                position={x=(o.CFrame and o.CFrame[1]) or 0,y=(o.CFrame and o.CFrame[2]) or 5,z=(o.CFrame and o.CFrame[3]) or 0},
                size={x=(o.Size and o.Size[1]) or 4,y=(o.Size and o.Size[2]) or 1.2,z=(o.Size and o.Size[3]) or 2},
                color={r=(o.Color and math.floor(o.Color[1]*255)) or 163,g=(o.Color and math.floor(o.Color[2]*255)) or 102,b=(o.Color and math.floor(o.Color[3]*255)) or 51}}
        end
        if o.Children then for _,c in ipairs(o.Children) do scan(c,d+1) end end
        for k,v in pairs(o) do if type(v)=="table" and k~="Children" then scan(v,d+1) end end
    end
    scan(raw,0)
    if #blocks==0 then blocks={{id=158,name="Wood Block",position={x=0,y=5,z=0},size={x=4,y=1.2,z=2},color={r=163,g=102,b=51}}} end
    return {version="1.0",name="JSON_Import",author=LP.Name,blocks=blocks,welds={}}
end
local function Ser(name,blocks)
    local d={version="1.0",name=name or "MyBuild",author=LP.Name,blocks=blocks or {},welds={}}
    local ok,j=pcall(function() return Http:JSONEncode(d) end)
    return ok and j
end

-- Shape builder
local SB={}
function SB.Ball(n,r)       local b={} for x=-r,r do for y=-r,r do for z=-r,r do if x*x+y*y+z*z<=r*r then b[#b+1]={name=n,position={x=x*2,y=y*2,z=z*2}} end end end end return b end
function SB.Cylinder(n,r,h) local b={} for y=0,h-1 do for x=-r,r do for z=-r,r do if x*x+z*z<=r*r then b[#b+1]={name=n,position={x=x*2,y=y*2,z=z*2}} end end end end return b end
function SB.Triangle(n,ba,h) local b={} for y=0,h-1 do local lw=math.max(1,math.floor(ba*(1-y/h))) for x=0,lw-1 do b[#b+1]={name=n,position={x=(x+(ba-lw)/2)*2,y=y*2,z=0}} end end return b end
function SB.Pyramid(n,ba)   local b={} for y=0,ba-1 do for x=0,ba-1-y do for z=0,ba-1-y do b[#b+1]={name=n,position={x=(x+y)*2,y=y*2,z=(z+y)*2}} end end end return b end
function SB.Platform(n,w,l) local b={} for x=0,w-1 do for z=0,l-1 do b[#b+1]={name=n,position={x=x*4,y=0,z=z*2},size={x=4,y=1.2,z=2}} end end return b end
function SB.HollowBox(n,w,h,d) local b={} for x=0,w-1 do for y=0,h-1 do for z=0,d-1 do if x==0 or x==w-1 or y==0 or y==h-1 or z==0 or z==d-1 then b[#b+1]={name=n,position={x=x*2,y=y*2,z=z*2}} end end end end return b end
function SB.BoatHull(n,len,w) local b={} for x=0,len-1 do for z=0,w-1 do b[#b+1]={name=n,position={x=x*4,y=0,z=z*2}} end end for x=0,len-1 do for y=1,2 do b[#b+1]={name=n,position={x=x*4,y=y*1.2,z=0}} b[#b+1]={name=n,position={x=x*4,y=y*1.2,z=(w-1)*2}} end end return b end
function SB.Run(shape,n,p)
    local bl={}
    if shape=="Ball" then bl=SB.Ball(n,p.r or 3)
    elseif shape=="Cylinder" then bl=SB.Cylinder(n,p.r or 3,p.h or 5)
    elseif shape=="Triangle" then bl=SB.Triangle(n,p.base or 5,p.h or 5)
    elseif shape=="Pyramid" then bl=SB.Pyramid(n,p.base or 5)
    elseif shape=="Platform" then bl=SB.Platform(n,p.w or 5,p.l or 5)
    elseif shape=="HollowBox" then bl=SB.HollowBox(n,p.w or 5,p.h or 3,p.d or 5)
    elseif shape=="BoatHull" then bl=SB.BoatHull(n,p.l or 8,p.w or 4) end
    if #bl>0 then return {version="1.0",name="OxyX_"..shape,author=LP.Name,blocks=bl,welds={}} end
end

-- ═══ STATE ══════════════════════════════════════
local St={minimized=false,tab="Build",buildData=nil,sp={r=3,h=5,w=5,l=8,base=5,d=5}}

-- ════════════════════════════════════════════════
--   BUILD UI
-- ════════════════════════════════════════════════
local function BuildUI()
    pcall(function()
        local old=GP:FindFirstChild("OxyX_v6")
        if old then old:Destroy() end
    end)
    MkDir("builds"); MkDir("json")
    local invCnt=ScanInventory()

    local SG=New("ScreenGui",{Name="OxyX_v6",ResetOnSpawn=false,IgnoreGuiInset=true,
        DisplayOrder=9999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=GP})
    if not SG then Notify("Error","Gagal buat GUI",5); return end

    -- ─── WINDOW  500 × 610 ──────────────────────
    -- SENGAJA 500px lebar supaya 6 tab muat dengan nyaman
    local MF=New("Frame",{
        Size=UDim2.new(0,500,0,610),
        Position=UDim2.new(0.5,-250,0.5,-305),
        BackgroundColor3=C.BG0,BorderSizePixel=0,
        ClipsDescendants=false,Parent=SG})
    New("UICorner",{CornerRadius=UDim.new(0,16),Parent=MF})

    -- Animated glow border
    local BordF=New("Frame",{Size=UDim2.new(1,8,1,8),Position=UDim2.new(0,-4,0,-4),
        BackgroundColor3=C.PRP,BorderSizePixel=0,ZIndex=0,Parent=MF})
    New("UICorner",{CornerRadius=UDim.new(0,20),Parent=BordF})
    local BG=New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.PRP),ColorSequenceKeypoint.new(0.25,C.CYN),
        ColorSequenceKeypoint.new(0.5,C.PNK),ColorSequenceKeypoint.new(0.75,C.GLD),
        ColorSequenceKeypoint.new(1,C.PRP),
    }),Rotation=0,Parent=BordF})

    -- Inner BG
    local Inn=New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=C.BG0,
        BorderSizePixel=0,ZIndex=1,Parent=MF})
    New("UICorner",{CornerRadius=UDim.new(0,16),Parent=Inn})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(6,3,22)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(5,9,28)),
    }),Rotation=145,Parent=Inn})

    -- Stars
    for i=1,30 do
        local sz=math.random(1,3)
        local s=New("Frame",{
            Size=UDim2.new(0,sz,0,sz),
            Position=UDim2.new(math.random()*.94,0,math.random()*.94,0),
            BackgroundColor3=i%3==0 and C.CYN or i%2==0 and C.LPRP or C.WHT,
            BackgroundTransparency=math.random()*.5+.15,BorderSizePixel=0,ZIndex=2,Parent=Inn})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=s})
        task.spawn(function()
            while s and s.Parent do
                task.wait(.9+math.random()*2.5)
                pcall(function()
                    Tw(s,{BackgroundTransparency=.92},.4)
                    task.wait(.45)
                    Tw(s,{BackgroundTransparency=math.random()*.45},.4)
                end)
            end
        end)
    end
    -- Nebula
    for _,nb in ipairs({
        {Color3.fromRGB(40,0,78),.87,UDim2.new(.04,0,.08,0),150,90},
        {Color3.fromRGB(0,30,72),.89,UDim2.new(.5,0,.52,0),120,95},
        {Color3.fromRGB(68,0,58),.88,UDim2.new(.7,0,.06,0),105,75},
    }) do
        local nf=New("Frame",{Size=UDim2.new(0,nb[4],0,nb[5]),Position=nb[3],
            BackgroundColor3=nb[1],BackgroundTransparency=nb[2],BorderSizePixel=0,ZIndex=2,Parent=Inn})
        New("UICorner",{CornerRadius=UDim.new(.5,0),Parent=nf})
    end

    -- Rotating border
    local ba=0
    local bconn=RunService.Heartbeat:Connect(function(dt)
        ba=(ba+dt*40)%360
        pcall(function() BG.Rotation=ba end)
    end)

    -- ─── HEADER 88px ────────────────────────────
    local HDR=New("Frame",{Size=UDim2.new(1,0,0,88),
        BackgroundColor3=C.BG1,BorderSizePixel=0,ZIndex=10,Parent=Inn})
    New("UICorner",{CornerRadius=UDim.new(0,16),Parent=HDR})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(30,12,78)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(10,5,32)),
    }),Rotation=90,Parent=HDR})
    -- Patch bottom corners
    New("Frame",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,-20),
        BackgroundColor3=C.BG1,BorderSizePixel=0,ZIndex=10,Parent=HDR})

    -- ─── ASTOLFO ANIMATED ───────────────────────
    -- Roblox tidak support GIF asli.
    -- Simulasi: 4 ImageLabel di-overlap, fade bergantian = pseudo-GIF animation
    local AF=New("Frame",{Size=UDim2.new(0,70,0,70),Position=UDim2.new(0,12,0,9),
        BackgroundColor3=C.BG0,BorderSizePixel=0,ZIndex=15,Parent=HDR})
    New("UICorner",{CornerRadius=UDim.new(0,14),Parent=AF})
    New("UIStroke",{Color=C.PNK,Thickness=2.5,Parent=AF})

    -- Glow ring
    local GR=New("Frame",{Size=UDim2.new(1,12,1,12),Position=UDim2.new(0,-6,0,-6),
        BackgroundTransparency=1,BorderSizePixel=0,ZIndex=14,Parent=AF})
    New("UICorner",{CornerRadius=UDim.new(0,20),Parent=GR})
    local GS=New("UIStroke",{Color=C.PNK,Thickness=3.5,Transparency=.1,Parent=GR})

    -- ASTOLFO ANIMATED:
    -- Roblox ImageLabel TIDAK support GIF.
    -- Workaround terbaik: pakai ImageLabel tunggal + animasikan ImageColor3 & Position
    -- untuk efek "hidup", plus shimmer sweep yang konsisten
    -- Asset IDs Astolfo yang valid di Roblox:
    local ASTOLFO_IMGS = {
        "rbxassetid://7078026274",   -- astolfo pink
        "rbxassetid://6423102987",   -- anime character pink
        "rbxassetid://7078026274",
        "rbxassetid://11832808662",  -- astolfo alt
    }
    -- Satu ImageLabel utama (visible)
    local AImgMain=New("ImageLabel",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        Image=ASTOLFO_IMGS[1],ScaleType=Enum.ScaleType.Crop,
        ZIndex=16,Parent=AF})
    New("UICorner",{CornerRadius=UDim.new(0,12),Parent=AImgMain})

    -- Overlay untuk crossfade (layer ke-2)
    local AImgOver=New("ImageLabel",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        Image=ASTOLFO_IMGS[2],ImageTransparency=1,
        ScaleType=Enum.ScaleType.Crop,ZIndex=17,Parent=AF})
    New("UICorner",{CornerRadius=UDim.new(0,12),Parent=AImgOver})

    -- Shimmer sweep (efek glitter)
    local Shim=New("Frame",{
        Size=UDim2.new(0.3,0,1.3,0),Position=UDim2.new(-0.3,0,-0.15,0),
        BackgroundColor3=C.WHT,BackgroundTransparency=0.75,
        BorderSizePixel=0,ZIndex=19,Parent=AF})
    New("UICorner",{CornerRadius=UDim.new(0,4),Parent=Shim})
    -- Rotate shimmer sedikit supaya diagonal
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,220,255)),
        ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
    }),Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.4,0.55),
        NumberSequenceKeypoint.new(0.6,0.55),
        NumberSequenceKeypoint.new(1,1),
    }),Rotation=15,Parent=Shim})

    -- Colour tint pulse (bikin "hidup")
    local TINTS={
        Color3.fromRGB(255,230,245),  -- pink warm
        Color3.fromRGB(220,235,255),  -- blue cool
        Color3.fromRGB(255,245,220),  -- golden
        Color3.fromRGB(230,255,240),  -- green tint
    }

    -- Animasi: crossfade antar asset + shimmer loop + tint pulse
    local imgIdx=1
    task.spawn(function()
        while AImgMain and AImgMain.Parent do
            local nextIdx=(imgIdx%#ASTOLFO_IMGS)+1
            -- Tween overlay masuk
            pcall(function()
                AImgOver.Image=ASTOLFO_IMGS[nextIdx]
                AImgOver.ImageTransparency=1
                -- crossfade: overlay fade in, main fade out
                Tw(AImgOver,{ImageTransparency=0},0.4,Enum.EasingStyle.Sine)
                Tw(AImgMain,{ImageTransparency=1},0.4,Enum.EasingStyle.Sine)
            end)
            task.wait(0.45)
            -- Swap: sekarang overlay jadi main
            pcall(function()
                AImgMain.Image=ASTOLFO_IMGS[nextIdx]
                AImgMain.ImageTransparency=0
                AImgOver.ImageTransparency=1
            end)
            imgIdx=nextIdx

            -- Tint pulse
            Tw(AImgMain,{ImageColor3=TINTS[imgIdx]},0.3,Enum.EasingStyle.Sine)
            task.wait(0.3)
            Tw(AImgMain,{ImageColor3=Color3.new(1,1,1)},0.3,Enum.EasingStyle.Sine)
            task.wait(0.8)
        end
    end)

    -- Shimmer sweep loop (independen)
    task.spawn(function()
        while Shim and Shim.Parent do
            Tw(Shim,{Position=UDim2.new(1.1,0,-0.15,0)},0.7,Enum.EasingStyle.Sine)
            task.wait(0.75)
            pcall(function() Shim.Position=UDim2.new(-0.3,0,-0.15,0) end)
            task.wait(1.8+math.random()*1.2)
        end
    end)

    -- Glow ring colour cycle
    local rba=0
    local ringConn=RunService.Heartbeat:Connect(function(dt)
        rba=(rba+dt*95)%360
        -- manual hue shift on stroke
    end)
    task.spawn(function()
        local gc={C.PNK,C.CYN,C.LPRP,C.GLD,C.PRP}; local gi=1
        while GS and GS.Parent do
            gi=gi%#gc+1
            Tw(GS,{Color=gc[gi]},1,Enum.EasingStyle.Sine)
            task.wait(1.1)
        end
    end)

    -- ─── TITLE ──────────────────────────────────
    local TA=New("Frame",{Size=UDim2.new(0,260,0,70),Position=UDim2.new(0,92,0,9),
        BackgroundTransparency=1,ZIndex=15,Parent=HDR})
    local TL=New("TextLabel",{Size=UDim2.new(1,0,0,38),BackgroundTransparency=1,
        Text="OxyX",TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextScaled=true,
        ZIndex=15,Parent=TA})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.LPRP),ColorSequenceKeypoint.new(.35,C.CYN),
        ColorSequenceKeypoint.new(.7,C.PNK),ColorSequenceKeypoint.new(1,C.GLD),
    }),Rotation=5,Parent=TL})
    New("TextLabel",{Size=UDim2.new(1,0,0,17),Position=UDim2.new(0,0,0,39),
        BackgroundTransparency=1,Text="Build A Boat For Treasure  —  Galaxy Edition",
        TextColor3=C.TXT1,Font=Enum.Font.Gotham,TextScaled=true,ZIndex=15,Parent=TA})
    local BR=New("Frame",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,57),
        BackgroundTransparency=1,ZIndex=15,Parent=TA})
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),Parent=BR})
    for _,info in ipairs({{"v5.0",C.DPRP},{"GALAXY",C.PRP},{"159 BLK",Color3.fromRGB(0,100,50)},{"INV:"..invCnt,Color3.fromRGB(0,80,120)}}) do
        local b=New("TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundColor3=info[2],BorderSizePixel=0,Text=" "..info[1].." ",
            TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextSize=9,ZIndex=16,Parent=BR})
        New("UICorner",{CornerRadius=UDim.new(0,4),Parent=b})
    end

    -- Controls
    local MinB=New("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-66,0,12),
        BackgroundColor3=C.BG3,BorderSizePixel=0,Text="−",TextColor3=C.YLW,
        Font=Enum.Font.GothamBold,TextSize=20,AutoButtonColor=false,ZIndex=20,Parent=HDR})
    New("UICorner",{CornerRadius=UDim.new(0,8),Parent=MinB})
    New("UIStroke",{Color=C.YLW,Thickness=1.5,Parent=MinB})
    local ClsB=New("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-34,0,12),
        BackgroundColor3=C.BG3,BorderSizePixel=0,Text="✕",TextColor3=C.RED,
        Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,ZIndex=20,Parent=HDR})
    New("UICorner",{CornerRadius=UDim.new(0,8),Parent=ClsB})
    New("UIStroke",{Color=C.RED,Thickness=1.5,Parent=ClsB})

    -- ─── TAB BAR ────────────────────────────────
    -- Window: 500px
    -- 6 tabs × 76px + 5 gaps × 4px + 2 × 6px padding = 456+20+12 = 488px  ✅ muat!
    local TabBG=New("Frame",{Size=UDim2.new(1,0,0,38),Position=UDim2.new(0,0,0,88),
        BackgroundColor3=C.BG1,BorderSizePixel=0,ZIndex=10,Parent=Inn})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(20,10,55)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(9,5,28)),
    }),Rotation=90,Parent=TabBG})
    -- Divider garis atas
    New("Frame",{Size=UDim2.new(1,-12,0,1),Position=UDim2.new(0,6,0,0),
        BackgroundColor3=C.BG3,BorderSizePixel=0,Parent=TabBG})

    -- Tab row: NO UIListLayout, manual absolute positioning
    -- Window = 500px, padding 6px each side = 488px usable
    -- 6 tabs dengan gap 3px: (488 - 5*3) / 6 = 78px per tab
    local TAB_W = 78
    local TAB_GAP = 4
    local TAB_START = 6

    -- ─── CONTENT ────────────────────────────────
    local ContentSF=New("ScrollingFrame",{
        Size=UDim2.new(1,0,1,-162),Position=UDim2.new(0,0,0,126),
        BackgroundColor3=C.BG0,BorderSizePixel=0,
        ScrollBarThickness=4,ScrollBarImageColor3=C.PRP,
        CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=5,Parent=Inn})

    -- Progress bar
    local PBG=New("Frame",{Size=UDim2.new(1,-20,0,8),Position=UDim2.new(0,10,0,130),
        BackgroundColor3=C.BG3,BorderSizePixel=0,Visible=false,ZIndex=12,Parent=Inn})
    New("UICorner",{CornerRadius=UDim.new(1,0),Parent=PBG})
    local PFill=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.GRN,BorderSizePixel=0,Parent=PBG})
    New("UICorner",{CornerRadius=UDim.new(1,0),Parent=PFill})
    New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.CYN),ColorSequenceKeypoint.new(1,C.GRN)}),Parent=PFill})
    local PLbl=New("TextLabel",{Size=UDim2.new(1,-20,0,12),Position=UDim2.new(0,10,0,140),
        BackgroundTransparency=1,Text="",TextColor3=C.TXT1,Font=Enum.Font.Gotham,TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left,Visible=false,ZIndex=12,Parent=Inn})

    -- Status bar
    local SBar=New("Frame",{Size=UDim2.new(1,0,0,34),Position=UDim2.new(0,0,1,-34),
        BackgroundColor3=C.BG1,BorderSizePixel=0,ZIndex=10,Parent=Inn})
    New("UICorner",{CornerRadius=UDim.new(0,16),Parent=SBar})
    New("Frame",{Size=UDim2.new(1,0,0,18),BackgroundColor3=C.BG1,BorderSizePixel=0,ZIndex=10,Parent=SBar})
    New("Frame",{Size=UDim2.new(1,-20,0,1),Position=UDim2.new(0,10,0,1),BackgroundColor3=C.BG3,BorderSizePixel=0,Parent=SBar})
    local StatLbl=New("TextLabel",{Size=UDim2.new(1,-140,1,0),Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,Text="✦  Ready  |  "..EXE,TextColor3=C.TXT1,
        Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=15,Parent=SBar})
    local InvLbl=New("TextLabel",{Size=UDim2.new(0,132,1,0),Position=UDim2.new(1,-135,0,0),
        BackgroundTransparency=1,Text="Inv: "..invCnt.." blocks ✓",
        TextColor3=C.LPRP,Font=Enum.Font.GothamBold,TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Right,ZIndex=15,Parent=SBar})

    -- ════════════════════════════════════════════
    -- WIDGET FACTORIES
    -- ════════════════════════════════════════════
    local Pages={} local Tabs={}

    local function Page(name)
        local p=New("Frame",{Name="P_"..name,Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,Visible=false,Parent=ContentSF})
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=p})
        New("UIPadding",{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),
            PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,14),Parent=p})
        Pages[name]=p; return p
    end

    local function Sec(par,txt,ico)
        local f=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=f})
        New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(44,18,105)),ColorSequenceKeypoint.new(1,Color3.fromRGB(19,9,55))}),Rotation=90,Parent=f})
        local bar=New("Frame",{Size=UDim2.new(0,4,0.72,0),Position=UDim2.new(0,0,0.14,0),BackgroundColor3=C.PRP,BorderSizePixel=0,Parent=f})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=bar})
        New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.CYN),ColorSequenceKeypoint.new(1,C.PRP)}),Rotation=90,Parent=bar})
        New("TextLabel",{Size=UDim2.new(1,-14,1,0),Position=UDim2.new(0,12,0,0),
            BackgroundTransparency=1,Text=(ico or "◆").."  "..txt,TextColor3=C.LPRP,
            Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        return f
    end

    local function Btn(par,txt,col,cb,ico)
        col=col or C.PRP
        local r2,g2,b2=col.R*255,col.G*255,col.B*255
        local dark=Color3.fromRGB(math.floor(r2*.2),math.floor(g2*.2),math.floor(b2*.2))
        local mid=Color3.fromRGB(math.floor(r2*.38),math.floor(g2*.38),math.floor(b2*.38))
        local btn=New("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=dark,
            BorderSizePixel=0,Text=(ico and ico.."  " or "")..txt,
            TextColor3=C.TXT0,Font=Enum.Font.GothamBold,TextSize=13,
            AutoButtonColor=false,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,9),Parent=btn})
        New("UIStroke",{Color=col,Thickness=1.5,Parent=btn})
        btn.MouseEnter:Connect(function() Tw(btn,{BackgroundColor3=mid},.12) end)
        btn.MouseLeave:Connect(function() Tw(btn,{BackgroundColor3=dark},.12) end)
        btn.MouseButton1Down:Connect(function() Tw(btn,{BackgroundColor3=col},.07) end)
        btn.MouseButton1Up:Connect(function() Tw(btn,{BackgroundColor3=mid},.1) end)
        if cb then btn.MouseButton1Click:Connect(cb) end
        return btn
    end

    local function InBox(par,ph,def,h)
        local ctr=New("Frame",{Size=UDim2.new(1,0,0,h or 33),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        local st=New("UIStroke",{Color=C.BG3,Thickness=1.5,Parent=ctr})
        local tb=New("TextBox",{Size=UDim2.new(1,-14,1,0),Position=UDim2.new(0,7,0,0),
            BackgroundTransparency=1,Text=def or "",PlaceholderText=ph or "",
            PlaceholderColor3=C.TXT2,TextColor3=C.TXT0,Font=Enum.Font.Gotham,
            TextSize=12,ClearTextOnFocus=false,Parent=ctr})
        tb.Focused:Connect(function() pcall(function() Tw(st,{Color=C.PRP},.2) Tw(ctr,{BackgroundColor3=C.BG3},.2) end) end)
        tb.FocusLost:Connect(function() pcall(function() Tw(st,{Color=C.BG3},.2) Tw(ctr,{BackgroundColor3=C.BG2},.2) end) end)
        return tb,ctr
    end

    local function BigIn(par,ph,h)
        local ctr=New("Frame",{Size=UDim2.new(1,0,0,h or 85),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        New("UIStroke",{Color=C.BG3,Thickness=1.5,Parent=ctr})
        local tb=New("TextBox",{Size=UDim2.new(1,-10,1,-6),Position=UDim2.new(0,5,0,3),
            BackgroundTransparency=1,Text="",PlaceholderText=ph or "",
            PlaceholderColor3=C.TXT2,TextColor3=C.TXT0,Font=Enum.Font.Code,
            TextSize=10,MultiLine=true,ClearTextOnFocus=false,
            TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Parent=ctr})
        return tb,ctr
    end

    local function Card(par,txt,col)
        local f=New("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=col or C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=f})
        New("UIStroke",{Color=C.BG3,Thickness=1,Parent=f})
        local l=New("TextLabel",{Size=UDim2.new(1,-14,1,0),Position=UDim2.new(0,7,0,0),
            BackgroundTransparency=1,Text=txt,TextColor3=C.TXT1,Font=Enum.Font.Gotham,
            TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        return f,l
    end

    local function Toggle(par,lbl,def,cb)
        local ctr=New("Frame",{Size=UDim2.new(1,0,0,33),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        New("TextLabel",{Size=UDim2.new(1,-58,1,0),Position=UDim2.new(0,9,0,0),
            BackgroundTransparency=1,Text=lbl,TextColor3=C.TXT0,Font=Enum.Font.Gotham,TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=ctr})
        local tbg=New("Frame",{Size=UDim2.new(0,42,0,20),Position=UDim2.new(1,-50,0.5,-10),
            BackgroundColor3=def and C.PRP or C.BG0,BorderSizePixel=0,Parent=ctr})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=tbg})
        New("UIStroke",{Color=def and C.PRP or C.TXT2,Thickness=1.5,Parent=tbg})
        local kn=New("Frame",{Size=UDim2.new(0,14,0,14),
            Position=def and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            BackgroundColor3=C.WHT,BorderSizePixel=0,Parent=tbg})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=kn})
        local v=def or false
        New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=10,Parent=ctr}).MouseButton1Click:Connect(function()
            v=not v
            pcall(function() Tw(tbg,{BackgroundColor3=v and C.PRP or C.BG0},.2) Tw(kn,{Position=v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},.2) end)
            if cb then cb(v) end
        end)
        return ctr,function() return v end
    end

    local function Slider(par,lbl,mn,mx,def,cb)
        local v=def or mn
        local ctr=New("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        local row=New("Frame",{Size=UDim2.new(1,-14,0,16),Position=UDim2.new(0,7,0,4),BackgroundTransparency=1,Parent=ctr})
        New("TextLabel",{Size=UDim2.new(.72,0,1,0),BackgroundTransparency=1,Text=lbl,TextColor3=C.TXT0,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
        local vl=New("TextLabel",{Size=UDim2.new(.28,0,1,0),Position=UDim2.new(.72,0,0,0),BackgroundTransparency=1,Text=tostring(v),TextColor3=C.CYN,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
        local trk=New("Frame",{Size=UDim2.new(1,-14,0,6),Position=UDim2.new(0,7,0,28),BackgroundColor3=C.BG0,BorderSizePixel=0,Parent=ctr})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=trk})
        local fill=New("Frame",{Size=UDim2.new((v-mn)/(mx-mn),0,1,0),BackgroundColor3=C.PRP,BorderSizePixel=0,Parent=trk})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=fill})
        New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.DPRP),ColorSequenceKeypoint.new(1,C.CYN)}),Parent=fill})
        local kn=New("Frame",{Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new((v-mn)/(mx-mn),0,.5,0),BackgroundColor3=C.WHT,BorderSizePixel=0,ZIndex=10,Parent=trk})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=kn})
        New("UIStroke",{Color=C.PRP,Thickness=2,Parent=kn})
        local drag=false
        local sb=New("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0,18),BackgroundTransparency=1,Text="",ZIndex=20,Parent=ctr})
        local function upd(mx2)
            local rx=math.clamp((mx2-trk.AbsolutePosition.X)/trk.AbsoluteSize.X,0,1)
            v=math.floor(mn+rx*(mx-mn))
            pcall(function() vl.Text=tostring(v) fill.Size=UDim2.new(rx,0,1,0) kn.Position=UDim2.new(rx,0,.5,0) end)
            if cb then cb(v) end
        end
        sb.MouseButton1Down:Connect(function() drag=true; upd(Mouse.X) end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
        RunService.Heartbeat:Connect(function() if drag then pcall(upd,Mouse.X) end end)
        return ctr,function() return v end
    end

    local function Dropdown(par,lbl,opts,def,cb)
        local sel=def or opts[1]; local open=false
        local ctr=New("Frame",{Size=UDim2.new(1,0,0,33),BackgroundColor3=C.BG2,BorderSizePixel=0,ClipsDescendants=false,ZIndex=50,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=ctr})
        New("UIStroke",{Color=C.BG3,Thickness=1,Parent=ctr})
        New("TextLabel",{Size=UDim2.new(0,80,1,0),Position=UDim2.new(0,7,0,0),BackgroundTransparency=1,Text=lbl,TextColor3=C.TXT1,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=ctr})
        local vl=New("TextLabel",{Size=UDim2.new(1,-100,1,0),Position=UDim2.new(0,84,0,0),BackgroundTransparency=1,Text=sel,TextColor3=C.LPRP,Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=ctr})
        local arr=New("TextLabel",{Size=UDim2.new(0,14,1,0),Position=UDim2.new(1,-16,0,0),BackgroundTransparency=1,Text="▼",TextColor3=C.LPRP,Font=Enum.Font.GothamBold,TextSize=8,ZIndex=51,Parent=ctr})
        New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=52,Parent=ctr}).MouseButton1Click:Connect(function()
            open=not open
            local dl=ctr:FindFirstChild("DropList")
            if dl then dl.Visible=open end
            arr.Text=open and "▲" or "▼"
        end)
        local maxH=math.min(#opts*26,140)
        local dl=New("Frame",{Name="DropList",Size=UDim2.new(1,0,0,maxH),Position=UDim2.new(0,0,1,2),BackgroundColor3=Color3.fromRGB(14,8,40),BorderSizePixel=0,Visible=false,ZIndex=300,ClipsDescendants=true,Parent=ctr})
        New("UICorner",{CornerRadius=UDim.new(0,8),Parent=dl})
        New("UIStroke",{Color=C.PRP,Thickness=1,Parent=dl})
        local sc=New("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=C.PRP,CanvasSize=UDim2.new(1,0,0,#opts*26),ZIndex=301,Parent=dl})
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Parent=sc})
        for _,opt in ipairs(opts) do
            local ob=New("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=Color3.fromRGB(14,8,40),BorderSizePixel=0,Text=opt,TextColor3=C.TXT0,Font=Enum.Font.Gotham,TextSize=11,AutoButtonColor=false,ZIndex=302,Parent=sc})
            ob.MouseEnter:Connect(function() pcall(function() Tw(ob,{BackgroundColor3=C.BG3},.1) end) end)
            ob.MouseLeave:Connect(function() pcall(function() Tw(ob,{BackgroundColor3=Color3.fromRGB(14,8,40)},.1) end) end)
            ob.MouseButton1Click:Connect(function()
                sel=opt; vl.Text=opt; open=false; dl.Visible=false; arr.Text="▼"
                if cb then cb(opt) end
            end)
        end
        return ctr,function() return sel end
    end

    local function FileBrowser(par,folder,ext,onLoad)
        local ac=ext==".build" and C.PRP or C.CYN
        local ico=ext==".build" and "🏗" or "📄"
        local wrap=New("Frame",{Size=UDim2.new(1,0,0,168),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=par})
        New("UICorner",{CornerRadius=UDim.new(0,10),Parent=wrap})
        New("UIStroke",{Color=ac,Thickness=1.5,Parent=wrap})
        local hs=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=ac,BorderSizePixel=0,Parent=wrap})
        New("UICorner",{CornerRadius=UDim.new(0,10),Parent=hs})
        New("Frame",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-14),BackgroundColor3=ac,BorderSizePixel=0,Parent=hs})
        New("TextLabel",{Size=UDim2.new(1,-86,1,0),Position=UDim2.new(0,9,0,0),BackgroundTransparency=1,
            Text=ico.."  "..folder.."/   ["..ext.." only]",
            TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=hs})
        local rb=New("TextButton",{Size=UDim2.new(0,66,0,20),Position=UDim2.new(1,-70,0.5,-10),
            BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=.45,BorderSizePixel=0,
            Text="🔄 Refresh",TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextSize=10,
            AutoButtonColor=false,Parent=hs})
        New("UICorner",{CornerRadius=UDim.new(0,5),Parent=rb})
        local ls=New("ScrollingFrame",{Size=UDim2.new(1,-6,0,133),Position=UDim2.new(0,3,0,31),
            BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=ac,
            CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=wrap})
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=ls})
        New("UIPadding",{PaddingAll=UDim.new(0,3),Parent=ls})
        local function Refresh()
            for _,c in ipairs(ls:GetChildren()) do
                if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
            end
            local files=LsExt(folder,ext)
            if #files==0 then
                New("TextLabel",{Size=UDim2.new(1,0,0,50),BackgroundTransparency=1,
                    Text="Tidak ada file "..ext.." di '"..folder.."/'\nLetakkan file lalu Refresh.",
                    TextColor3=C.TXT2,Font=Enum.Font.Gotham,TextSize=11,TextWrapped=true,Parent=ls})
                return
            end
            for _,f in ipairs(files) do
                local row=New("Frame",{Size=UDim2.new(1,-2,0,28),BackgroundColor3=Color3.fromRGB(13,7,38),BorderSizePixel=0,Parent=ls})
                New("UICorner",{CornerRadius=UDim.new(0,6),Parent=row})
                New("TextLabel",{Size=UDim2.new(0,20,1,0),Position=UDim2.new(0,3,0,0),BackgroundTransparency=1,Text=ico,TextColor3=ac,Font=Enum.Font.GothamBold,TextSize=12,Parent=row})
                New("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.new(0,24,0,0),BackgroundTransparency=1,Text=f.name,TextColor3=C.TXT0,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=row})
                local lb2=New("TextButton",{Size=UDim2.new(0,50,0,18),Position=UDim2.new(1,-54,0.5,-9),BackgroundColor3=ac,BorderSizePixel=0,Text="▶ Load",TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextSize=10,AutoButtonColor=false,Parent=row})
                New("UICorner",{CornerRadius=UDim.new(0,5),Parent=lb2})
                row.MouseEnter:Connect(function() Tw(row,{BackgroundColor3=C.BG3},.1) end)
                row.MouseLeave:Connect(function() Tw(row,{BackgroundColor3=Color3.fromRGB(13,7,38)},.1) end)
                local function doLoad()
                    local content=RdF(f.path) or RdF(folder.."/"..f.name)
                    if not content then Notify("Error","Gagal baca: "..f.name,3); return end
                    if onLoad then onLoad(f.name,content) end
                end
                lb2.MouseButton1Click:Connect(doLoad)
                New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=row}).MouseButton1Click:Connect(doLoad)
            end
        end
        Refresh()
        rb.MouseButton1Click:Connect(function() Refresh(); Notify("Refresh","List diperbarui",2) end)
        return wrap
    end

    -- ─── TAB SWITCH ─────────────────────────────
    local tabDefs={
        {n="Build",  lbl="🏗 Build"},
        {n="Shapes", lbl="⬡ Shapes"},
        {n="Convert",lbl="🔄 Convert"},
        {n="Images", lbl="🖼 Images"},
        {n="Blocks", lbl="📦 Blocks"},
        {n="Info",   lbl="⚙ Info"},
    }

    local function SwitchTab(name)
        St.tab=name
        for _,p in pairs(Pages) do pcall(function() p.Visible=false end) end
        for nm,b in pairs(Tabs) do
            pcall(function()
                if nm==name then Tw(b,{BackgroundColor3=C.PRP},.2); b.TextColor3=C.WHT
                else Tw(b,{BackgroundColor3=C.BG3},.2); b.TextColor3=C.TXT2 end
            end)
        end
        if Pages[name] then Pages[name].Visible=true end
        StatLbl.Text="✦  "..name.."  |  "..EXE
    end

    -- Buat 6 tab button dengan posisi manual absolut - PASTI tidak offside
    for i,td in ipairs(tabDefs) do
        local xpos = TAB_START + (i-1)*(TAB_W+TAB_GAP)
        local b=New("TextButton",{
            Size=UDim2.new(0,TAB_W,0,28),
            Position=UDim2.new(0,xpos,0,4),
            BackgroundColor3=C.BG3,BorderSizePixel=0,
            Text=td.lbl,TextColor3=C.TXT2,
            Font=Enum.Font.GothamBold,TextSize=9,
            AutoButtonColor=false,ZIndex=15,Parent=TabBG})
        New("UICorner",{CornerRadius=UDim.new(0,7),Parent=b})
        Tabs[td.n]=b
        b.MouseButton1Click:Connect(function() SwitchTab(td.n) end)
    end

    -- ════════════════════════════════════════════
    -- PAGES
    -- ════════════════════════════════════════════

    -- BUILD
    local BP=Page("Build")
    Sec(BP,"📂  File .build  (folder: builds/)","")
    FileBrowser(BP,"builds",".build",function(fname,content)
        local d,e=ParseBuild(content)
        if d then St.buildData=d; ScanInventory()
            Notify("Loaded ✓",fname.." | "..#d.blocks.." blocks",3)
            StatLbl.Text="✅  "..fname.."  |  "..#d.blocks.." blocks"
        else Notify("Error","Gagal: "..(e or "?"),3) end
    end)
    Sec(BP,"✏  Paste .build Manual","")
    local bTB,_=BigIn(BP,'{"version":"1.0","blocks":[...]}')
    Btn(BP,"📋  Parse & Load",C.CYN,function()
        local d,e=ParseBuild(bTB.Text)
        if d then St.buildData=d; ScanInventory(); Notify("Loaded",d.name.." | "..#d.blocks.." blocks",3)
        else Notify("Error",e or "Gagal",3) end
    end,"📋")
    Sec(BP,"⚙  Opsi","")
    Toggle(BP,"Auto Weld setelah build",true)
    Slider(BP,"Delay per block (ms)",0,500,150,function(v) Placer.delay=v/1000 end)
    Sec(BP,"🚀  Build","")
    local _,bStatL=Card(BP,"Belum ada build. Load file .build di atas.")
    RunService.Heartbeat:Connect(function()
        if St.buildData then pcall(function()
            bStatL.Text="📦  "..(St.buildData.name or "?").."  |  "..#St.buildData.blocks.." blocks"
            bStatL.TextColor3=C.GRN
        end) end
    end)
    Btn(BP,"▶▶  MULAI AUTO BUILD  ◀◀",C.GRN,function()
        if not St.buildData then Notify("Error","Load file .build dulu!",3); return end
        ScanInventory()
        local total=#St.buildData.blocks
        PBG.Visible=true; PLbl.Visible=true; PFill.Size=UDim2.new(0,0,1,0)
        StatLbl.Text="🔨  Building 0/"..total
        Placer:Build(St.buildData,function(i,tot,used,ok2)
            pcall(function()
                Tw(PFill,{Size=UDim2.new(i/tot,0,1,0)},.1)
                if used=="DONE" then
                    PLbl.Text="✅  Selesai! "..tot.." blocks"
                    StatLbl.Text="✅  Selesai! "..tot.." blocks"
                    task.delay(4,function() pcall(function() PBG.Visible=false; PLbl.Visible=false end) end)
                else
                    PLbl.Text="🔨  ["..i.."/"..tot.."]  "..used..(ok2 and "" or "  ⚠")
                    StatLbl.Text="🔨  ["..i.."/"..tot.."]"
                end
            end)
        end)
    end,"▶")
    Btn(BP,"⏹  Stop Build",C.YLW,function() Placer:Stop() end,"⏹")
    Btn(BP,"🗑  Hapus Data",C.RED,function()
        St.buildData=nil; bTB.Text=""
        bStatL.Text="Belum ada build."; bStatL.TextColor3=C.TXT1
        StatLbl.Text="✦  Ready  |  "..EXE
        Notify("Clear","Data dihapus",2)
    end,"🗑")

    -- SHAPES
    local ShP=Page("Shapes")
    Sec(ShP,"⬡  Shape","")
    local _,getShape=Dropdown(ShP,"Shape:",{"Ball","Cylinder","Triangle","Pyramid","Platform","HollowBox","BoatHull"},"Ball",function(v) St.stype=v end)
    local bnames={}; for _,b in ipairs(DB) do bnames[#bnames+1]=b.n end
    local _,getSBlock=Dropdown(ShP,"Block:",bnames,"Wood Block",function(v) St.sblock=v end)
    Sec(ShP,"📐  Parameter","")
    Slider(ShP,"Radius / Base",1,15,3,function(v) St.sp.r=v; St.sp.base=v end)
    Slider(ShP,"Height",1,20,5,function(v) St.sp.h=v end)
    Slider(ShP,"Width",1,20,5,function(v) St.sp.w=v end)
    Slider(ShP,"Length",1,30,8,function(v) St.sp.l=v end)
    Sec(ShP,"🔨  Aksi","")
    local _,prvL=Card(ShP,"Preview muncul di sini.")
    Btn(ShP,"👁  Preview",C.CYN,function()
        local d=SB.Run(getShape(),getSBlock(),St.sp)
        if d then St.buildData=d; prvL.Text="🔮  "..getShape().." | "..#d.blocks.." blocks | "..getSBlock(); prvL.TextColor3=C.LPRP; Notify("Preview","Siap",2) end
    end,"👁")
    Btn(ShP,"🚀  Build Shape",C.GRN,function()
        local d=SB.Run(getShape(),getSBlock(),St.sp)
        if not d then Notify("Error","Gagal",3); return end
        St.buildData=d
        Placer:Build(d,function(i,tot,bn) if bn=="DONE" then Notify("Done","Shape selesai! "..tot,3) end end)
    end,"🚀")
    Btn(ShP,"💾  Simpan → builds/",C.PRP,function()
        local d=SB.Run(getShape(),getSBlock(),St.sp)
        if d then
            local j=Ser(d.name,d.blocks)
            if j and WrF("builds/"..d.name..".build",j) then Notify("Saved","builds/"..d.name..".build",3)
            elseif j and setclipboard then setclipboard(j); Notify("Copied","Clipboard",3) end
        end
    end,"💾")

    -- CONVERT
    local CP=Page("Convert")
    Sec(CP,"📄  File .json  (folder: json/)","")
    FileBrowser(CP,"json",".json",function(fname,content)
        local d,e=ParseJSON(content)
        if d then St.buildData=d; Notify("Converted ✓",fname.." → "..#d.blocks.." blocks",3)
        else Notify("Error",e or "?",3) end
    end)
    Sec(CP,"✏  Paste JSON Manual","")
    local jTB,_=BigIn(CP,"Paste Roblox Studio JSON...")
    Btn(CP,"🔄  Convert",C.CYN,function()
        local d,e=ParseJSON(jTB.Text)
        if d then St.buildData=d; Notify("Converted","→ "..#d.blocks.." blocks",3)
        else Notify("Error",e or "?",3) end
    end,"🔄")
    Sec(CP,"🚢  Export Kapalku","")
    Btn(CP,"🚢  Export Kapal → builds/",C.PRP,function()
        task.spawn(function()
            local boat=nil
            for _,c in ipairs(WS:GetDescendants()) do
                if c:IsA("Model") and c.Name:find(LP.Name,1,true) then boat=c; break end
            end
            if not boat then Notify("Error","Kapal tidak ditemukan",3); return end
            local bl={}
            local function sc(p)
                if p:IsA("BasePart") then
                    local bd=FindBlock(p.Name); local pos=p.CFrame.Position
                    bl[#bl+1]={id=bd.id,name=bd.n,position={x=pos.X,y=pos.Y,z=pos.Z},size={x=p.Size.X,y=p.Size.Y,z=p.Size.Z},color={r=math.floor(p.Color.R*255),g=math.floor(p.Color.G*255),b=math.floor(p.Color.B*255)}}
                end
                for _,ch in ipairs(p:GetChildren()) do sc(ch) end
            end
            for _,ch in ipairs(boat:GetChildren()) do sc(ch) end
            local j=Ser(boat.Name,bl)
            if j then
                local nm=boat.Name:gsub(" ","_")
                if WrF("builds/"..nm..".build",j) then Notify("Export ✓","builds/"..nm..".build",4)
                elseif setclipboard then setclipboard(j); Notify("Export","Di-copy",4) end
            end
        end)
    end,"🚢")

    -- IMAGES
    local IP=Page("Images")
    Sec(IP,"🖼  Preview","")
    local pC=New("Frame",{Size=UDim2.new(1,0,0,120),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=IP})
    New("UICorner",{CornerRadius=UDim.new(0,10),Parent=pC}); New("UIStroke",{Color=C.BG3,Thickness=1.5,Parent=pC})
    local pImg=New("ImageLabel",{Size=UDim2.new(0,100,0,100),Position=UDim2.new(0,10,0,10),BackgroundColor3=C.BG0,BorderSizePixel=0,Image="",ScaleType=Enum.ScaleType.Fit,Parent=pC})
    New("UICorner",{CornerRadius=UDim.new(0,8),Parent=pImg}); New("UIStroke",{Color=C.PRP,Thickness=1,Parent=pImg})
    local pIF=New("Frame",{Size=UDim2.new(1,-122,1,-10),Position=UDim2.new(0,118,0,5),BackgroundTransparency=1,Parent=pC})
    local pSt=New("TextLabel",{Size=UDim2.new(1,0,0,15),BackgroundTransparency=1,Text="Belum ada",TextColor3=C.TXT2,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=pIF})
    local pId=New("TextLabel",{Size=UDim2.new(1,0,0,15),Position=UDim2.new(0,0,0,17),BackgroundTransparency=1,Text="ID: —",TextColor3=C.LPRP,Font=Enum.Font.Code,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=pIF})
    Sec(IP,"📥  Asset ID","")
    local asTB,_=InBox(IP,"rbxassetid:// atau ID angka...")
    Btn(IP,"👁  Preview",C.CYN,function()
        local id=asTB.Text; if id=="" then Notify("Error","Masukkan ID!",3); return end
        local nid=id:match("^%d+$") and "rbxassetid://"..id or id
        pcall(function() pImg.Image=nid end)
        pSt.Text="✅ Dimuat"; pSt.TextColor3=C.GRN; pId.Text="ID: "..nid; Notify("Image","OK",2)
    end,"👁")
    Sec(IP,"🎨  Terapkan ke Part","")
    local ptTB,_=InBox(IP,"Nama Part di Workspace...")
    local _,getFace=Dropdown(IP,"Face:",{"Front","Back","Left","Right","Top","Bottom"},"Front")
    Btn(IP,"🖼  Terapkan Decal",C.PRP,function()
        local id=asTB.Text; local pn=ptTB.Text
        if id==""or pn=="" then Notify("Error","Isi keduanya!",3); return end
        local part=WS:FindFirstChild(pn,true)
        if not part then Notify("Error","Part tidak ada",3); return end
        local nid=id:match("^%d+$") and "rbxassetid://"..id or id
        pcall(function() local d=Instance.new("Decal"); d.Texture=nid; d.Face=Enum.NormalId[getFace()] or Enum.NormalId.Front; d.Parent=part end)
        Notify("Decal","Diterapkan ke "..pn,3)
    end,"🖼")

    -- BLOCKS
    local BkP=Page("Blocks")
    Sec(BkP,"📋  Inventory","")
    local _,invL=Card(BkP,"Klik Scan untuk baca inventory BABFT-mu.")
    Btn(BkP,"🔄  Scan Inventory",C.CYN,function()
        local cnt=ScanInventory()
        invL.Text="✅  "..cnt.." jenis block tersedia di inventory-mu"; invL.TextColor3=C.GRN
        InvLbl.Text="Inv: "..cnt.." blocks ✓"
        Notify("Inventory",cnt.." block ditemukan",3)
    end,"🔄")
    Sec(BkP,"📦  159 Blocks","")
    local sTB,_=InBox(BkP,"Cari nama block...")
    local catL={"Semua"}; local cs={}
    for _,b in ipairs(DB) do if not cs[b.cat] then cs[b.cat]=true; catL[#catL+1]=b.cat end end
    local _,getCat=Dropdown(BkP,"Kategori:",catL,"Semua")
    local bF=New("Frame",{Size=UDim2.new(1,0,0,240),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=BkP})
    New("UICorner",{CornerRadius=UDim.new(0,9),Parent=bF})
    local bScr=New("ScrollingFrame",{Size=UDim2.new(1,-4,1,-4),Position=UDim2.new(0,2,0,2),BackgroundTransparency=1,ScrollBarThickness=4,ScrollBarImageColor3=C.PRP,CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=bF})
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=bScr})
    New("UIPadding",{PaddingAll=UDim.new(0,3),Parent=bScr})
    local _,selL=Card(BkP,"Klik block untuk place.")
    local function RBlk(filter,cat)
        for _,c in ipairs(bScr:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        for _,bl in ipairs(DB) do
            local nm=(filter=="" or bl.n:lower():find(filter:lower(),1,true))
            local cm=(cat=="Semua" or bl.cat==cat)
            if nm and cm then
                local inInv=INV[bl.n]~=nil
                local row=New("Frame",{Size=UDim2.new(1,-2,0,26),BackgroundColor3=inInv and Color3.fromRGB(10,20,13) or Color3.fromRGB(11,7,33),BorderSizePixel=0,Parent=bScr})
                New("UICorner",{CornerRadius=UDim.new(0,5),Parent=row})
                if inInv then New("UIStroke",{Color=C.GRN,Thickness=1,Parent=row}) end
                local idb=New("TextLabel",{Size=UDim2.new(0,28,0,14),Position=UDim2.new(0,2,0.5,-7),BackgroundColor3=C.DPRP,BorderSizePixel=0,Text="#"..bl.id,TextColor3=C.LPRP,Font=Enum.Font.GothamBold,TextSize=8,Parent=row})
                New("UICorner",{CornerRadius=UDim.new(0,3),Parent=idb})
                if inInv then
                    local ib=New("TextLabel",{Size=UDim2.new(0,16,0,13),Position=UDim2.new(0,32,0.5,-6.5),BackgroundColor3=C.GRN,BorderSizePixel=0,Text="✓",TextColor3=C.WHT,Font=Enum.Font.GothamBold,TextSize=8,Parent=row})
                    New("UICorner",{CornerRadius=UDim.new(0,3),Parent=ib})
                end
                local nx=inInv and 52 or 33
                New("TextLabel",{Size=UDim2.new(.5,-nx,1,0),Position=UDim2.new(0,nx,0,0),BackgroundTransparency=1,Text=bl.n,TextColor3=inInv and C.GRN or C.TXT0,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=row})
                local cb2=New("TextLabel",{Size=UDim2.new(.24,0,0,12),Position=UDim2.new(.53,0,.5,-6),BackgroundColor3=C.BG0,BorderSizePixel=0,Text=bl.cat,TextColor3=C.TXT2,Font=Enum.Font.Gotham,TextSize=8,Parent=row})
                New("UICorner",{CornerRadius=UDim.new(0,3),Parent=cb2})
                New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=row}).MouseButton1Click:Connect(function()
                    selL.Text=(inInv and "✅ " or "⚠ ")..bl.n.." | "..bl.cat..(inInv and " | ✓ PUNYA" or " | ✗ TIDAK PUNYA")
                    selL.TextColor3=inInv and C.GRN or C.YLW
                    Placer:PlaceOne(bl)
                    Notify("Place",bl.n,2)
                end)
                row.MouseEnter:Connect(function() Tw(row,{BackgroundColor3=C.BG3},.1) end)
                row.MouseLeave:Connect(function() Tw(row,{BackgroundColor3=inInv and Color3.fromRGB(10,20,13) or Color3.fromRGB(11,7,33)},.1) end)
            end
        end
    end
    RBlk("","Semua")
    sTB.Changed:Connect(function(p) if p=="Text" then pcall(function() RBlk(sTB.Text,getCat()) end) end end)
    Btn(BkP,"🔄  Refresh",C.CYN,function() RBlk(sTB.Text,getCat()); Notify("Refresh","OK",2) end,"🔄")

    -- INFO
    local InfoP=Page("Info")
    Sec(InfoP,"ℹ  OxyX v6.0","")
    local aF=New("Frame",{Size=UDim2.new(1,0,0,110),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=InfoP})
    New("UICorner",{CornerRadius=UDim.new(0,10),Parent=aF})
    New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(35,12,85)),ColorSequenceKeypoint.new(1,Color3.fromRGB(10,5,32))}),Rotation=135,Parent=aF})
    local a2=New("ImageLabel",{Size=UDim2.new(0,78,0,78),Position=UDim2.new(0,10,0,16),BackgroundColor3=C.DPRP,BorderSizePixel=0,Image="rbxassetid://7078026274",ScaleType=Enum.ScaleType.Crop,Parent=aF})
    New("UICorner",{CornerRadius=UDim.new(0,12),Parent=a2}); New("UIStroke",{Color=C.PNK,Thickness=2,Parent=a2})
    for i,ln in ipairs({{"OxyX BABFT v6.0 — GALAXY",Enum.Font.GothamBold,14,C.WHT},{"File Browser .build & .json",Enum.Font.GothamBold,11,C.LPRP},{"Auto Build dari Inventory BABFT",Enum.Font.Gotham,10,C.TXT1},{"Tab fix: UDim2 1/6 auto-split",Enum.Font.Gotham,10,C.TXT1},{"EXE: "..EXE,Enum.Font.Gotham,10,C.CYN}}) do
        New("TextLabel",{Size=UDim2.new(1,-103,0,18),Position=UDim2.new(0,100,0,2+(i-1)*20),BackgroundTransparency=1,Text=ln[1],TextColor3=ln[4],Font=ln[2],TextSize=ln[3],TextXAlignment=Enum.TextXAlignment.Left,Parent=aF})
    end
    Sec(InfoP,"⌨  Hotkeys","")
    local hF=New("Frame",{Size=UDim2.new(1,0,0,88),BackgroundColor3=C.BG2,BorderSizePixel=0,Parent=InfoP})
    New("UICorner",{CornerRadius=UDim.new(0,8),Parent=hF})
    New("UIListLayout",{Padding=UDim.new(0,3),Parent=hF}); New("UIPadding",{PaddingAll=UDim.new(0,6),Parent=hF})
    for _,hk in ipairs({{"Right Shift","Toggle UI"},{"Ctrl+B","Quick Build"},{"Ctrl+E","Export kapal"},{"Ctrl+R","Reset build"}}) do
        local r2=New("Frame",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Parent=hF})
        local kb=New("TextLabel",{Size=UDim2.new(0,86,0,16),Position=UDim2.new(0,0,0.5,-8),BackgroundColor3=C.DPRP,BorderSizePixel=0,Text=hk[1],TextColor3=C.LPRP,Font=Enum.Font.Code,TextSize=9,Parent=r2})
        New("UICorner",{CornerRadius=UDim.new(0,4),Parent=kb})
        New("TextLabel",{Size=UDim2.new(1,-94,1,0),Position=UDim2.new(0,92,0,0),BackgroundTransparency=1,Text=hk[2],TextColor3=C.TXT1,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=r2})
    end
    Slider(InfoP,"Transparansi UI",0,70,5,function(v) pcall(function() Inn.BackgroundTransparency=v/100 end) end)
    Btn(InfoP,"📋  Copy GitHub URL",C.CYN,function()
        if setclipboard then setclipboard("https://raw.githubusercontent.com/johsua092-ui/oxyX-sc/refs/heads/main/OxyX_BABFT.lua"); Notify("GitHub","URL di-copy!",3) end
    end,"📋")
    Btn(InfoP,"🔄  Reload",C.PRP,function()
        Notify("Reload","Memuat ulang...",2)
        task.delay(.35,function()
            pcall(function() bconn:Disconnect(); ringConn:Disconnect(); SG:Destroy() end)
            BuildUI()
        end)
    end,"🔄")

    -- ─── DRAG ───────────────────────────────────
    local drg=false; local dO=Vector2.new(0,0)
    HDR.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drg=true; dO=Vector2.new(Mouse.X-MF.AbsolutePosition.X,Mouse.Y-MF.AbsolutePosition.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end end)
    RunService.Heartbeat:Connect(function()
        if drg and MF and MF.Parent then pcall(function()
            local vp=Cam.ViewportSize
            MF.Position=UDim2.new(0,math.clamp(Mouse.X-dO.X,0,vp.X-MF.AbsoluteSize.X),
                0,math.clamp(Mouse.Y-dO.Y,0,vp.Y-MF.AbsoluteSize.Y))
        end) end
    end)

    -- ─── MINIMIZE / CLOSE ───────────────────────
    MinB.MouseButton1Click:Connect(function()
        St.minimized=not St.minimized
        if St.minimized then Tw(MF,{Size=UDim2.new(0,500,0,88)},.28,Enum.EasingStyle.Back); MinB.Text="□"
        else Tw(MF,{Size=UDim2.new(0,500,0,610)},.32,Enum.EasingStyle.Back); MinB.Text="−" end
    end)
    ClsB.MouseButton1Click:Connect(function()
        Tw(MF,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},.22)
        task.delay(.24,function() pcall(function() bconn:Disconnect(); ringConn:Disconnect(); SG:Destroy() end) end)
    end)

    -- ─── HOTKEYS ────────────────────────────────
    UIS.InputBegan:Connect(function(inp,gp)
        if gp then return end
        pcall(function()
            if inp.KeyCode==Enum.KeyCode.RightShift then MF.Visible=not MF.Visible end
            if inp.KeyCode==Enum.KeyCode.B and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                if St.buildData then Placer:Build(St.buildData,function(i,tot,bn) if bn=="DONE" then Notify("Done","Selesai! "..tot,3) end end)
                else Notify("Error","Tidak ada build!",3) end
            end
            if inp.KeyCode==Enum.KeyCode.E and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                task.spawn(function()
                    for _,c in ipairs(WS:GetDescendants()) do
                        if c:IsA("Model") and c.Name:find(LP.Name,1,true) then
                            local bl={}
                            local function sc(p) if p:IsA("BasePart") then local bd=FindBlock(p.Name); local pos=p.CFrame.Position; bl[#bl+1]={id=bd.id,name=bd.n,position={x=pos.X,y=pos.Y,z=pos.Z},size={x=p.Size.X,y=p.Size.Y,z=p.Size.Z},color={r=math.floor(p.Color.R*255),g=math.floor(p.Color.G*255),b=math.floor(p.Color.B*255)}} end for _,ch in ipairs(p:GetChildren()) do sc(ch) end end
                            for _,ch in ipairs(c:GetChildren()) do sc(ch) end
                            local j=Ser(c.Name,bl)
                            if j then local nm=c.Name:gsub(" ","_"); if not WrF("builds/"..nm..".build",j) and setclipboard then setclipboard(j) end; Notify("Export","Kapal ter-export!",3) end; break
                        end
                    end
                end)
            end
            if inp.KeyCode==Enum.KeyCode.R and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                St.buildData=nil; Notify("Reset","Build data dihapus",2)
            end
        end)
    end)

    -- START
    SwitchTab("Build")
    task.spawn(function()
        local cnt=ScanInventory()
        pcall(function()
            invL.Text="✅  "..cnt.." jenis block tersedia"
            invL.TextColor3=C.GRN
            InvLbl.Text="Inv: "..cnt.." blocks ✓"
        end)
    end)
    Notify("OxyX v6.0 🌌","Galaxy Final! Tab fix. Inv build. Astolfo animated. "..EXE,5)
    print("[OxyX v6.0] ✅ | EXE: "..EXE)
end

-- LAUNCH
local ok,err=pcall(BuildUI)
if not ok then
    warn("[OxyX v6.0] ❌ "..tostring(err))
    pcall(function()
        local fg=Instance.new("ScreenGui"); fg.DisplayOrder=99999; fg.IgnoreGuiInset=true; fg.Parent=GP
        local ff=Instance.new("Frame"); ff.Size=UDim2.new(0,350,0,50); ff.Position=UDim2.new(.5,-175,0,20); ff.BackgroundColor3=Color3.fromRGB(25,0,0); ff.BorderSizePixel=0; ff.Parent=fg
        local fl=Instance.new("TextLabel"); fl.Size=UDim2.new(1,-8,1,0); fl.Position=UDim2.new(0,4,0,0); fl.BackgroundTransparency=1; fl.Text="[OxyX] ERR: "..tostring(err); fl.TextColor3=Color3.fromRGB(255,80,80); fl.Font=Enum.Font.Gotham; fl.TextSize=11; fl.TextWrapped=true; fl.Parent=ff
        game:GetService("Debris"):AddItem(fg,12)
    end)
end
