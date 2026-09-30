-- ▄█████ ██ ▄█▀ ██ ████▄  ██████ ██     ██ ███  ██  ▄████  ██████ █████▄   AnthonyIsntHere's 'skidflinger'
-- ▀▀▀▄▄▄ ████   ██ ██  ██ ██▄▄   ██     ██ ██ ▀▄██ ██  ▄▄▄ ██▄▄   ██▄▄██▄  Ever since my pookie boo got termed i've always been trying to find skidflinger again
-- █████▀ ██ ▀█▄ ██ ████▀  ██     ██████ ██ ██   ██  ▀███▀  ██▄▄▄▄ ██   ██  So incase that was you too, here's Anthony's skidflinger ALMOST 1:1
                                                                        

local targets = {"AnthonyIsntHere","Avilogist"}
local skid, angularVelocity, upwardVelocity = 9e8, 9e8, 9e8
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer

local function matchesTarget(p)
    if p == localPlayer then return false end
    local n, d = p.Name:lower(), p.DisplayName:lower()
    for _, t in ipairs(targets) do
        t = t:lower()
        if t == "all" or t == "everyone" then
            return true
        elseif #t > 0 and (n == t or d == t or n:sub(1, #t) == t or d:sub(1, #t) == t) then
            return true
        end
    end
    return false
end

local function fling(targetPlayer)
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = hum and hum.RootPart
    local tChar = targetPlayer.Character
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    local tRoot = tHum and tHum.RootPart
    local tHead = tChar and tChar:FindFirstChild("Head")
    local accessory = tChar and tChar:FindFirstChildOfClass("Accessory")
    local handle = accessory and accessory:FindFirstChild("Handle")
    if not (char and hum and root and tChar) then return false end
    if tHum and tHum.Sit then return false end
    if not tChar:FindFirstChildWhichIsA("BasePart") then return false end
    local oldPos = root.CFrame

    local savedFPDH = workspace.FallenPartsDestroyHeight
    pcall(function()
        workspace.FallenPartsDestroyHeight = 0 / 0
    end)

    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    local function fPos(part, pos, ang)
        root.CFrame = CFrame.new(part.Position) * pos * ang
        char:SetPrimaryPartCFrame(root.CFrame)
        root.AssemblyLinearVelocity = Vector3.new(skid, upwardVelocity, skid)
        root.AssemblyAngularVelocity = Vector3.new(angularVelocity, angularVelocity, angularVelocity)
    end

    local basePart
    if tRoot and tHead then
        if (tRoot.CFrame.p - tHead.CFrame.p).Magnitude > 5 then
            basePart = tHead
        else
            basePart = tRoot
        end
    elseif tRoot then
        basePart = tRoot
    elseif tHead then
        basePart = tHead
    elseif handle then
        basePart = handle
    end

    if basePart then
        local startTime = tick()
        local angle = 0
        repeat
            if not (root and root.Parent and tHum and basePart.Parent) then break end
            if basePart.AssemblyLinearVelocity.Magnitude < 50 then
                angle = angle + 100
                fPos(basePart, CFrame.new(0, 1.5, 0) + tHum.MoveDirection * basePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                runService.Heartbeat:Wait()
                fPos(basePart, CFrame.new(0, -1.5, 0) + tHum.MoveDirection * basePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                runService.Heartbeat:Wait()
            else
                fPos(basePart, CFrame.new(0, 1.5, basePart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                runService.Heartbeat:Wait()
                fPos(basePart, CFrame.new(0, -1.5, -basePart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                runService.Heartbeat:Wait()
            end
        until basePart.AssemblyLinearVelocity.Magnitude > 500
            or basePart.Parent ~= tChar
            or targetPlayer.Parent ~= players
            or targetPlayer.Character ~= tChar
            or tHum.Sit
            or hum.Health <= 0
            or tick() > startTime + 0.5
    end

    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

    local rT0 = tick()
    repeat
        root.CFrame = oldPos
        char:SetPrimaryPartCFrame(oldPos)
        hum:ChangeState("GettingUp")
        for _, x in ipairs(char:GetChildren()) do
            if x:IsA("BasePart") then
                x.AssemblyLinearVelocity = Vector3.zero
                x.AssemblyAngularVelocity = Vector3.zero
            end
        end
        runService.Heartbeat:Wait()
    until (root.Position - oldPos.Position).Magnitude < 5 or tick() > rT0 + 2

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    pcall(function()
        workspace.FallenPartsDestroyHeight = savedFPDH
    end)

    return true
end

task.wait(1)
for _, p in ipairs(players:GetPlayers()) do
    if matchesTarget(p) and p.Character then
        pcall(fling, p)
    end
end