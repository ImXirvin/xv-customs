local running = false
local camDistance = 5.0
local cam = nil
local angleY = 0.0
local angleZ = 0.0
local targetCoords = nil
local oldCam = nil
local currentcurrentVehicleEntityEntity = nil
local originalCoords = nil
local changingCam = false

local function cos(degrees)
    return math.cos(degrees * math.pi / 180)
end

local function sin(degrees)
    return math.sin(degrees * math.pi / 180)
end

local function SetCamPosition(mouseX, mouseY)
    if not running then return end
    if not targetCoords then return end
    if changingCam then return end 
    -- local mouseX = GetControlNormal(0, 1) * 8.0 -- 8x multiplier to make it more sensitive
    -- local mouseY = GetControlNormal(0, 2) * 8.0

    local mouseX = mouseX or 0.0 --and mouseX * 5.0 or 0.0
    local mouseY = mouseY or 0.0 --and mouseY * 5.0 or 0.0

    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    angleY = math.clamp(angleY, 0.0, 89.0) -- >=90 degrees will flip the camera, < 0 is underground

    local offset = vec3(
        ((cos(angleZ) * cos(angleY)) + (cos(angleY) * cos(angleZ))) / 2 * camDistance,
        ((sin(angleZ) * cos(angleY)) + (cos(angleY) * sin(angleZ))) / 2 * camDistance,
        ((sin(angleY))) * camDistance
    )

    local camPos = vec3(targetCoords.x + offset.x, targetCoords.y + offset.y, targetCoords.z + offset.z)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(cam, targetCoords.x, targetCoords.y, targetCoords.z)
end

RegisterNUICallback("move", function(data, cb)
    -- print(data.x, data.y)
    SetCamPosition(data.x, data.y)
    cb(1)
end)

RegisterNUICallback("zoom", function(data, cb)
    if camDistance + data < 1.0 then
        cb(0)
        return
    end
    if camDistance + data > 7.0 then
        cb(0)
        return
    end
    camDistance = camDistance + data
    -- print(camDistance)
    SetCamPosition()
    cb(1)
end)

local function DisableActions(currentVehicleEntity)
    local currentVehicleEntity = currentVehicleEntity
    CreateThread(function()
        SetEntityInvincible(currentVehicleEntity, true)
        FreezeEntityPosition(currentVehicleEntity, true)
        while running do
            DisableControlAction(0, 1, true) -- MouseUp
            DisableControlAction(0, 2, true) -- MouseDown   
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 106, true) -- Disable steering in currentVehicleEntity with Mouse
            --leave currentVehicleEntity
            DisableControlAction(0, 75, true) -- Disable exit currentVehicleEntity
            --disable pause
            DisableControlAction(0, 199, true) -- Disable pause
            DisableControlAction(0, 200, true) -- Disable pause
            DisableControlAction(0, 298, true) -- Disable pause
            --disable radio controls
            DisableControlAction(0, 19, true) -- Disable radio
            DisableControlAction(0, 81, true) -- Disable radio
            DisableControlAction(0, 82, true) -- Disable radio
            DisableControlAction(0, 83, true) -- Disable radio
            DisableControlAction(0, 84, true) -- Disable radio
            DisableControlAction(0, 85, true) -- Disable radio
            SetPauseMenuActive(false)
            Wait(0)
        end
        SetPauseMenuActive(false)
        SetNuiFocusKeepInput(false)
        SetEntityInvincible(currentVehicleEntity, false)
        FreezeEntityPosition(currentVehicleEntity, false)
    end)
end

function StartCamera(currentVehicleEntity)
    if running then return end
    running = true
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    RenderScriptCams(true, true, 500, 1, 0)
    targetCoords = GetEntityCoords(currentVehicleEntity)
    originalCoords = targetCoords
    SetCamPosition()
    SetNuiFocusKeepInput(true)
    DisableActions(currentVehicleEntity)
end

function StopCamera()
    if not running then return end
    running = false
    RenderScriptCams(false, true, 500, 1, 0)
    DestroyCam(cam, true)
end

function MoveCamera(coords, heading)
    print("moving camera camHandler")
    -- if changingCam then return end
    local coords = coords
    changingCam = true
    camDistance = 2.0
    -- SetCamPosition()
    angleZ = heading or angleZ
    --switch to new cam
    oldCam = cam
    local offset = vec3(
        ((cos(angleZ) * cos(angleY)) + (cos(angleY) * cos(angleZ))) / 2 * camDistance,
        ((sin(angleZ) * cos(angleY)) + (cos(angleY) * sin(angleZ))) / 2 * camDistance,
        ((sin(angleY))) * camDistance
    )
    local camPos = vec3(coords.x + offset.x, coords.y + offset.y, coords.z + offset.z)
    local newcam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0, 70.0, false, 0)
    PointCamAtCoord(newcam, coords.x, coords.y, coords.z)
    SetCamActiveWithInterp(newcam, oldCam, 500, true, true)
    Wait(500)
    targetCoords = coords
    changingCam = false
    cam = newcam
    SetCamPosition()
    DestroyCam(oldCam, true)
end

function ResetCamera()
    if originalCoords == nil then return end
    print("resetting camera camHandler")
    changingCam = true
    camDistance = 5.0
    oldCam = cam

    local offset = vec3(
        ((cos(angleZ) * cos(angleY)) + (cos(angleY) * cos(angleZ))) / 2 * camDistance,
        ((sin(angleZ) * cos(angleY)) + (cos(angleY) * sin(angleZ))) / 2 * camDistance,
        ((sin(angleY))) * camDistance
    )
    local camPos = vec3(originalCoords.x + offset.x, originalCoords.y + offset.y, originalCoords.z + offset.z)
    
    local newcam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0, 70.0, false, 0)
    PointCamAtCoord(newcam, originalCoords.x, originalCoords.y, originalCoords.z)
    SetCamActiveWithInterp(newcam, oldCam, 500, true, true)
    Wait(500)
    targetCoords = originalCoords
    changingCam = false
    cam = newcam
    SetCamPosition()
    DestroyCam(oldCam, true)
end