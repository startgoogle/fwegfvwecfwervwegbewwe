getgenv().Webhook = "https://discord.com/api/webhooks/1257156534983720972/y7VLKuFnU1o9HJ0N8PZEgjIfAb5zVO1Z4Yk-yp_peYbO0P9O0gpkoNbfbrHeqFo4sU4x"

repeat task.wait() until 
    game:IsLoaded() and
    game.Workspace:FindFirstChild("Objects") and
    game.Workspace.Objects:FindFirstChild("Characters") and
    game.Workspace.Objects.Characters:FindFirstChild(game.Players.LocalPlayer.Name) and
    game.Players.LocalPlayer:FindFirstChild("ReplicatedData") and
    game:GetService("ReplicatedStorage")

    if game:GetService("CoreGui"):FindFirstChild("ScreenGui") then
        game:GetService("CoreGui").ScreenGui:Destroy()
    end

task.wait(7)
local VIS = game:GetService("VirtualInputManager")
local function pressKey(key)
    VIS:SendKeyEvent(true, key, false, game)
    task.wait()
    VIS:SendKeyEvent(false, key, false, game)
end

pressKey(Enum.KeyCode.BackSlash)
for i = 1,3 do
    pressKey(Enum.KeyCode.Down)
end
pressKey(Enum.KeyCode.Return)
task.wait(2)

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false

local bb = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)

local function loadScript()
    pcall(function()
        repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

        local queue_on_teleport = queue_on_teleport or syn.queue_on_teleport

        queue_on_teleport([[
            repeat wait() until game.Players.LocalPlayer:FindFirstChild("ReplicatedData")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/startgoogle/fwegfvwecfwervwegbewwe/item.lua', true))()
        ]])
    end)
end

loadScript()

function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

local path = workspace.Objects.Drops
local items = path:GetChildren()

local function SendWebhook(msg)
    local url = getgenv().Webhook

    local data;
    data = {
        ["embeds"] = {
            {
                ["title"] = "Jujutsu Infinite Item Farm",
                ["description"] = msg,
                ["type"] = "rich",
                ["color"] = tonumber(0x7269ff),
            }
        }
    }

    repeat task.wait() until data
    local newdata = game:GetService("HttpService"):JSONEncode(data)


    local headers = {
        ["Content-Type"] = "application/json"
    }
    local request = http_request or request or HttpPost or syn.request or http.request
    local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
    request(abcdef)
end

local function getPlayer()
    return game.Players.LocalPlayer
end

local function getCharacter()
    return getPlayer().Character
end

local function countNonTalismanItems()
    local count = 0
    for _, item in ipairs(items) do
        if item.Name ~= "Talisman" and item.Name ~= "Chest" then
            count = count + 1
        end
    end
    return count
end

print(countNonTalismanItems())

-- Modified while loop to use filtered count
while countNonTalismanItems() > 0 do
    task.wait()
    local foundCollect = false
    for _, item in pairs(items) do
        if item:FindFirstChild("Collect") then
            foundCollect = true
            if item.Name ~= "Talisman" and item.Name ~= "Chest" then
                local root = item.Root
                
                getCharacter().HumanoidRootPart.CFrame = root.CFrame
                
                for i, v in pairs(item:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v, 1, true)
                        SendWebhook("Found "..item.Name)
                    end
                end
                task.wait(0.35)
            end
        end
    end
    if not foundCollect then
        task.wait(1)
    end
end
Teleport()
