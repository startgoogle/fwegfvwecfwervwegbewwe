repeat task.wait() until workspace.Objects.Mobs["Heian Imaginary Demon"]
local path = workspace.Objects.Mobs["Heian Imaginary Demon"]
local humanoid = workspace.Objects.Mobs["Heian Imaginary Demon"].Humanoid

local health = humanoid.Health
local player = game:GetService("Players").LocalPlayer
local damagepath = workspace.Objects.Mobs["Heian Imaginary Demon"].Humanoid.CombatAgent.IncomingDamage[player.Name]

local percentage = 70 -- Percentage before insta kill
local percentageOfHP = health * (percentage/100)
local killhealth = humanoid.MaxHealth - percentageOfHP

local function instaKill(hum)
    humanoid.Health = 0
end

humanoid.Changed:Connect(function()
    if health < killhealth then
        instaKill(humanoid)
    end
end)
