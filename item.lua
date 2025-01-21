getgenv().Webhook = "https://discord.com/api/webhooks/1257156534983720972/y7VLKuFnU1o9HJ0N8PZEgjIfAb5zVO1Z4Yk-yp_peYbO0P9O0gpkoNbfbrHeqFo4sU4x"

repeat task.wait() until game:IsLoaded() and game:GetService("Workspace"):FindFirstChild("Objects")

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
            repeat task.wait() until game:IsLoaded()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/startgoogle/fwegfvwecfwervwegbewwe/refs/heads/main/item.lua", true))()
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

local function isDesiredItem(itemName)
    -- List of desired items
    local desiredItems = {
        "Vengeance",
        "Demon Finger",
        "Domain Shard",
        "Inverted Spear Of Heaven",
        "Maximum Scroll",
        "Ravenous Axe",
        "Impossible Dream", 
        "Blood Sword"
    }
    -- Check if the item is in the desired list
    for _, name in pairs(desiredItems) do
        if itemName == name then
            return true
        end
    end
    return false
end

-- Function to find a valid teleport part in the item model
local function findValidPart(item)
    -- Search for parts in priority order
    local priorityParts = { "Root", "Handle" }
    for _, partName in ipairs(priorityParts) do
        local part = item:FindFirstChild(partName)
        if part and (part:IsA("Part") or part:IsA("BasePart") or part:IsA("MeshPart")) then
            return part
        end
    end

    -- Look for any BasePart if priority parts aren't found
    for _, child in pairs(item:GetChildren()) do
        if child:IsA("BasePart") or child:IsA("MeshPart") then
            return child
        end
    end

    return nil
end

local function countValidItems()
    local count = 0
    for _, item in ipairs(items) do
        if item.Name ~= "Talisman" and item.Name ~= "Chest" and isDesiredItem(item.Name) then
            count = count + 1
        end
    end
    return count
end

-- Modified while loop
while countValidItems() > 0 do
    task.wait()
    local foundCollect = false
    for _, item in pairs(items) do
        if item:FindFirstChild("Collect") then
            foundCollect = true
            if item.Name ~= "Talisman" and item.Name ~= "Chest" and isDesiredItem(item.Name) then
                local targetPart = findValidPart(item)
                if targetPart then
                    getCharacter().HumanoidRootPart.CFrame = targetPart.CFrame
                    for _, descendant in pairs(item:GetDescendants()) do
                        if descendant:IsA("ProximityPrompt") then
                            fireproximityprompt(descendant, 1, true)
                            SendWebhook("Collected: " .. item.Name)
                        end
                    end
                    task.wait(0.35)
                end
            end
        end
    end
    if not foundCollect then
        task.wait(1)
    end
end

Teleport()
