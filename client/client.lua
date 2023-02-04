local inZoneNotMenu = false
local zones = {}

RegisterCommand('test', function()
    EnterCustom("Benny's")
end, false)


RegisterNUICallback('hideUI', function(data, cb)
    closeMenu()
    cb(1)
end)


RegisterNUICallback("PreviewChange", function(data, cb)
    PreviewChange(data)
    cb(1)
end)

RegisterNUICallback("RepairVehicle", function(data, cb)
    -- RepairVehicle()
    TriggerServerEvent('xv-customs:server:buyRepair', data)
    cb(1)
end)

RegisterNUICallback("ResetVehicle", function(data, cb)
    ResetVehicleData(false)
    print('reset')
    cb(1)
end)

RegisterNUICallback("PreviewColor", function(data, cb)
    PreviewColour(data)
    cb(1)
end)

RegisterNetEvent("FullReset", function(data, cb)
    ResetVehicleData(true)
    cb(1)
end)

RegisterNUICallback("UpdateCart", function(data, cb)
    UpdateCart(data)
    cb(1)
end)

RegisterNUICallback("PurchaseCart", function(data, cb)
    -- PurchaseCart(data)
    TriggerServerEvent('xv-customs:server:buyCart', data)
    cb(1)
end)


-- local function onEnter(self)
--     if not IsPedInAnyVehicle(ped, false) then return end
--     local location = self.name
--     inZone = true
--     lib.showTextUI('[E] - Customise vehicle')
--     while inZone do
--         Wait(0)
--         if IsControlJustPressed(0, 38) then
--             EnterCustom(location)
--             inZoneNotMenu = false
--             lib.hideTextUI()
--         end
--     end
-- end


-- for _, zone in pairs(Config.Spots) do
--     zones[zone.name] = lib.zones.box({
--         name = zone.name,
--         coords = zone.coords,
--         size = zone.size,
--         rotation = zone.rotation,
--         debug = false,
--         onExit = onExit,
--         onEnter = onEnter,
--     })
-- end

-- 