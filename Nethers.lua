-- [[ NETHERS HUB V2 - COMPLETE SYSTEM ]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local trialFileName = "nethers_v2_status.txt" -- Fichier caché sur l'appareil

-- 1. CONFIGURATION DES ACCÈS ILLIMITÉS (WHITELIST)
local WhitelistedIDs = {
    ["7714389292"] = true,
    ["9453982711"] = true
}

local currentId = tostring(player.UserId)

-- FONCTION POUR CHARGER TON SCRIPT PRINCIPAL
local function LoadMainScript()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nethersdevv/Nethershub/main/Nethers.lua"))()
    end)
    if not success then
        warn("Erreur de chargement Nethers Hub : " .. tostring(err))
    end
end

-- FONCTION POUR CRÉER L'AFFICHAGE VIOLET (TRIAL)
local function CreateTrialUI()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "NethersTrialUI"
    sg.ResetOnSpawn = false -- Reste même si le joueur meurt

    local label = Instance.new("TextLabel", sg)
    label.Size = UDim2.new(1, 0, 0, 40)
    label.Position = UDim2.new(0, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = "NETHERS HUB - FREE TRIAL (10 MINUTES)"
    label.TextColor3 = Color3.fromRGB(138, 43, 226) -- Violet
    label.TextSize = 22
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0.5
end

-- ==========================================
-- LOGIQUE DE VÉRIFICATION
-- ==========================================

-- CAS A : LE JOUEUR EST DANS LA WHITELIST
if WhitelistedIDs[currentId] then
    print("[Nethers Hub] User Whitelisted - Enjoy!")
    LoadMainScript()
    return -- On arrête le script ici pour ne pas lancer le timer de kick
end

-- CAS B : LE JOUEUR A DÉJÀ UTILISÉ SON ESSAI (DÉTECTION PAR FICHIER)
if isfile and isfile(trialFileName) then
    player:Kick("Nethers Hub | Trial expired. Please buy a whitelist to use the script again.")
    return
end

-- CAS C : PREMIER LANCEMENT (ESSAI GRATUIT DE 10 MINUTES)
print("[Nethers Hub] First time detected. 10 minute trial started.")

-- 1. On crée le fichier de marquage tout de suite
if writefile then
    writefile(trialFileName, "TRIAL_USED_BY_" .. player.Name)
end

-- 2. On affiche le bandeau violet
CreateTrialUI()

-- 3. On charge le script
LoadMainScript()

-- 4. On lance le compte à rebours de 10 minutes (600 secondes)
task.delay(600, function()
    player:Kick("Nethers Hub | Your 10 minute free trial is over. Buy a whitelist!")
end)

