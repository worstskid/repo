-- permadeath via replicatesignal
-- should be anthony's method <3
-- p sure roblox patched ConnectDiedSignalBackend now tho </3

local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

replicatesignal(player.ConnectDiedSignalBackend)
spawn(function()
    repeat
        player:Move(Vector3.new(1/0))
        task.wait()
    until humanoid.Health == 0
end)

repeat
    task.wait()
until not character:FindFirstChildWhichIsA("BasePart")
    or not character.Parent
    or not player.Character
