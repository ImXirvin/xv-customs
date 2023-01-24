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
    PreviewChange(data)
    cb(1)
end)

RegisterNUICallback("ResetVehicle", function(data, cb)
    Actions["reset"](data)
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

CreateThread(function()
    while not HasStreamedTextureDictLoaded("shared") do Wait(10) RequestStreamedTextureDict("shared", true) end
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    while true do

        Wait(0)
        for _, v in pairs(ModTypes) do
            if v.bone ~= nil then
                local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, v.bone))
                --if coords is 0,0,0 then dont draw
                local str = v.bone
                if coords.x == 0 and coords.y == 0 and coords.z == 0 then 
                    goto continue
                end
                SetDrawOrigin(coords.x, coords.y, coords.z, 0)
                DrawSprite("shared", "emptydot_32", 0, 0, 0.02, 0.035, 0, 255,255,255, 255.0)
                ClearDrawOrigin()
                ::continue::
            end
        end
    end
end)


-- CreateThread(function()
--     while not HasStreamedTextureDictLoaded("shared") do Wait(10) RequestStreamedTextureDict("shared", true) end
--     while true do
--         local ped = PlayerPedId()
--         local veh = GetVehiclePedIsIn(ped, false)
--         Wait(0)
--         local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wing_l"))
--         SetDrawOrigin(coords.x, coords.y, coords.z, 0)
--         DrawSprite("shared", "emptydot_32", 0, 0, 0.02, 0.035, 0, 255,255,255, 255.0)
--         ClearDrawOrigin()
--     end
-- end)