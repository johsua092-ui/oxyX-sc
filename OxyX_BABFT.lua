-- OxyX BABFT v11 - Clean rewrite, ASCII only
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local Http=game:GetService("HttpService")
local WS=game:GetService("Workspace")
local RS=game:GetService("ReplicatedStorage")
local GP; pcall(function() GP=game:GetService("CoreGui") end)
if not GP then GP=Players.LocalPlayer.PlayerGui end
local LP=Players.LocalPlayer
local PGui=LP:WaitForChild("PlayerGui")
local Mouse=LP:GetMouse()
local Cam=WS.CurrentCamera

local c0=Color3.fromRGB
local BG0=c0(5,3,18) local BG1=c0(12,7,35) local BG2=c0(20,12,55) local BG3=c0(32,20,75)
local PRP=c0(140,44,230) local DPRP=c0(60,0,120) local LPRP=c0(190,110,255)
local CYN=c0(0,205,255) local PNK=c0(255,95,180) local GLD=c0(255,200,55)
local GRN=c0(70,225,115) local RED=c0(255,65,65) local YLW=c0(255,210,50)
local WHT=c0(255,255,255) local TXT0=c0(238,228,255) local TXT1=c0(165,148,215) local TXT2=c0(90,72,138)

local function N(cls,props)
    local ok,i=pcall(Instance.new,cls); if not ok then return nil end
    for k,v in pairs(props) do if k~="Parent" then pcall(function() i[k]=v end) end end
    if props.Parent then pcall(function() i.Parent=props.Parent end) end
    return i
end
local function Tw(o,g,t,es)
    if not o or not o.Parent then return end
    pcall(function() TweenService:Create(o,TweenInfo.new(t or .25,es or Enum.EasingStyle.Quad,Enum.EasingDirection.Out),g):Play() end)
end
local function Notify(title,msg,dur)
    dur=dur or 3
    task.spawn(function() pcall(function()
        local sg=N("ScreenGui",{Name="OxN"..tick(),DisplayOrder=99999,IgnoreGuiInset=true,ResetOnSpawn=false,Parent=GP})
        local f=N("Frame",{Size=UDim2.new(0,280,0,60),Position=UDim2.new(1,10,1,-72),BackgroundColor3=BG1,BorderSizePixel=0,Parent=sg})
        N("UICorner",{CornerRadius=UDim.new(0,10),Parent=f})
        N("UIStroke",{Color=PRP,Thickness=1.5,Parent=f})
        N("TextLabel",{Size=UDim2.new(1,-10,0,20),Position=UDim2.new(0,8,0,4),BackgroundTransparency=1,Text="* "..title,TextColor3=LPRP,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        N("TextLabel",{Size=UDim2.new(1,-10,0,28),Position=UDim2.new(0,8,0,24),BackgroundTransparency=1,Text=msg,TextColor3=TXT1,Font=Enum.Font.Gotham,TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        Tw(f,{Position=UDim2.new(1,-290,1,-72)},0.3)
        task.delay(dur,function() pcall(function() Tw(f,{Position=UDim2.new(1,10,1,-72)},0.25) task.wait(0.3) sg:Destroy() end) end)
    end) end)
end

local DB={
    {id=1,n="Back Wheel",cat="Wheels"},{id=2,n="Balloon Block",cat="Special"},{id=3,n="Bar",cat="Structure"},
    {id=4,n="Big Cannon",cat="Weapons"},{id=5,n="Big Switch",cat="Electronics"},{id=6,n="Blue Candy",cat="Candy"},
    {id=7,n="Boat Motor",cat="Propulsion"},{id=8,n="Bouncy Block",cat="Special"},{id=9,n="Boxing Glove",cat="Weapons"},
    {id=10,n="Bread",cat="Food"},{id=11,n="Brick Block",cat="Structure"},{id=12,n="Bundles of Potions",cat="Special"},
    {id=13,n="Button",cat="Electronics"},{id=14,n="Cake",cat="Food"},{id=15,n="Camera",cat="Special"},
    {id=16,n="Candle",cat="Decoration"},{id=17,n="Candy Cane Block",cat="Candy"},{id=18,n="Candy Cane Rod",cat="Candy"},
    {id=19,n="Cannon",cat="Weapons"},{id=20,n="Car Seat",cat="Seats"},{id=21,n="Chair",cat="Seats"},
    {id=22,n="Classic Firework",cat="Fireworks"},{id=23,n="Coal Block",cat="Structure"},{id=24,n="Common Chest Block",cat="Chests"},
    {id=25,n="Concrete Block",cat="Structure"},{id=26,n="Concrete Rod",cat="Structure"},{id=27,n="Cookie Back Wheel",cat="Wheels"},
    {id=28,n="Cookie Front Wheel",cat="Wheels"},{id=29,n="Corner Wedge",cat="Structure"},{id=30,n="Delay Block",cat="Electronics"},
    {id=31,n="Dome Camera",cat="Special"},{id=32,n="Door",cat="Structure"},{id=33,n="Dragon Egg",cat="Special"},
    {id=34,n="Dragon Harpoon",cat="Weapons"},{id=35,n="Dual Candy Cane Harpoon",cat="Weapons"},{id=36,n="Dynamite",cat="Weapons"},
    {id=37,n="Easter Jetpack",cat="Propulsion"},{id=38,n="Egg Cannon",cat="Weapons"},{id=39,n="Epic Chest Block",cat="Chests"},
    {id=40,n="Fabric Block",cat="Structure"},{id=41,n="Firework 1",cat="Fireworks"},{id=42,n="Firework 2",cat="Fireworks"},
    {id=43,n="Firework 3",cat="Fireworks"},{id=44,n="Firework 4",cat="Fireworks"},{id=45,n="Flag",cat="Decoration"},
    {id=46,n="Front Wheel",cat="Wheels"},{id=47,n="Gameboard",cat="Special"},{id=48,n="Glass Block",cat="Structure"},
    {id=49,n="Glue",cat="Electronics"},{id=50,n="Gold Block",cat="Structure"},{id=51,n="Golden Harpoon",cat="Weapons"},
    {id=52,n="Grass Block",cat="Structure"},{id=53,n="Harpoon",cat="Weapons"},{id=54,n="Hatch",cat="Structure"},
    {id=55,n="Heart",cat="Decoration"},{id=56,n="Helm",cat="Special"},{id=57,n="Hinge",cat="Electronics"},
    {id=58,n="Huge Back Wheel",cat="Wheels"},{id=59,n="Huge Front Wheel",cat="Wheels"},{id=60,n="Huge Wheel",cat="Wheels"},
    {id=61,n="I-Beam",cat="Structure"},{id=62,n="Ice Block",cat="Structure"},{id=63,n="Jet Turbine",cat="Propulsion"},
    {id=64,n="Jetpack",cat="Propulsion"},{id=65,n="Lamp",cat="Decoration"},{id=66,n="Large Treasure",cat="Treasure"},
    {id=67,n="Laser Launcher",cat="Weapons"},{id=68,n="Legendary Chest Block",cat="Chests"},{id=69,n="Lever",cat="Electronics"},
    {id=70,n="Life Preserver",cat="Special"},{id=71,n="Light Bulb",cat="Decoration"},{id=72,n="Locked Door",cat="Structure"},
    {id=73,n="Magnet",cat="Special"},{id=74,n="Marble Block",cat="Structure"},{id=75,n="Marble Rod",cat="Structure"},
    {id=76,n="Mast",cat="Structure"},{id=77,n="Master Builder Trophy",cat="Trophies"},{id=78,n="Medium Treasure",cat="Treasure"},
    {id=79,n="Mega Thruster",cat="Propulsion"},{id=80,n="Metal Block",cat="Structure"},{id=81,n="Metal Rod",cat="Structure"},
    {id=82,n="Mini Gun",cat="Weapons"},{id=83,n="Mounted Bow",cat="Weapons"},{id=84,n="Mounted Candy Cane Sword",cat="Weapons"},
    {id=85,n="Mounted Cannon",cat="Weapons"},{id=86,n="Mounted Flintlocks",cat="Weapons"},{id=87,n="Mounted Knight Sword",cat="Weapons"},
    {id=88,n="Mounted Sword",cat="Weapons"},{id=89,n="Mounted Wizard Staff",cat="Weapons"},{id=90,n="Music Note",cat="Decoration"},
    {id=91,n="Mystery Box",cat="Special"},{id=92,n="Neon Block",cat="Structure"},{id=93,n="Obsidian Block",cat="Structure"},
    {id=94,n="Orange Candy",cat="Candy"},{id=95,n="Parachute Block",cat="Special"},{id=96,n="Peppermint Back Wheel",cat="Wheels"},
    {id=97,n="Peppermint Front Wheel",cat="Wheels"},{id=98,n="Pilot Seat",cat="Seats"},{id=99,n="Pine Tree",cat="Decoration"},
    {id=100,n="Pink Candy",cat="Candy"},{id=101,n="Piston",cat="Electronics"},{id=102,n="Plastic Block",cat="Structure"},
    {id=103,n="Plushie 1",cat="Decoration"},{id=104,n="Plushie 2",cat="Decoration"},{id=105,n="Plushie 3",cat="Decoration"},
    {id=106,n="Plushie 4",cat="Decoration"},{id=107,n="Portal",cat="Special"},{id=108,n="Pumpkin",cat="Decoration"},
    {id=109,n="Purple Candy",cat="Candy"},{id=110,n="Rare Chest Block",cat="Chests"},{id=111,n="Red Candy",cat="Candy"},
    {id=112,n="Rope",cat="Structure"},{id=113,n="Rusted Block",cat="Structure"},{id=114,n="Rusted Rod",cat="Structure"},
    {id=115,n="Sand Block",cat="Structure"},{id=116,n="Seat",cat="Seats"},{id=117,n="Servo",cat="Electronics"},
    {id=118,n="Shield Generator",cat="Special"},{id=119,n="Sign",cat="Decoration"},{id=120,n="Small Treasure",cat="Treasure"},
    {id=121,n="Smooth Wood Block",cat="Structure"},{id=122,n="Snowball Launcher",cat="Weapons"},{id=123,n="Soccer Ball",cat="Special"},
    {id=124,n="Sonic Jet Turbine",cat="Propulsion"},{id=125,n="Spike Trap",cat="Weapons"},{id=126,n="Spooky Thruster",cat="Propulsion"},
    {id=127,n="Star",cat="Decoration"},{id=128,n="Star Balloon Block",cat="Special"},{id=129,n="Star Jetpack",cat="Propulsion"},
    {id=130,n="Steampunk Jetpack",cat="Propulsion"},{id=131,n="Step",cat="Structure"},{id=132,n="Stone Block",cat="Structure"},
    {id=133,n="Stone Rod",cat="Structure"},{id=134,n="Suspension",cat="Electronics"},{id=135,n="Switch",cat="Electronics"},
    {id=136,n="Throne",cat="Seats"},{id=137,n="Thruster",cat="Propulsion"},{id=138,n="Titanium Block",cat="Structure"},
    {id=139,n="Titanium Rod",cat="Structure"},{id=140,n="TNT",cat="Weapons"},{id=141,n="Torch",cat="Decoration"},
    {id=142,n="Toy Block",cat="Structure"},{id=143,n="Treasure Chest",cat="Treasure"},{id=144,n="Trophy 1st",cat="Trophies"},
    {id=145,n="Trophy 2nd",cat="Trophies"},{id=146,n="Trophy 3rd",cat="Trophies"},{id=147,n="Truss",cat="Structure"},
    {id=148,n="Ultra Boat Motor",cat="Propulsion"},{id=149,n="Ultra Jetpack",cat="Propulsion"},{id=150,n="Ultra Thruster",cat="Propulsion"},
    {id=151,n="Uncommon Chest Block",cat="Chests"},{id=152,n="Wedge",cat="Structure"},{id=153,n="Wheel",cat="Wheels"},
    {id=154,n="Window",cat="Structure"},{id=155,n="Winter Boat Motor",cat="Propulsion"},{id=156,n="Winter Jet Turbine",cat="Propulsion"},
    {id=157,n="Winter Thruster",cat="Propulsion"},{id=158,n="Wood Block",cat="Structure"},{id=159,n="Wood Rod",cat="Structure"},
}
local DBlo={}; for _,b in ipairs(DB) do DBlo[b.n:lower()]=b end
local function FindBlock(n)
    if not n then return DB[158] end; local lo=n:lower()
    if DBlo[lo] then return DBlo[lo] end
    for k,v in pairs(DBlo) do if k:find(lo,1,true) or lo:find(k,1,true) then return v end end
    return DB[158]
end

-- Inventory: all 159 blocks available + scan BuildGui for button refs
local INV={}
for _,b in ipairs(DB) do INV[b.n]={block=b} end
local function ScanBuildGui()
    local bg=PGui:FindFirstChild("BuildGui"); if not bg then return end
    for _,obj in ipairs(bg:GetDescendants()) do
        if obj:IsA("ImageButton") or obj:IsA("TextButton") then
            local bn=obj.Name:gsub("%s+",""):lower()
            for _,b in ipairs(DB) do
                if b.n:gsub("%s+",""):lower()==bn then
                    INV[b.n]=INV[b.n] or {block=b}; INV[b.n].btn=obj; break
                end
            end
        end
    end
end

-- Place block
local function PlaceBlock(blockName,idx)
    idx=idx or 0
    local entry=INV[blockName]
    if entry and entry.btn and entry.btn.Parent then
        pcall(function() entry.btn.MouseButton1Click:Fire() end)
    else
        local bg=PGui:FindFirstChild("BuildGui")
        if bg then
            local clean=blockName:gsub("%s+",""):lower()
            for _,obj in ipairs(bg:GetDescendants()) do
                if (obj:IsA("ImageButton") or obj:IsA("TextButton")) and obj.Name:gsub("%s+",""):lower()==clean then
                    pcall(function() obj.MouseButton1Click:Fire() end); break
                end
            end
        end
    end
    task.wait(0.05)
    local ttg=PGui:FindFirstChild("TabletToolGui")
    if ttg then local pb=ttg:FindFirstChild("Place"); if pb then pcall(function() pb.MouseButton1Click:Fire() end) end end
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local cf=hrp and (hrp.CFrame*CFrame.new(((idx%8)-3.5)*4,0,-5-math.floor(idx/8)*4)) or CFrame.new(idx*4,5,0)
    pcall(function() RS.BuildingParts.TrowelTool.OperationRF:InvokeServer("Place",blockName,cf) end)
end

-- Parse build
local function ParseBuild(txt)
    if not txt or txt:match("^%s*$") then return nil,"File kosong" end
    local ok,d=pcall(function() return Http:JSONDecode(txt) end)
    if not ok or type(d)~="table" then return nil,"Bukan JSON valid" end
    if d.blocks and #d.blocks>0 then return d end
    if d[1] and (d[1].name or d[1].Name) then
        local bl={}; for _,bi in ipairs(d) do bl[#bl+1]={name=bi.name or bi.Name or "Wood Block",position=bi.position or {x=0,y=5,z=0}} end
        return {version="1.0",name="Import",author=LP.Name,blocks=bl,welds={}}
    end
    return nil,"Format tidak dikenali"
end

-- Shapes
local function MakePlatform(bn,w,l) local bl={} for x=0,w-1 do for z=0,l-1 do bl[#bl+1]={name=bn,position={x=x*4,y=0,z=z*2}} end end return {version="1.0",name="Platform_"..w.."x"..l,author=LP.Name,blocks=bl,welds={}} end
local function MakeBall(bn,r) local bl={} for x=-r,r do for y=-r,r do for z=-r,r do if x*x+y*y+z*z<=r*r then bl[#bl+1]={name=bn,position={x=x*2,y=y*2,z=z*2}} end end end end return {version="1.0",name="Ball_r"..r,author=LP.Name,blocks=bl,welds={}} end
local function MakeHull(bn,len,w) local bl={} for x=0,len-1 do for z=0,w-1 do bl[#bl+1]={name=bn,position={x=x*4,y=0,z=z*2}} end end for x=0,len-1 do for y=1,3 do bl[#bl+1]={name=bn,position={x=x*4,y=y*2,z=0}} bl[#bl+1]={name=bn,position={x=x*4,y=y*2,z=(w-1)*2}} end end return {version="1.0",name="BoatHull",author=LP.Name,blocks=bl,welds={}} end

-- Placer
local Placer={delay=0.3,running=false,placed=0,failed=0}
function Placer:Build(data,cb)
    if self.running then Notify("OxyX","Build sudah jalan!",2); return end
    if not data then return end
    self.running=true; self.placed=0; self.failed=0
    local total=#data.blocks
    task.spawn(function()
        Notify("OxyX","Mulai "..total.." blocks",2)
        for i,bi in ipairs(data.blocks) do
            if not self.running then break end
            local bd=FindBlock(bi.name or bi.n or "Wood Block")
            PlaceBlock(bd.n,i-1); self.placed=self.placed+1
            if cb then pcall(cb,i,total,bd.n) end
            task.wait(self.delay)
        end
        self.running=false
        Notify("OxyX","Selesai! "..self.placed.."/"..total,4)
        if cb then pcall(cb,total,total,"DONE") end
    end)
end
function Placer:Stop() self.running=false; Notify("OxyX","Dihentikan",2) end

-- File helpers
local function MkDir(f) if makefolder then pcall(function() if not isfolder(f) then makefolder(f) end end) end end
local function ListFiles(folder,ext) local out={} if not listfiles then return out end pcall(function() for _,p in ipairs(listfiles(folder)) do local fn=p:match("([^/\\]+)$") or p if fn:lower():sub(-#ext)==ext:lower() then out[#out+1]={name=fn,path=p} end end end) return out end
local function ReadFile(path) if readfile then local ok,t=pcall(readfile,path); if ok and t then return t end end end
local function WriteFile(path,c) if writefile then pcall(writefile,path,c); return true end return false end

local St={tab="Build",buildData=nil,minimized=false,shapeType="Platform",shapeBlock="Wood Block",shapeW=5,shapeL=8,shapeR=3}

-- Clean old GUI
pcall(function() local old=GP:FindFirstChild("OxyX_v11"); if old then old:Destroy() end end)
MkDir("builds"); MkDir("json"); ScanBuildGui()

-- Main GUI
local SG=N("ScreenGui",{Name="OxyX_v11",DisplayOrder=9999,IgnoreGuiInset=true,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=GP})
local MF=N("Frame",{Size=UDim2.new(0,500,0,620),Position=UDim2.new(0.5,-250,0.5,-310),BackgroundColor3=BG0,BorderSizePixel=0,Parent=SG})
N("UICorner",{CornerRadius=UDim.new(0,16),Parent=MF})

-- Animated border
local BordF=N("Frame",{Size=UDim2.new(1,8,1,8),Position=UDim2.new(0,-4,0,-4),BackgroundColor3=PRP,BorderSizePixel=0,ZIndex=0,Parent=MF})
N("UICorner",{CornerRadius=UDim.new(0,20),Parent=BordF})
local BG=N("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,PRP),ColorSequenceKeypoint.new(0.33,CYN),ColorSequenceKeypoint.new(0.66,PNK),ColorSequenceKeypoint.new(1,PRP)}),Rotation=0,Parent=BordF})
local Inn=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=BG0,BorderSizePixel=0,ZIndex=1,Parent=MF})
N("UICorner",{CornerRadius=UDim.new(0,16),Parent=Inn})
local ba=0
RunService.Heartbeat:Connect(function(dt) ba=(ba+dt*45)%360; pcall(function() BG.Rotation=ba end) end)

-- Stars
for i=1,22 do
    local sz=math.random(1,3)
    local s=N("Frame",{Size=UDim2.new(0,sz,0,sz),Position=UDim2.new(math.random()*0.94,0,math.random()*0.94,0),BackgroundColor3=i%3==0 and CYN or i%2==0 and LPRP or WHT,BackgroundTransparency=math.random()*0.5+0.2,BorderSizePixel=0,ZIndex=2,Parent=Inn})
    N("UICorner",{CornerRadius=UDim.new(1,0),Parent=s})
    task.spawn(function() while s and s.Parent do task.wait(1+math.random()*2) pcall(function() Tw(s,{BackgroundTransparency=0.9},0.4) task.wait(0.4) Tw(s,{BackgroundTransparency=math.random()*0.4+0.1},0.4) end) end end)
end

-- Header
local HDR=N("Frame",{Size=UDim2.new(1,0,0,88),BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=10,Parent=Inn})
N("UICorner",{CornerRadius=UDim.new(0,16),Parent=HDR})
N("Frame",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,-20),BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=10,Parent=HDR})

-- Astolfo
local AF=N("Frame",{Size=UDim2.new(0,70,0,70),Position=UDim2.new(0,12,0,9),BackgroundColor3=DPRP,BorderSizePixel=0,ZIndex=15,Parent=HDR})
N("UICorner",{CornerRadius=UDim.new(0,14),Parent=AF})
local AStk=N("UIStroke",{Color=PNK,Thickness=3,Parent=AF})
local AI1=N("ImageLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Image="rbxassetid://7078026274",ScaleType=Enum.ScaleType.Crop,ZIndex=16,Parent=AF})
N("UICorner",{CornerRadius=UDim.new(0,12),Parent=AI1})
local AI2=N("ImageLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Image="rbxassetid://11832808662",ScaleType=Enum.ScaleType.Crop,ImageTransparency=1,ZIndex=17,Parent=AF})
N("UICorner",{CornerRadius=UDim.new(0,12),Parent=AI2})
local aImgs={"rbxassetid://7078026274","rbxassetid://11832808662","rbxassetid://6423102987"}; local aI=1
task.spawn(function() while AI1 and AI1.Parent do aI=aI%#aImgs+1; pcall(function() AI2.Image=aImgs[aI]; AI2.ImageTransparency=1; Tw(AI2,{ImageTransparency=0},0.5,Enum.EasingStyle.Sine); Tw(AI1,{ImageTransparency=1},0.5,Enum.EasingStyle.Sine) end); task.wait(0.6); pcall(function() AI1.Image=aImgs[aI]; AI1.ImageTransparency=0; AI2.ImageTransparency=1 end); task.wait(1.4) end end)
task.spawn(function() local gc={PNK,CYN,LPRP,GLD,PRP}; local gi=1; while AStk and AStk.Parent do gi=gi%#gc+1; Tw(AStk,{Color=gc[gi]},1,Enum.EasingStyle.Sine); task.wait(1.1) end end)

-- Title
N("TextLabel",{Size=UDim2.new(0,300,0,36),Position=UDim2.new(0,92,0,9),BackgroundTransparency=1,Text="OxyX",TextColor3=WHT,Font=Enum.Font.GothamBold,TextScaled=true,ZIndex=15,Parent=HDR})
N("TextLabel",{Size=UDim2.new(0,300,0,16),Position=UDim2.new(0,92,0,48),BackgroundTransparency=1,Text="Build A Boat - Galaxy Edition v11",TextColor3=TXT1,Font=Enum.Font.Gotham,TextScaled=true,ZIndex=15,Parent=HDR})
N("TextLabel",{Size=UDim2.new(0,300,0,13),Position=UDim2.new(0,92,0,67),BackgroundTransparency=1,Text="159 blocks ready",TextColor3=GRN,Font=Enum.Font.GothamBold,TextSize=10,ZIndex=15,Parent=HDR})

local MinB=N("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-66,0,12),BackgroundColor3=BG3,BorderSizePixel=0,Text="-",TextColor3=YLW,Font=Enum.Font.GothamBold,TextSize=22,AutoButtonColor=false,ZIndex=20,Parent=HDR})
N("UICorner",{CornerRadius=UDim.new(0,8),Parent=MinB}); N("UIStroke",{Color=YLW,Thickness=1.5,Parent=MinB})
local ClsB=N("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-34,0,12),BackgroundColor3=BG3,BorderSizePixel=0,Text="X",TextColor3=RED,Font=Enum.Font.GothamBold,TextSize=14,AutoButtonColor=false,ZIndex=20,Parent=HDR})
N("UICorner",{CornerRadius=UDim.new(0,8),Parent=ClsB}); N("UIStroke",{Color=RED,Thickness=1.5,Parent=ClsB})

-- Tab bar - 5 tabs, 500px window
local TabBG=N("Frame",{Size=UDim2.new(1,0,0,38),Position=UDim2.new(0,0,0,88),BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=10,Parent=Inn})
N("Frame",{Size=UDim2.new(1,-12,0,1),Position=UDim2.new(0,6,0,0),BackgroundColor3=BG3,BorderSizePixel=0,Parent=TabBG})

-- Content
local Cont=N("ScrollingFrame",{Size=UDim2.new(1,0,1,-160),Position=UDim2.new(0,0,0,126),BackgroundColor3=BG0,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=PRP,CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=5,Parent=Inn})

-- Progress
local PBar=N("Frame",{Size=UDim2.new(1,-20,0,8),Position=UDim2.new(0,10,0,128),BackgroundColor3=BG3,BorderSizePixel=0,Visible=false,ZIndex=12,Parent=Inn})
N("UICorner",{CornerRadius=UDim.new(1,0),Parent=PBar})
local PFill=N("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=GRN,BorderSizePixel=0,Parent=PBar})
N("UICorner",{CornerRadius=UDim.new(1,0),Parent=PFill})
local PLbl=N("TextLabel",{Size=UDim2.new(1,-20,0,12),Position=UDim2.new(0,10,0,138),BackgroundTransparency=1,Text="",TextColor3=TXT1,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Visible=false,ZIndex=12,Parent=Inn})

-- Status bar
local SBar=N("Frame",{Size=UDim2.new(1,0,0,34),Position=UDim2.new(0,0,1,-34),BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=10,Parent=Inn})
N("UICorner",{CornerRadius=UDim.new(0,16),Parent=SBar})
N("Frame",{Size=UDim2.new(1,0,0,18),BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=10,Parent=SBar})
local StatLbl=N("TextLabel",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text="Ready - OxyX v11",TextColor3=TXT1,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=15,Parent=SBar})

-- Widget helpers
local Pages={} local TabBtns={}
local function MkPage(name) local p=N("Frame",{Name="P_"..name,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,Parent=Cont}) N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=p}) N("UIPadding",{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,14),Parent=p}) Pages[name]=p; return p end
local function Sec(par,txt) local f=N("Frame",{Size=UDim2.new(1,0,0,26),BackgroundColor3=BG2,BorderSizePixel=0,Parent=par}) N("UICorner",{CornerRadius=UDim.new(0,7),Parent=f}) local bar=N("Frame",{Size=UDim2.new(0,4,0.7,0),Position=UDim2.new(0,0,0.15,0),BackgroundColor3=PRP,BorderSizePixel=0,Parent=f}) N("UICorner",{CornerRadius=UDim.new(1,0),Parent=bar}) N("TextLabel",{Size=UDim2.new(1,-14,1,0),Position=UDim2.new(0,11,0,0),BackgroundTransparency=1,Text=txt,TextColor3=LPRP,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}) end
local function Btn(par,txt,col,cb) col=col or PRP; local r,g,b=col.R*255,col.G*255,col.B*255; local dk=c0(math.floor(r*.18),math.floor(g*.18),math.floor(b*.18)); local md=c0(math.floor(r*.35),math.floor(g*.35),math.floor(b*.35)); local btn=N("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=dk,BorderSizePixel=0,Text=txt,TextColor3=TXT0,Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,Parent=par}) N("UICorner",{CornerRadius=UDim.new(0,9),Parent=btn}) N("UIStroke",{Color=col,Thickness=1.5,Parent=btn}) btn.MouseEnter:Connect(function() Tw(btn,{BackgroundColor3=md},0.12) end) btn.MouseLeave:Connect(function() Tw(btn,{BackgroundColor3=dk},0.12) end) btn.MouseButton1Down:Connect(function() Tw(btn,{BackgroundColor3=col},0.07) end) btn.MouseButton1Up:Connect(function() Tw(btn,{BackgroundColor3=md},0.1) end) if cb then btn.MouseButton1Click:Connect(cb) end; return btn end
local function Card(par,txt) local f=N("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=BG2,BorderSizePixel=0,Parent=par}) N("UICorner",{CornerRadius=UDim.new(0,8),Parent=f}) local l=N("TextLabel",{Size=UDim2.new(1,-14,1,0),Position=UDim2.new(0,7,0,0),BackgroundTransparency=1,Text=txt,TextColor3=TXT1,Font=Enum.Font.Gotham,TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); return f,l end
local function TInput(par,ph,h) local f=N("Frame",{Size=UDim2.new(1,0,0,h or 33),BackgroundColor3=BG2,BorderSizePixel=0,Parent=par}) N("UICorner",{CornerRadius=UDim.new(0,8),Parent=f}); local st=N("UIStroke",{Color=BG3,Thickness=1.5,Parent=f}); local tb=N("TextBox",{Size=UDim2.new(1,-14,1,0),Position=UDim2.new(0,7,0,0),BackgroundTransparency=1,Text="",PlaceholderText=ph or "",PlaceholderColor3=TXT2,TextColor3=TXT0,Font=Enum.Font.Gotham,TextSize=12,ClearTextOnFocus=false,Parent=f}); tb.Focused:Connect(function() pcall(function() Tw(st,{Color=PRP},0.2) end) end); tb.FocusLost:Connect(function() pcall(function() Tw(st,{Color=BG3},0.2) end) end); return tb end
local function BigIn(par,ph) local f=N("Frame",{Size=UDim2.new(1,0,0,85),BackgroundColor3=BG2,BorderSizePixel=0,Parent=par}) N("UICorner",{CornerRadius=UDim.new(0,8),Parent=f}); N("UIStroke",{Color=BG3,Thickness=1.5,Parent=f}); local tb=N("TextBox",{Size=UDim2.new(1,-10,1,-6),Position=UDim2.new(0,5,0,3),BackgroundTransparency=1,Text="",PlaceholderText=ph or "",PlaceholderColor3=TXT2,TextColor3=TXT0,Font=Enum.Font.Code,TextSize=10,MultiLine=true,ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Parent=f}); return tb end
local function Sld(par,lbl,mn,mx,def,cb) local v=def; local f=N("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=BG2,BorderSizePixel=0,Parent=par}); N("UICorner",{CornerRadius=UDim.new(0,8),Parent=f}); N("TextLabel",{Size=UDim2.new(0.72,0,0,16),Position=UDim2.new(0,7,0,4),BackgroundTransparency=1,Text=lbl,TextColor3=TXT0,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); local vl=N("TextLabel",{Size=UDim2.new(0.28,0,0,16),Position=UDim2.new(0.72,0,0,4),BackgroundTransparency=1,Text=tostring(v),TextColor3=CYN,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Parent=f}); local trk=N("Frame",{Size=UDim2.new(1,-14,0,6),Position=UDim2.new(0,7,0,28),BackgroundColor3=BG0,BorderSizePixel=0,Parent=f}); N("UICorner",{CornerRadius=UDim.new(1,0),Parent=trk}); local fill=N("Frame",{Size=UDim2.new((v-mn)/(mx-mn),0,1,0),BackgroundColor3=PRP,BorderSizePixel=0,Parent=trk}); N("UICorner",{CornerRadius=UDim.new(1,0),Parent=fill}); local kn=N("Frame",{Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new((v-mn)/(mx-mn),0,0.5,0),BackgroundColor3=WHT,BorderSizePixel=0,ZIndex=10,Parent=trk}); N("UICorner",{CornerRadius=UDim.new(1,0),Parent=kn}); N("UIStroke",{Color=PRP,Thickness=2,Parent=kn}); local drag=false; N("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0,18),BackgroundTransparency=1,Text="",ZIndex=20,Parent=f}).MouseButton1Down:Connect(function() drag=true end); UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end); RunService.Heartbeat:Connect(function() if not drag then return end pcall(function() local rx=math.clamp((Mouse.X-trk.AbsolutePosition.X)/trk.AbsoluteSize.X,0,1); v=math.floor(mn+rx*(mx-mn)); vl.Text=tostring(v); fill.Size=UDim2.new(rx,0,1,0); kn.Position=UDim2.new(rx,0,0.5,0); if cb then cb(v) end end) end) end
local function FileBrowser(par,folder,ext,onLoad)
    local wrap=N("Frame",{Size=UDim2.new(1,0,0,160),BackgroundColor3=BG2,BorderSizePixel=0,Parent=par}); N("UICorner",{CornerRadius=UDim.new(0,10),Parent=wrap}); N("UIStroke",{Color=PRP,Thickness=1.5,Parent=wrap})
    local hdr=N("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=PRP,BorderSizePixel=0,Parent=wrap}); N("UICorner",{CornerRadius=UDim.new(0,10),Parent=hdr}); N("Frame",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-14),BackgroundColor3=PRP,BorderSizePixel=0,Parent=hdr})
    N("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.new(0,9,0,0),BackgroundTransparency=1,Text=folder.."/ ["..ext.."]",TextColor3=WHT,Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=hdr})
    local rb=N("TextButton",{Size=UDim2.new(0,64,0,20),Position=UDim2.new(1,-68,0.5,-10),BackgroundColor3=DPRP,BorderSizePixel=0,Text="Refresh",TextColor3=WHT,Font=Enum.Font.GothamBold,TextSize=10,AutoButtonColor=false,Parent=hdr}); N("UICorner",{CornerRadius=UDim.new(0,5),Parent=rb})
    local ls=N("ScrollingFrame",{Size=UDim2.new(1,-6,0,125),Position=UDim2.new(0,3,0,31),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=PRP,CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=wrap}); N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=ls}); N("UIPadding",{PaddingAll=UDim.new(0,3),Parent=ls})
    local function Ref() for _,c in ipairs(ls:GetChildren()) do if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end end local files=ListFiles(folder,ext) if #files==0 then N("TextLabel",{Size=UDim2.new(1,0,0,40),BackgroundTransparency=1,Text="Tidak ada file "..ext.." di "..folder.."/",TextColor3=TXT2,Font=Enum.Font.Gotham,TextSize=11,TextWrapped=true,Parent=ls}); return end for _,f in ipairs(files) do local row=N("Frame",{Size=UDim2.new(1,-2,0,28),BackgroundColor3=c0(13,7,38),BorderSizePixel=0,Parent=ls}); N("UICorner",{CornerRadius=UDim.new(0,6),Parent=row}); N("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Text=f.name,TextColor3=TXT0,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=row}); local lb=N("TextButton",{Size=UDim2.new(0,50,0,18),Position=UDim2.new(1,-54,0.5,-9),BackgroundColor3=PRP,BorderSizePixel=0,Text="Load",TextColor3=WHT,Font=Enum.Font.GothamBold,TextSize=10,AutoButtonColor=false,Parent=row}); N("UICorner",{CornerRadius=UDim.new(0,5),Parent=lb}); local function doLoad() local content=ReadFile(f.path) or ReadFile(folder.."/"..f.name); if content and onLoad then onLoad(f.name,content) end end; lb.MouseButton1Click:Connect(doLoad); row.MouseEnter:Connect(function() Tw(row,{BackgroundColor3=BG3},0.1) end); row.MouseLeave:Connect(function() Tw(row,{BackgroundColor3=c0(13,7,38)},0.1) end) end end
    Ref(); rb.MouseButton1Click:Connect(function() Ref(); Notify("OxyX","Refreshed",2) end)
end

-- Pages
local BP=MkPage("Build")
Sec(BP,"Load file .build")
FileBrowser(BP,"builds",".build",function(fname,content)
    local d,e=ParseBuild(content)
    if d then St.buildData=d; Notify("Loaded",fname.." | "..#d.blocks.." blocks",3); StatLbl.Text="Loaded: "..fname.." | "..#d.blocks.." blocks"
    else Notify("Error",e or "Gagal",3) end
end)
Sec(BP,"Paste JSON manual")
local pasteTB=BigIn(BP,'{"blocks":[{"name":"Wood Block"}]}')
Btn(BP,"Parse & Load",CYN,function()
    local d,e=ParseBuild(pasteTB.Text)
    if d then St.buildData=d; Notify("Loaded",d.name.." | "..#d.blocks.." blocks",3)
    else Notify("Error",e or "Gagal",3) end
end)
Sec(BP,"Quick Test")
Btn(BP,"Generate Test 5x5 Platform",BG3,function()
    St.buildData=MakePlatform("Wood Block",5,5)
    Notify("Test","5x5 platform ready (25 blocks)",3); StatLbl.Text="Test: 5x5 (25 blocks)"
end)
local _,bStat=Card(BP,"Belum ada data build")
RunService.Heartbeat:Connect(function() if St.buildData then pcall(function() bStat.Text="Ready: "..(St.buildData.name or "?").." | "..#St.buildData.blocks.." blocks"; bStat.TextColor3=GRN end) end end)
Sld(BP,"Delay per block (ms)",100,2000,300,function(v) St.buildDelay=v; Placer.delay=v/1000 end)
Btn(BP,">> MULAI AUTO BUILD <<",GRN,function()
    if not St.buildData then Notify("Error","Load .build atau generate test dulu!",3); return end
    ScanBuildGui(); local total=#St.buildData.blocks
    PBar.Visible=true; PLbl.Visible=true; PFill.Size=UDim2.new(0,0,1,0); StatLbl.Text="Building 0/"..total
    Placer:Build(St.buildData,function(i,tot,name)
        pcall(function()
            if name=="DONE" then PLbl.Text="Selesai! "..Placer.placed.."/"..tot; StatLbl.Text="Done! "..Placer.placed.."/"..tot; task.delay(5,function() pcall(function() PBar.Visible=false; PLbl.Visible=false end) end)
            else Tw(PFill,{Size=UDim2.new(i/tot,0,1,0)},0.1); PLbl.Text="["..i.."/"..tot.."] "..name; StatLbl.Text="Building ["..i.."/"..tot.."]" end
        end)
    end)
end)
Btn(BP,"STOP",YLW,function() Placer:Stop() end)
Btn(BP,"Reset Data",RED,function() St.buildData=nil; bStat.Text="Belum ada data build"; bStat.TextColor3=TXT1; Notify("Reset","Dihapus",2) end)

local ShP=MkPage("Shapes")
Sec(ShP,"Shape Generator")
local shTypes={"Platform","Ball","BoatHull"}; local shIdx=1
local shBtn=Btn(ShP,"Shape: Platform",BG2,nil); shBtn.MouseButton1Click:Connect(function() shIdx=shIdx%#shTypes+1; St.shapeType=shTypes[shIdx]; shBtn.Text="Shape: "..St.shapeType end)
local shBlock=TInput(ShP,"Ketik nama block, Enter"); shBlock.FocusLost:Connect(function() local q=shBlock.Text:lower(); for _,b in ipairs(DB) do if b.n:lower():find(q,1,true) then St.shapeBlock=b.n; shBlock.Text=b.n; break end end end)
shBlock.Text="Wood Block"
Sld(ShP,"Width / Radius",1,15,5,function(v) St.shapeW=v; St.shapeR=v end)
Sld(ShP,"Length",1,20,8,function(v) St.shapeL=v end)
Btn(ShP,"Generate & Build",GRN,function()
    local d; if St.shapeType=="Platform" then d=MakePlatform(St.shapeBlock,St.shapeW,St.shapeL) elseif St.shapeType=="Ball" then d=MakeBall(St.shapeBlock,St.shapeR) else d=MakeHull(St.shapeBlock,St.shapeL,St.shapeW) end
    if d then St.buildData=d; ScanBuildGui(); Notify("Shape",St.shapeType.." "..#d.blocks.." blocks",2); Placer:Build(d,function(i,tot,name) if name=="DONE" then Notify("Done","Shape selesai!",3) end end) end
end)
Btn(ShP,"Save to builds/",PRP,function()
    local d; if St.shapeType=="Platform" then d=MakePlatform(St.shapeBlock,St.shapeW,St.shapeL) elseif St.shapeType=="Ball" then d=MakeBall(St.shapeBlock,St.shapeR) else d=MakeHull(St.shapeBlock,St.shapeL,St.shapeW) end
    if d then local j=Http:JSONEncode(d); if WriteFile("builds/"..d.name..".build",j) then Notify("Saved",d.name..".build",3) elseif setclipboard then setclipboard(j); Notify("Copied","JSON di clipboard",3) end end
end)

local CP=MkPage("Convert")
Sec(CP,"Import JSON")
FileBrowser(CP,"json",".json",function(fname,content)
    local ok,raw=pcall(function() return Http:JSONDecode(content) end)
    if not ok then Notify("Error","Bukan JSON valid",3); return end
    if raw.blocks and #raw.blocks>0 then St.buildData=raw; Notify("Imported",fname.." "..#raw.blocks.." blocks",3); return end
    local bl={}; local function sc(o,d) if type(o)~="table" or d>8 then return end if (o.ClassName=="Part" or o.ClassName=="MeshPart") and (o.Name or o.name) then local bd=FindBlock(o.Name or o.name or "") bl[#bl+1]={name=bd.n,position={x=0,y=#bl*2,z=0}} end for _,v in pairs(o) do if type(v)=="table" then sc(v,d+1) end end end sc(raw,0)
    if #bl>0 then St.buildData={version="1.0",name=fname,author=LP.Name,blocks=bl,welds={}}; Notify("Converted",#bl.." blocks",3) else Notify("Error","Tidak ada blocks",3) end
end)
Btn(CP,"Export Kapalku",PRP,function()
    task.spawn(function()
        local boat; for _,v in ipairs(WS:GetDescendants()) do if v:IsA("Model") and v.Name:find(LP.Name,1,true) then boat=v; break end end
        if not boat then Notify("Error","Kapal tidak ketemu",3); return end
        local bl={}; local function sc(p) if p:IsA("BasePart") then local bd=FindBlock(p.Name); local pos=p.CFrame.Position; bl[#bl+1]={id=bd.id,name=bd.n,position={x=pos.X,y=pos.Y,z=pos.Z},color={r=math.floor(p.Color.R*255),g=math.floor(p.Color.G*255),b=math.floor(p.Color.B*255)}} end for _,ch in ipairs(p:GetChildren()) do sc(ch) end end
        for _,ch in ipairs(boat:GetChildren()) do sc(ch) end
        local j=Http:JSONEncode({version="1.0",name=boat.Name,author=LP.Name,blocks=bl,welds={}})
        local nm=boat.Name:gsub(" ","_"); if WriteFile("builds/"..nm..".build",j) then Notify("Exported","builds/"..nm..".build | "..#bl.." blocks",4) elseif setclipboard then setclipboard(j); Notify("Copied","JSON di clipboard",4) end
    end)
end)

local BkP=MkPage("Blocks")
Sec(BkP,"Daftar 159 Blocks")
local bSearch=TInput(BkP,"Cari block...")
local bFrame=N("Frame",{Size=UDim2.new(1,0,0,280),BackgroundColor3=BG2,BorderSizePixel=0,Parent=BkP}); N("UICorner",{CornerRadius=UDim.new(0,9),Parent=bFrame})
local bScr=N("ScrollingFrame",{Size=UDim2.new(1,-4,1,-4),Position=UDim2.new(0,2,0,2),BackgroundTransparency=1,ScrollBarThickness=4,ScrollBarImageColor3=PRP,CanvasSize=UDim2.new(1,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=bFrame}); N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=bScr}); N("UIPadding",{PaddingAll=UDim.new(0,3),Parent=bScr})
local function RenderBlocks(filter) for _,c in ipairs(bScr:GetChildren()) do if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end end filter=(filter or ""):lower(); for _,bl in ipairs(DB) do if filter=="" or bl.n:lower():find(filter,1,true) then local row=N("Frame",{Size=UDim2.new(1,-2,0,26),BackgroundColor3=c0(11,7,33),BorderSizePixel=0,Parent=bScr}); N("UICorner",{CornerRadius=UDim.new(0,5),Parent=row}); N("TextLabel",{Size=UDim2.new(0,28,0,14),Position=UDim2.new(0,2,0.5,-7),BackgroundColor3=DPRP,BorderSizePixel=0,Text="#"..bl.id,TextColor3=LPRP,Font=Enum.Font.GothamBold,TextSize=8,Parent=row}); N("TextLabel",{Size=UDim2.new(0.55,0,1,0),Position=UDim2.new(0,33,0,0),BackgroundTransparency=1,Text=bl.n,TextColor3=TXT0,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=row}); N("TextLabel",{Size=UDim2.new(0.3,0,0,12),Position=UDim2.new(0.62,0,0.5,-6),BackgroundColor3=BG0,BorderSizePixel=0,Text=bl.cat,TextColor3=TXT2,Font=Enum.Font.Gotham,TextSize=8,Parent=row}); row.MouseEnter:Connect(function() Tw(row,{BackgroundColor3=BG3},0.1) end); row.MouseLeave:Connect(function() Tw(row,{BackgroundColor3=c0(11,7,33)},0.1) end) end end end
RenderBlocks("")
bSearch.Changed:Connect(function(p) if p=="Text" then pcall(function() RenderBlocks(bSearch.Text) end) end end)

local InfoP=MkPage("Info")
Sec(InfoP,"OxyX BABFT v11 - Galaxy Edition")
N("TextLabel",{Size=UDim2.new(1,0,0,55),BackgroundTransparency=1,Text="Auto-builder BABFT | 159 blocks\nPastikan masuk Build Mode dulu!\nTab: Build Shapes Convert Blocks Info",TextColor3=TXT1,Font=Enum.Font.Gotham,TextSize=11,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=InfoP})
Btn(InfoP,"Copy GitHub URL",CYN,function() if setclipboard then setclipboard("https://raw.githubusercontent.com/johsua092-ui/oxyX-sc/refs/heads/main/OxyX_BABFT.lua"); Notify("Copied","URL di clipboard",3) end end)
Btn(InfoP,"Reload",PRP,function() Notify("Reload","Reloading...",2); task.delay(0.4,function() pcall(function() SG:Destroy() end); loadstring(game:HttpGet("https://raw.githubusercontent.com/johsua092-ui/oxyX-sc/refs/heads/main/OxyX_BABFT.lua"))() end) end)

-- Tab system - 5 tabs x 92px + 4 gaps x 5px + 12px = 488px (fits in 500px)
local tabDefs={{n="Build",lbl="Build"},{n="Shapes",lbl="Shapes"},{n="Convert",lbl="Convert"},{n="Blocks",lbl="Blocks"},{n="Info",lbl="Info"}}
local function SwitchTab(name) St.tab=name; for _,p in pairs(Pages) do pcall(function() p.Visible=false end) end; for nm,b in pairs(TabBtns) do pcall(function() if nm==name then Tw(b,{BackgroundColor3=PRP},0.2); b.TextColor3=WHT else Tw(b,{BackgroundColor3=BG3},0.2); b.TextColor3=TXT2 end end) end; if Pages[name] then Pages[name].Visible=true end; StatLbl.Text=name.." | OxyX v11" end
for i,td in ipairs(tabDefs) do
    local b=N("TextButton",{Size=UDim2.new(0,92,0,28),Position=UDim2.new(0,6+(i-1)*97,0,4),BackgroundColor3=BG3,BorderSizePixel=0,Text=td.lbl,TextColor3=TXT2,Font=Enum.Font.GothamBold,TextSize=10,AutoButtonColor=false,ZIndex=15,Parent=TabBG})
    N("UICorner",{CornerRadius=UDim.new(0,7),Parent=b}); TabBtns[td.n]=b; b.MouseButton1Click:Connect(function() SwitchTab(td.n) end)
end

-- Drag
local drg=false; local dO=Vector2.new(0,0)
HDR.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=true; dO=Vector2.new(Mouse.X-MF.AbsolutePosition.X,Mouse.Y-MF.AbsolutePosition.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end end)
RunService.Heartbeat:Connect(function() if drg and MF and MF.Parent then pcall(function() local vp=Cam.ViewportSize; MF.Position=UDim2.new(0,math.clamp(Mouse.X-dO.X,0,vp.X-MF.AbsoluteSize.X),0,math.clamp(Mouse.Y-dO.Y,0,vp.Y-MF.AbsoluteSize.Y)) end) end end)
MinB.MouseButton1Click:Connect(function() St.minimized=not St.minimized; if St.minimized then Tw(MF,{Size=UDim2.new(0,500,0,88)},0.28,Enum.EasingStyle.Back); MinB.Text="[]" else Tw(MF,{Size=UDim2.new(0,500,0,620)},0.3,Enum.EasingStyle.Back); MinB.Text="-" end end)
ClsB.MouseButton1Click:Connect(function() Tw(MF,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.22); task.delay(0.25,function() pcall(function() SG:Destroy() end) end) end)
UIS.InputBegan:Connect(function(i,gp) if gp then return end pcall(function() if i.KeyCode==Enum.KeyCode.RightShift then MF.Visible=not MF.Visible end end) end)

SwitchTab("Build")
ScanBuildGui()
Notify("OxyX v11","Galaxy Edition! Masuk Build Mode BABFT dulu.",5)
