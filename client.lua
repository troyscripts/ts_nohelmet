local resource = GetCurrentResourceName()
local flag = 184 -- CPED_CONFIG_FLAG_PreventAutoShuffleToDriversSeat
local trackedPed, originalFlag, active, radialVisible
local bridgeErrorShown = false

local function bridgeReady() return GetResourceState('ts_bridge') == 'started' end
local function notify(message)
    if bridgeReady() then exports.ts_bridge:Notify({ description = message, type = 'error' }, 1000) end
end
local function restorePed()
    if trackedPed and DoesEntityExist(trackedPed) then
        SetPedConfigFlag(trackedPed, flag, originalFlag)
    end
    trackedPed, originalFlag = nil, nil
end
local function trackPed(ped)
    if trackedPed == ped then return end
    restorePed()
    if ped ~= 0 and DoesEntityExist(ped) then
        trackedPed, originalFlag = ped, GetPedConfigFlag(ped, flag, true)
    end
end
local function eligibility()
    local ped = PlayerPedId()
    if not bridgeReady() then return nil, nil, Config.Messages.Unavailable end
    if exports.ts_bridge:IsDead(ped) then return nil, nil, Config.Messages.Dead end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then return nil, nil, Config.Messages.NotInVehicle end
    if not IsPedInAnyVehicle(ped, false) or IsPedGettingIntoAVehicle(ped) then
        return nil, nil, Config.Messages.Unavailable
    end
    local targetSeat
    if GetPedInVehicleSeat(vehicle, -1) == ped then
        targetSeat = 0
    elseif GetPedInVehicleSeat(vehicle, 0) == ped then
        targetSeat = -1
    else
        return nil, nil, Config.Messages.FrontPassenger
    end
    -- Ook een dode inzittende houdt de doelstoel bezet; niemand wordt verwijderd.
    if not IsVehicleSeatFree(vehicle, targetSeat, true) then
        return nil, nil, Config.Messages.Occupied
    end
    -- Laat de native de animatie proberen. CanShuffleSeat is hier geen betrouwbare
    -- toelatingscontrole; een niet-ondersteunde animatie wordt door de time-out begrensd.
    return ped, vehicle, nil, targetSeat
end
local function finishShuffle(cancel)
    local state = active
    if not state then return end
    active = nil
    if DoesEntityExist(state.ped) then
        -- Annuleer uitsluitend onze nog lopende shuffle, niet een uitstap- of revive-taak.
        if cancel and PlayerPedId() == state.ped and GetVehiclePedIsIn(state.ped, false) == state.vehicle
            and GetIsTaskActive(state.ped, 165) then ClearPedTasks(state.ped) end
        SetPedConfigFlag(state.ped, flag, Config.PreventAutoShuffle or originalFlag or false)
    end
end
local function shuffle()
    if active then notify(Config.Messages.Busy); return end
    local ped, vehicle, reason, targetSeat = eligibility()
    if not ped then notify(reason); return end
    trackPed(ped)
    active = { ped = ped, vehicle = vehicle, targetSeat = targetSeat, started = GetGameTimer() }
    SetPedConfigFlag(ped, flag, false)
    TaskShuffleToNextVehicleSeat(ped, vehicle, false)
end
if Config.ShuffleCommand then RegisterCommand(Config.ShuffleCommand, shuffle, false) end

local function updateRadial(wanted)
    if not bridgeReady() then radialVisible = false; return end
    if wanted == (radialVisible == true) then return end
    local ok, result
    if wanted then
        ok, result = pcall(function()
            return exports.ts_bridge:RegisterRadialAction({ id = 'shuffle',
                label = Config.Radial.Label, icon = Config.Radial.Icon, onSelect = shuffle })
        end)
    else
        ok, result = pcall(function() return exports.ts_bridge:RemoveRadialAction('shuffle') end)
    end
    if ok and (result or not wanted) then
        radialVisible = wanted
        bridgeErrorShown = false
    elseif not bridgeErrorShown then
        print('[ts_nohelmet] Radiaaloptie niet beschikbaar. Installeer ts_bridge 1.0.9 of nieuwer.')
        bridgeErrorShown = true
    end
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if active then
            local state = active
            local sameVehicle = ped == state.ped and GetVehiclePedIsIn(ped, false) == state.vehicle
            if sameVehicle and GetPedInVehicleSeat(state.vehicle, state.targetSeat) == ped then
                finishShuffle(false)
            elseif not sameVehicle or not bridgeReady() or exports.ts_bridge:IsDead(ped)
                or (GetPedInVehicleSeat(state.vehicle, state.targetSeat) ~= 0 and GetPedInVehicleSeat(state.vehicle, state.targetSeat) ~= ped)
                or GetGameTimer() - state.started >= Config.ShuffleTimeoutMs then
                finishShuffle(true)
                notify(Config.Messages.Failed)
            end
        end
        trackPed(ped)
        if trackedPed then
            if Config.DisableAutomaticHelmet then SetPedHelmet(ped, false) end
            if active then
                SetPedConfigFlag(ped, flag, false)
            elseif Config.PreventAutoShuffle then
                SetPedConfigFlag(ped, flag, true)
            end
        end
        local eligible = false
        if Config.Radial.Enabled and not active and bridgeReady() then eligible = eligibility() ~= nil end
        updateRadial(eligible)
        Wait(active and 0 or 100)
    end
end)
AddEventHandler('onClientResourceStart', function(name)
    if name == 'ts_bridge' or name == 'ox_lib' then radialVisible = false end
end)
AddEventHandler('onClientResourceStop', function(name)
    if name == 'ts_bridge' then
        radialVisible = false
        finishShuffle(true)
    elseif name == resource then
        finishShuffle(true)
        updateRadial(false)
        restorePed()
    end
end)
