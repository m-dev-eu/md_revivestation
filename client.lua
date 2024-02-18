lib.locale()

local function spawnPed(hash, coords, scenario)
    local model = lib.requestModel(hash)
    if not model then return end

    local entity = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, false ,true)
    if scenario then TaskStartScenarioInPlace(entity, scenario, 0, true) end

    SetModelAsNoLongerNeeded(model)
    FreezeEntityPosition(entity, true)
    SetEntityInvincible(entity, true)
    SetBlockingOfNonTemporaryEvents(entity, true)

    return entity
end

local function openRevivestation()
    local paramedicCount = lib.callback.await('revivestation:getParamedicCount', false)
    if paramedicCount > Config.settings.maxParamedics then
        return Config.functions.notify({
            description = locale('max_paramedics', Config.settings.maxParamedics),
            type = 'error'
        })
    end

    local targetId, targetPed, targetCoords = lib.getClosestPlayer(cache.cooords or GetEntityCoords(cache.ped), Config.settings.maxDistance, true)
    if not targetPed or not targetId then
        return Config.functions.notify({
            description = locale('no_player_nearby'),
            type = 'error'
        })
    end

    local targetServerId = GetPlayerServerId(targetId)
    local targetDisplay = Config.settings.showName and Player(targetServerId).state.name or targetServerId

    local revivePlayer = lib.alertDialog({
        header = locale('revive_player_title'),
        content = locale('revive_player_desc', targetDisplay, Config.settings.price),
        cancel = true,
        centered = true,
    }) == 'confirm'
    if not revivePlayer then return end

    local success, msg = lib.callback.await('revivestation:checkMoney', false, Config.settings.price, targetId)
    Config.functions.notify({
        description = msg,
        type = success and 'success' or 'error'
    })
end

CreateThread(function ()
    for _, reviveStation in ipairs(Config.stations) do
        local entity = spawnPed(reviveStation.model, reviveStation.position, reviveStation.scenario)
        if Config.settings.ox_target and entity then
            exports.ox_target:addLocalEntity(entity, {
                label = locale('target_interact'),
                icon = locale('target_icon'),
                canInteract = Config.functions.canInteract,
                onSelect = function (_)
                    openRevivestation()
                end
            })
        else
            local point = lib.points.new({
                coords = reviveStation.position.xyz,
                distance = 2.0,
                onEnter = function (self)
                    Config.functions.showTextUI(locale('help_message'))
                end,
                onExit = function (self)
                    Config.functions.hideTextUI()
                end,
                nearby = function (self)
                    if IsControlJustReleased(0, 38) and Config.functions.canInteract() then
                        openRevivestation()
                    end
                end
            })
        end
    end
end)


RegisterNetEvent('revivestation:revive', function ()
    TriggerEvent(Config.settings.reviveEvent)
end)