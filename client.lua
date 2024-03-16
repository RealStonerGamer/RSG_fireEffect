local effectActive = false
local nearbyPlayerIds = {}


function Nearplayers()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local players = GetActivePlayers()

    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x,
            targetCoords.y, targetCoords.z, true)

        if distance < Config.Distance then
            table.insert(nearbyPlayerIds, GetPlayerServerId(playerId))
        end
    end

    return nearbyPlayerIds 
end



RegisterNetEvent('RSG:showPtfx', function(targetPlayerId)
    local particleTbl = {} 

    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayerId))
    if targetPed == 0 then return end

    RequestNamedPtfxAsset(Config.PTFX_DICT)
    while not HasNamedPtfxAssetLoaded(Config.PTFX_DICT) do
        Citizen.Wait(0)
    end
    for i = 1, Config.LOOP_AMOUNT do
        UseParticleFxAsset(Config.PTFX_DICT)
        local fx = StartParticleFxLoopedOnEntity(Config.PTFX_ASSET, targetPed, 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 1.5, false,
            false, false)
        table.insert(particleTbl, fx)
        Citizen.Wait(0)
    end
    Citizen.Wait(Config.PTFX_DURATION)
    for _, fx in ipairs(particleTbl) do
        StopParticleFxLooped(fx, true)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local ped = PlayerPedId()
        local isOnFire = IsEntityOnFire(ped)


        if isOnFire and not effectActive then
            if Nearplayers() then
                effectActive = true
                TriggerServerEvent('requestEffectTrigger', nearbyPlayerIds)
                Citizen.Wait(Config.PTFX_DURATION)
                effectActive = false
            end
        end
    end
end)


Citizen.CreateThread(function()
    if Config.Debug then
        RegisterCommand("triggerEffect", function()
            local nearbyPlayerIds = Nearplayers() -- Define this function
            if #nearbyPlayerIds > 0 then
                effectActive = true
                TriggerServerEvent('requestEffectTrigger', nearbyPlayerIds)
                Citizen.Wait(Config.PTFX_DURATION)
                effectActive = false
            end
        end, false)
    end
end)