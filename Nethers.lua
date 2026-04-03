-- [[ NETHERS HUB V2 - WHITELIST SYSTEM ]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- LISTE DES IDS AUTORISÉS (ID mis à jour ici)
local WhitelistedIDs = {
    7714389292, -- L'ID que tu viens de demander
    9453982711  -- Ton autre ID
}

local function StartNethersHub()
    local isWhitelisted = false
    
    for _, id in pairs(WhitelistedIDs) do
        if player.UserId == id then
            isWhitelisted = true
            break
        end
    end

    if isWhitelisted then
        print("Access Granted - Nethers Hub V2")
        loadstring(game:HttpGet("https://api.luarmor.cc/files/v4/loaders/36d729f6d33548ada4452c36256f5ac9.lua"))()
    else
        player:Kick("you are not withelisted")
    end
end

StartNethersHub()
