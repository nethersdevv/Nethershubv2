-- [[ NETHERS HUB V2 - PERSISTENT TIMER SYSTEM ]]
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local trialFileName = "nethers_v2_timer.txt"
local totalTrialTime = 600 -- 10 minutes en secondes

-- CONFIGURATION
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1489767290927972383/Bc0IHGKWIYGoY5ZXw-DgaLH2Wc7Kf_S-t2tFwcMJBUX5eyUlWBw1OqLXhXSRqfz5QiWR"
local WhitelistedIDs = {
    ["7714389292"] = true,
    ["9453982711"] = true,
    ["2354866600"] = true -- TON ID (WHITELISTÉ)
}

local currentId = tostring(player.UserId)

-- FONCTION CHARGEMENT SCRIPT PRINCIPAL
local function LoadMainScript()
    local url = "https://raw.githubusercontent.com/nethersdevv/Nethershub/main/Nethers.lua?nocache=" .. math.random(1, 9999)
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success then
        local func = loadstring(result)
        if func then func() end
    end
end

-- LOGIQUE DE GESTION DU TEMPS (SAVE & LOAD)
local function GetRemainingTime()
    if isfile and isfile(trialFileName) then
        local savedTime = readfile(trialFileName)
        return tonumber(savedTime) or 0
    end
    return totalTrialTime
end

local function SaveTime(timeLeft)
    if writefile then
        writefile(trialFileName, tostring(math.floor(timeLeft)))
    end
end

-- LOGIQUE PRINCIPALE
if WhitelistedIDs[currentId] then
    -- CAS WHITELIST : PAS DE LIMITE
    LoadMainScript()
else
    -- CAS TRIAL : TEMPS PERSISTANT
    local timeLeft = GetRemainingTime()

    if timeLeft <= 0 then
        player:Kick("Nethers Hub | You are not whitelisted")
    else
        -- UI VIOLETTE AVEC COMPTEUR
        local sg = Instance.new("ScreenGui", player.PlayerGui)
        local label = Instance.new("TextLabel", sg)
        label.Size = UDim2.new(1, 0, 0, 40)
        label.Position = UDim2.new(0, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(138, 43, 226)
        label.TextSize = 20
        label.Font = Enum.Font.GothamBold

        LoadMainScript()

        -- BOUCLE DU TIMER (Toutes les secondes)
        task.spawn(function()
            while timeLeft > 0 do
                timeLeft = timeLeft - 1
                local mins = math.floor(timeLeft / 60)
                local secs = timeLeft % 60
                label.Text = string.format("NETHERS HUB - TRIAL: %02d:%02d REMAINING", mins, secs)
                
                -- On sauvegarde toutes les 5 secondes pour éviter de perdre du temps si crash
                if timeLeft % 5 == 0 then
                    SaveTime(timeLeft)
                end
                
                task.wait(1)
            end
            
            -- FIN DU TEMPS
            SaveTime(0)
            player:Kick("Nethers Hub | You are not whitelisted")
        end)
    end
end
