RegisterServerEvent('requestEffectTrigger')
AddEventHandler('requestEffectTrigger', function(nearbyPlayerIds)
    local src = source  
    
    for _, playerId in ipairs(nearbyPlayerIds) do
        TriggerClientEvent('RSG:showPtfx', playerId, src)
    end
end)
