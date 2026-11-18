local active = false
local prop = nil
local lastWeapon = nil
local disabledBy = {}            -- other resources can block it (exports.kd_mapanim:SetDisabled)
local playerEnabled = GetResourceKvpInt('kd_mapanim:off') ~= 1

local function isBlocked(ped)
    if next(disabledBy) or not playerEnabled then return true end
    local b = Config.Block
    if b.inVehicle and IsPedInAnyVehicle(ped, true) then return true end
    if b.dead and (IsEntityDead(ped) or IsPedFatallyInjured(ped)) then return true end
    if b.swimming and (IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped)) then return true end
    if b.ragdoll and (IsPedRagdoll(ped) or IsPedFalling(ped) or IsPedClimbing(ped)
        or GetPedParachuteState(ped) > 0) then return true end
    return false
end

local function loadAsset(request, hasLoaded, asset)
    request(asset)
    local timeout = GetGameTimer() + 3000
    while not hasLoaded(asset) do
        if GetGameTimer() > timeout then return false end
        Wait(0)
    end
    return true
end

local function deleteProp()
    if prop and DoesEntityExist(prop) then
        DetachEntity(prop, true, false)
        DeleteEntity(prop)
    end
    prop = nil
end

local function start(ped)
    if not loadAsset(RequestAnimDict, HasAnimDictLoaded, Config.Anim.dict) then return end
    if not loadAsset(RequestModel, HasModelLoaded, Config.Prop.model) then return end

    if Config.HolsterWeapon then
        local current = GetSelectedPedWeapon(ped)
        if current ~= `WEAPON_UNARMED` then
            lastWeapon = current
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        end
    end

    local coords = GetEntityCoords(ped)
    prop = CreateObject(Config.Prop.model, coords.x, coords.y, coords.z + 0.2, true, true, false)
    SetEntityCollision(prop, false, false)
    local o, r = Config.Prop.offset, Config.Prop.rot
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, Config.Prop.bone),
        o.x, o.y, o.z, r.x, r.y, r.z, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(Config.Prop.model)

    TaskPlayAnim(ped, Config.Anim.dict, Config.Anim.name, 3.0, 3.0, -1, Config.Anim.flag, 0, false, false, false)
    active = true
end

local function stop()
    if not active then return end
    active = false
    local ped = PlayerPedId()
    StopAnimTask(ped, Config.Anim.dict, Config.Anim.name, 2.0)
    RemoveAnimDict(Config.Anim.dict)
    deleteProp()

    if lastWeapon then
        if HasPedGotWeapon(ped, lastWeapon, false) then
            SetCurrentPedWeapon(ped, lastWeapon, true)
        end
        lastWeapon = nil
    end
end

CreateThread(function()
    while true do
        local paused = IsPauseMenuActive()
        local ped = PlayerPedId()

        if paused and not active then
            if not isBlocked(ped) then start(ped) end
        elseif active then
            if not paused or isBlocked(ped) then
                stop()
            elseif not IsEntityPlayingAnim(ped, Config.Anim.dict, Config.Anim.name, 3) then
                -- something cleared the task (e.g. another script), play it again
                TaskPlayAnim(ped, Config.Anim.dict, Config.Anim.name, 3.0, 3.0, -1, Config.Anim.flag, 0, false, false, false)
            end
        end

        Wait(active and 100 or 250)
    end
end)

if Config.Command then
    RegisterCommand(Config.Command, function()
        playerEnabled = not playerEnabled
        SetResourceKvpInt('kd_mapanim:off', playerEnabled and 0 or 1)
        if not playerEnabled then stop() end
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(('Map animation ~%s~%s'):format(
            playerEnabled and 'g' or 'r', playerEnabled and 'ON' or 'OFF'))
        EndTextCommandThefeedPostTicker(false, false)
    end, false)
end

-- Exports for other resources ------------------------------------------------

-- exports.kd_mapanim:SetDisabled(true)  -> block it (e.g. while cuffed). Each resource has its own flag.
exports('SetDisabled', function(state)
    local res = GetInvokingResource() or GetCurrentResourceName()
    disabledBy[res] = state and true or nil
    if state then stop() end
end)

exports('IsActive', function() return active end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        stop()
    elseif disabledBy[res] then
        disabledBy[res] = nil
    end
end)
