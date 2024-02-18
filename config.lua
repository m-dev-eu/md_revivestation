Config = {
    settings = {
        ox_target = GetResourceState('ox_target') == 'started',
        maxParamedics = 2,
        showName = true, -- if false it shows id
        maxDistance = 5.0,
        price = 3000,
        account = 'money',
        reviveEvent = 'esx_ambulancejob:revive'
    },
    paramedicJobs = {'ambulance', 'firefighters'},
    stations = {
        {model = 's_m_m_paramedic_01', position = vec4(-1708.8206, -2841.4849, 12.9444, 141.4918), scenario = nil}
    },
    functions = {
        notify = lib.notify,
        showTextUI = lib.showTextUI,
        hideTextUI = lib.hideTextUI,
        canInteract = function ()
            return not IsPedInAnyVehicle(cache.ped, false) and not IsEntityDead(cache.ped)
        end
    }
}