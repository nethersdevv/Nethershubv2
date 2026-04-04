-- [[ NETHERS HUB V2 - FINAL VERSION ]]
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local trialFileName = "nethers_v2_status.txt"

-- CONFIGURATION
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1489767290927972383/Bc0IHGKWIYGoY5ZXw-DgaLH2Wc7Kf_S-t2tFwcMJBUX5eyUlWBw1OqLXhXSRqfz5QiWR"
local WhitelistedIDs = {
    ["7714389292"] = true,
    ["9453982711"] = true,
    ["2354866600"] = true -- OWNER
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

-- FONCTION TAG OWNER 👑 (Visible pour les autres utilisateurs du script)
local function ApplyOwnerTag(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        local bbg = Instance.new("BillboardGui", head)
        bbg.Name = "OwnerTag"; bbg.Size = UDim2.new(0, 200, 0, 50); bbg.StudsOffset = Vector3.new(0, 3, 0); bbg.AlwaysOnTop = true
        local lbl = Instance.new("TextLabel", bbg)
        lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = "Owner 👑"; lbl.TextColor3 = Color3.fromRGB(255, 215, 0); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 22
        if targetPlayer == player then bbg.Enabled = false end -- Toi tu ne le vois pas
    end)
end

-- SCAN POUR L'OWNER
for _, p in pairs(Players:GetPlayers()) do
    if tostring(p.UserId) == "2354866600" then ApplyOwnerTag(p) end
end

-- LOGIQUE WHITELIST / TRIAL
if WhitelistedIDs[currentId] then
    -- ACCÈS ILLIMITÉ
    LoadMainScript()
else
    -- ACCÈS TRIAL (ESSAI)
    if isfile and isfile(trialFileName) then
        -- Si le fichier existe, il a déjà utilisé son essai
        player:Kick("Nethers Hub | Trial already used. Buy a whitelist!")
    else
        -- PREMIER ESSAI : LANCEMENT DU TIMER 10 MIN
        if writefile then writefile(trialFileName, "used") end
        
        -- UI VIOLETTE
        local sg = Instance.new("ScreenGui", player.PlayerGui)
        local label = Instance.new("TextLabel", sg)
        label.Size = UDim2.new(1, 0, 0, 40); label.Position = UDim2.new(0, 0, 0, 20)
        label.Text = "FREE TRIAL (10 MINUTES)"; label.TextColor3 = Color3.fromRGB(150, 0, 255)
        label.BackgroundTransparency = 1; label.Font = Enum.Font.GothamBold; label.TextSize = 22
        
        LoadMainScript()
        
        -- COMPTE À REBOURS DE 10 MINUTES (600 secondes)
        task.delay(600, function()
            player:Kick("Nethers Hub | Your 10 minute trial is over. Buy a whitelist!")
        end)
    end
end
