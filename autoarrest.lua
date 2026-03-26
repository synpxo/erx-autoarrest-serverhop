loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/e72dda22a300c4de5ded1a43123b0e20.lua"))()

repeat task.wait() until _G.Functions and _G.Window and _G.Window.TabModule

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

local CheckCallsign = ReplicatedStorage:WaitForChild("FE"):WaitForChild("CheckCallsign")
local CanChange = ReplicatedStorage:WaitForChild("FE"):WaitForChild("CanChangeTeam")
local TeamChangeRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("TeamChange")

local function generateCallsign()
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    local function randomLetters(count)
        local result = ""
        for _ = 1, count do
            local index = math.random(1, #letters)
            result = result .. letters:sub(index, index)
        end
        return result
    end

    local function randomNumbers(min, max)
        return tostring(math.random(min, max))
    end

    return randomLetters(2) .. "-" .. randomNumbers(10, 99)
end

local function joinPolice()
    local result = CanChange:InvokeServer(game.Teams.Police)

    if result == "Good" then
        local callsign = generateCallsign()
        local valid = CheckCallsign:InvokeServer(callsign)

        if valid then
            TeamChangeRemote:FireServer(game.Teams.Police, callsign)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(2)
        if localPlayer:GetAttribute("Team") ~= "Police" then
            joinPolice()
        end
    end
end)

task.spawn(function()
    repeat task.wait() until _G.Window and _G.Window.TabModule

    local target

    for _,v in ipairs(_G.Window.TabModule.Tabs[1].Elements) do
        if tostring(v.Title):find("Auto Arrest") then
            target = v
            break
        end
    end

    if target then
        while true do
            pcall(function()
                target.Value = true
                target:Set(true)
                if target.Callback then
                    target.Callback(true)
                end
            end)
            task.wait(0.3)
        end
    end
end)

local server_hop = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cesare0328/my-scripts/refs/heads/main/CachedServerhop.lua"))

task.spawn(function()
    while true do
        task.wait(2)

        local found = false

        for _,player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local wanted = player:FindFirstChild("Is_Wanted")
                if wanted then
                    found = true
                    break
                end
            end
        end

        if not found then
            server_hop()
            break
        end
    end
end)
