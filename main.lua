-- Encrypted by AI Compiler
local _0x3F4A = {
    "\x67\x61\x6d\x65", "\x47\x65\x74\x53\x65\x72\x76\x69\x63\x65", "\x50\x6c\x61\x79\x65\x72\x73", 
    "\x57\x6f\x72\x6b\x73\x70\x61\x63\x65", "\x52\x75\x6e\x53\x65\x72\x76\x69\x63\x65", "\x4c\x6f\x63\x61\x6c\x50\x6c\x61\x79\x65\x72",
    "\x42\x6f\x6d\x62\x4d\x69\x73\x73\x69\x6c\x65", "\x52\x6f\x63\x6b\x65\x74", "\x50\x6c\x61\x79\x65\x72\x47\x75\x69", 
    "\x57\x61\x69\x74\x46\x6f\x72\x43\x68\x69\x6c\x64", "\x47\x65\x74\x43\x68\x69\x6c\x64\x72\x65\x6e", "\x4d\x69\x73\x73\x69\x6c\x65\x50\x6f\x73\x73\x65\x73\x73\x47\x75\x69",
    "\x44\x65\x73\x74\x72\x6f\x7a", "\x53\x63\x72\x65\x65\x6e\x47\x75\x69", "\x54\x65\x78\x74\x4e\x75\x74\x74\x6f\x6e",
    "\x48\x75\x6d\x61\x6e\x6f\x69\x64\x52\x6f\x6f\x74\x50\x61\x72\x74", "\x48\x65\x61\x72\x74\x62\x65\x61\x74", "\x42\x61\x73\x65\x50\x61\x72\x74"
}
local _0x8C1B = _G or shared
local Players = game[_0x3F4A[2]](game, _0x3F4A[3])
local workspace = game[_0x3F4A[2]](game, _0x3F4A[4])
local RunService = game[_0x3F4A[2]](game, _0x3F4A[5])
local Player = Players[_0x3F4A[6]]
local TARGET_NAMES = {_0x3F4A[7], _0x3F4A[8]}
local METEOR_SPEED = 1400
local BOMB_RADIUS = 70
local isTrackingLoop = false
local holdingMissiles = {}
local positionConnection = nil
local playerGui = Player[_0x3F4A[10]](Player, _0x3F4A[9])

for _, v in pairs(playerGui[_0x3F4A[11]](playerGui)) do
    if v.Name == _0x3F4A[12] then v:Destroy() end
end
task.wait(0.1)

local ScreenGui = Instance.new(_0x3F4A[14])
ScreenGui.Name = _0x3F4A[12]
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local ToggleHoldButton = Instance.new("TextButton")
ToggleHoldButton.Name = "ToggleHoldButton"
ToggleHoldButton.Parent = ScreenGui
ToggleHoldButton.Size = UDim2.new(0, 180, 0, 45)
ToggleHoldButton.Position = UDim2.new(0, 20, 0.38, 0)
ToggleHoldButton.BackgroundColor3 = Color3.fromRGB(230, 90, 0)
ToggleHoldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHoldButton.TextSize = 10
ToggleHoldButton.Font = Enum.Font.SourceSansBold
ToggleHoldButton.Text = "\xe2\x91\xa0\x20\x35\xe7\xa7\x92\xe5\x91\xa8\xe6\x9c\x9f\xe8\x87\xaa\xe5\x8b\x95\xe5\x9b\x9e\xe5\x8f\x8c\x3a\x20\x4f\x46\x46"
ToggleHoldButton.ZIndex = 10

local FireButton = Instance.new("TextButton")
FireButton.Name = "FireButton"
FireButton.Parent = ScreenGui
FireButton.Size = UDim2.new(0, 180, 0, 45)
FireButton.Position = UDim2.new(0, 20, 0.45, 0)
FireButton.BackgroundColor3 = Color3.fromRGB(180, 70, 0)
FireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FireButton.TextSize = 12
FireButton.Font = Enum.Font.SourceSansBold
FireButton.Text = "\xe2\x91\xa1\x20\xe4\xbb\x96\xe4\xba\xba\xe5\x90\xab\xe3\x82\x81\xe5\xae\x8c\xe5\x85\xa8\xe4\xb8\x80\xe6\x96\x89\xe8\xb5\xb7\xe7\x88\x86\xef\xbc\x81"
FireButton.ZIndex = 10

local function updateMissilePositions(baseTargetPos)
    local validMissiles = {}
    for _, part in pairs(holdingMissiles) do
        if part and part.Parent and part:IsA(_0x3F4A[18]) then
            table.insert(validMissiles, part)
        end
    end
    local count = #validMissiles
    if count == 0 then return end
    for index, part in pairs(validMissiles) do
        local offsetX, offsetZ
        if index == 1 then
            offsetX = 0; offsetZ = 0
        else
            local r = math.sqrt((index - 1) / (count - 1)) * BOMB_RADIUS
            local theta = index * math.rad(137.5)
            offsetX = math.cos(theta) * r
            offsetZ = math.sin(theta) * r
        end
        local finalCFrame = CFrame.new(baseTargetPos + Vector3.new(offsetX, 0, offsetZ)) * CFrame.Angles(math.rad(90), 0, 0)
        local rootModel = part:FindFirstAncestorOfClass("Model")
        if rootModel then
            rootModel:PivotTo(finalCFrame)
        else
            part.CFrame = finalCFrame
        end
        part.Anchored = true
        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

local function toggleTrackingLoop()
    local character = Player.Character
    if not character then return end
    local myRoot = character:FindFirstChild(_0x3F4A[16])
    if not myRoot then return end

    if not isTrackingLoop then
        isTrackingLoop = true
        ToggleHoldButton.Text = "\xe2\x91\xa0\x20\x35\xe7\xa7\x92\xe5\x91\xa8\xe6\x9c\x9f\xe8\x87\xaa\xe5\x8b\x95\xe5\x9b\x9e\xe5\x8f\x8c\x3a\x20\xf0\x9f\x9f\xa2\x4f\x4e"
        ToggleHoldButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        positionConnection = RunService[_0x3F4A[17]]:Connect(function()
            local currentRoot = character:FindFirstChild(_0x3F4A[16])
            if not currentRoot then return end
            local baseTargetPos = currentRoot.Position + Vector3.new(0, 100, 0)
            Player.ReplicationFocus = currentRoot
            updateMissilePositions(baseTargetPos)
        end)
        
        task.spawn(function()
            while isTrackingLoop do
                local currentRoot = character:FindFirstChild(_0x3F4A[16])
                if currentRoot then
                    local baseTargetPos = currentRoot.Position + Vector3.new(0, 100, 0)
                    local newlyFound = false
                    
                    for _, v in pairs(workspace:GetDescendants()) do
                        if table.find(TARGET_NAMES, v.Name) then
                            local part = v:IsA(_0x3F4A[18]) and v or v:FindFirstChildWhichIsA(_0x3F4A[18], true)
                            if part and part.Parent and not table.find(holdingMissiles, part) then
                                for _, child in pairs(part:GetChildren()) do
                                    if child:IsA("BodyVelocity") or child:IsA("LinearVelocity") or child:IsA("VectorForce") then
                                        child:Destroy()
                                    end
                                end
                                table.insert(holdingMissiles, part)
                                newlyFound = true
                            end
                        end
                    end
                    
                    if newlyFound then
                        updateMissilePositions(baseTargetPos)
                        ToggleHoldButton.Text = "\xe5\x9b\x9e\xe5\x8f\x8c\xe4\xb8\xad\x2e\x2e\x2e\x20\xe7\x8f\xbe\xe5\x9c\xa8\x20" .. tostring(#holdingMissiles) .. "\xe7\x99\xba\xe3\x83\xbb\xe3\x83\xbc\xe3\x83\xab\xe3\x83\x89"
                        task.wait(1)
                        if isTrackingLoop then ToggleHoldButton.Text = "\xe2\x91\xa0\x20\x35\xe7\xa7\x92\xe5\x91\xa8\xe6\x9c\x9f\xe8\x87\xaa\xe5\x8b\x95\xe5\x9b\x9e\xe5\x8f\x8c\x3a\x20\xf0\x9f\x9f\xa2\x4f\x4e" end
                    end
                end
                task.wait(5)
            end
        end)
    else
        isTrackingLoop = false
        if positionConnection then positionConnection:Disconnect() end
        positionConnection = nil
        Player.ReplicationFocus = nil
        
        ToggleHoldButton.Text = "\xe2\x91\xa0\x20\x35\xe7\xa7\x92\xe5\x91\xa8\xe6\x9c\x9f\xe8\x87\xaa\xe5\x8b\x95\xe5\x9b\x9e\xe5\x8f\x8c\x3a\x20\xf0\x9f\x94\xb4\x4f\x46\x4f"
        ToggleHoldButton.BackgroundColor3 = Color3.fromRGB(230, 90, 0)
    end
end

local function fireAllHoldingMissiles()
    local missilesToFire = {}
    for _, part in pairs(holdingMissiles) do
        if part and part.Parent and part:IsA(_0x3F4A[18]) then
            table.insert(missilesToFire, part)
        end
    end
    
    if isTrackingLoop then toggleTrackingLoop() end
    local fireCount = 0
    
    for _, part in pairs(missilesToFire) do
        pcall(function()
            if part and part.Parent then
                local oldPos = part.Position
                part.Anchored = false
                part:ApplyImpulse(Vector3.new(0, -150, 0))
                
                task.wait(0.01)
                part.AssemblyLinearVelocity = Vector3.new(0, -METEOR_SPEED, 0)
                
                if part.AssemblyLinearVelocity.Y >= -10 then
                    local rootModel = part:FindFirstAncestorOfClass("Model") or part
                    rootModel:Destroy()
                    local exp = Instance.new("Explosion")
                    exp.Position = oldPos
                    exp.BlastRadius = 40
                    exp.BlastPressure = 500000
                    exp.Parent = workspace
                end
                fireCount = fireCount + 1
            end
        end)
    end
    
    holdingMissiles = {}
    if fireCount > 0 then
        FireButton.Text = "\xe5\xae\x8c\xe5\x85\xa8\xe5\x90\x8c\xe6\x99\x82\xe7\x99\xba\xe5\xb0\x84\xef\xbc\x81\x20" .. tostring(fireCount) .. "\xe7\x99\xba"
        FireButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        FireButton.Text = "\xe5\xbe\x85\xe6\xa9\x9f\xe5\xbc\xbe\xe3\x81\x8c\xe3\x81\x82\xe3\x82\x8a\xe3\x81\xbe\xe3\x81\x9b\xe3\x82\x93"
        FireButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
    
    task.delay(1.5, function()
        FireButton.Text = "\xe2\x91\xa1\x20\xe4\xbb\x96\xe4\xba\xba\xe5\x90\xab\xe3\x82\x81\xe5\xae\x8c\xe5\x85\xa8\xe4\xb8\x80\xe6\x96\x89\xe8\xb5\xb7\xe7\x88\x86\xef\xbc\x81"
        FireButton.BackgroundColor3 = Color3.fromRGB(180, 70, 0)
    end)
end

ToggleHoldButton.MouseButton1Click:Connect(toggleTrackingLoop)
FireButton.MouseButton1Click:Connect(fireAllHoldingMissiles)
