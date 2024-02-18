lib.locale()

lib.callback.register('revivestation:getParamedicCount', function (source)
    return #ESX.GetExtendedPlayers('job', Config.paramedicJobs)
end)

lib.callback.register('revivestation:checkMoney', function (source, price, targetId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then return false, locale('player_not_online') end

    if xPlayer.getAccount(Config.settings.account).money < price then
        return false, locale('not_enough_money')
    end

    local isDead = MySQL.scalar.await('SELECT is_dead FROM users WHERE identifier = ?', {xTarget.getIdentifier()})
    if not isDead then
        return false, locale('player_not_dead')
    end

    xPlayer.removeAccountMoney(Config.settings.account, price)
    TriggerClientEvent('revivestation:revive', targetId)

    return true, locale('revive_player_success')
end)