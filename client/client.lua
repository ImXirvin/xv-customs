local inZoneNotMenu = false
local zones = {}

RegisterCommand('test', function()
    EnterCustom("Benny's")
end, false)


RegisterNUICallback('hideUI', function(data, cb)
    closeMenu()
    cb('ok')
end)


RegisterNUICallback("PreviewChange", function(data, cb)
    -- print('PreviewChange')
    PreviewChange(data)
    cb(1)
end)

RegisterNUICallback("ResetColour", function(data, cb)
    ResetColour()
    cb(1)
end)



local function onEnter(self)
    if not IsPedInAnyVehicle(ped, false) then return end
    local location = self.name
    inZone = true
    lib.showTextUI('[E] - Customise vehicle')
    while inZone do
        Wait(0)
        if IsControlJustPressed(0, 38) then
            EnterCustom(location)
            inZoneNotMenu = false
            lib.hideTextUI()
        end
    end
end

local function onExit(self)
    inZoneNotMenu = false
    print('exit')
    lib.hideTextUI()
end

RegisterCommand('hidetext', function()
    onExit()
end, false)

for _, zone in pairs(Config.Spots) do
    zones[zone.name] = lib.zones.box({
        name = zone.name,
        coords = zone.coords,
        size = zone.size,
        rotation = zone.rotation,
        debug = false,
        onExit = onExit,
        onEnter = onEnter,
    })
end