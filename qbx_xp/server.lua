-- Server side
CreateThread(function()
    local interval = 5   -- interval in minutes
    local xp = 5        -- XP amount to award every interval

    while true do
        for i, src in pairs(GetPlayers()) do
            TriggerClientEvent('xperience:client:addXP', src, xp)
        end
        
        Wait(interval * 60 * 1000)
    end
end)