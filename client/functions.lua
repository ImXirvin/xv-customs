local currentVehicleEntity = nil
local OriginalVehicle = {}
local currentCamBone = nil

--Main
function EnterCustom(location)
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end
    currentVehicleEntity = GetVehiclePedIsIn(ped, false)
    SetVehicleModKit(currentVehicleEntity, 0)
    local data = {
        name = location,
        options = {}
    }

    OriginalVehicle = SaveVehicleData()
    --Repair
    if Config.Spots[location].allowed.repair then
        local repairMenu = {
            name = Config.Options["repair"].name,
            icon = Config.Options["repair"].icon,
            action = "repair",
        }
        data.options[#data.options + 1] = repairMenu
    end

    --Performance
    if Config.Spots[location].allowed.perfomance then
        local perfomanceMenu = {
            name = Config.Options["perfomance"].name,
            icon = Config.Options["perfomance"].icon,
            options = GetPerformance()
        }
        print(json.encode(perfomanceMenu))
        data.options[#data.options + 1] = perfomanceMenu
    end

    --Cosmetics
    if Config.Spots[location].allowed.cosmetics then
        local cosmeticsMenu = {
            name = Config.Options["cosmetics"].name,
            icon = Config.Options["cosmetics"].icon,
            options = GetCosmetics()
        }
        data.options[#data.options + 1] = cosmeticsMenu
    end

    --Colours
    if Config.Spots[location].allowed.colours then
        local coloursMenu = {
            name = Config.Options["colours"].name,
            icon = Config.Options["colours"].icon,
            options = GetColours()
        }
        data.options[#data.options + 1] = coloursMenu
    end

    --Wheels
    if Config.Spots[location].allowed.wheels then
        local wheelsMenu = {
            name = Config.Options["wheels"].name,
            icon = Config.Options["wheels"].icon or nil,
            options = GetWheels()
        }
        data.options[#data.options + 1] = wheelsMenu
    end
    StartCamera(currentVehicleEntity)
    openMenu(data)
end



--UI
function openMenu(data)
    SendNUIMessage({
        action = "setVisible",
        data = true
    })
    SendNUIMessage({
        action = "setData",
        data = data,
    })
    SetNuiFocus(true, true)
    showMenu = true
end

function closeMenu()
    showMenu = false
    SendNUIMessage({
        action = "setVisible",
        data = showMenu
    })
    StopCamera()
    SetNuiFocus(showMenu, showMenu)
    OriginalVehicle = nil
    currentCamBone = nil
end


--Misc
local function getlabel(currentVehicleEntity, modType, modIndex, modTypeLabel)
    local label = GetLabelText(GetModTextLabel(currentVehicleEntity, modType, modIndex))
    if label == "NULL" then
        label = modTypeLabel .. " " .. modIndex + 1
    end
    return label
end



--Vehicle

-- local OriginalVehicle = nil
--Save Vehicle
function SaveVehicleData()
    local DataVehicle = {}
    for i=0, #ModTypes do 
        local mod = ModTypes[i]
        DataVehicle[mod.label] = GetVehicleMod(currentVehicleEntity, mod.num)
    end

    local paintTypePrimary, colourPrimary, pearlescentColour = GetVehicleModColor_1(currentVehicleEntity)
    DataVehicle["Primary"] = {
        ["paintType"] = paintTypePrimary,
        ["colour"] = colourPrimary,
        ["pearlescent"] = pearlescentColour,
    }
    local paintTypeSecondary, colourSecondary = GetVehicleModColor_2(currentVehicleEntity)
    DataVehicle["Secondary"] = {
        ["paintType"] = paintTypeSecondary,
        ["colour"] = colourSecondary,
    }

    DataVehicle["Neon"] = {
        ["enabled"] = {IsVehicleNeonLightEnabled(currentVehicleEntity, 0), IsVehicleNeonLightEnabled(currentVehicleEntity, 1), IsVehicleNeonLightEnabled(currentVehicleEntity, 2), IsVehicleNeonLightEnabled(currentVehicleEntity, 3)},
        ["colour"] = table.pack(GetVehicleNeonLightsColour(currentVehicleEntity)),
    }

    DataVehicle["Tyre Smoke"] = {
        ["enabled"] = GetVehicleMod(currentVehicleEntity, 20),
        ["colour"] = GetVehicleTyreSmokeColor(currentVehicleEntity),
    }

    DataVehicle["Xenon Lights"] = {
        ["colour"] = GetVehicleXenonLightsColor(currentVehicleEntity), --if 255 then disabled
    }

    return DataVehicle

end

--Reset Vehicle
function ResetVehicleData()
    if OriginalVehicle == nil then return end
    currentCamBone = nil
    ResetCamera()
    local ignore = {
        ["Primary"] = true,
        ["Secondary"] = true,
        ["Neon"] = true,
        ["Tyre Smoke"] = true,
        ["Xenon Lights"] = true,
    }
    for i=0, #ModTypes do 
        if not ignore[ModTypes[i].label] then
            --check if mod changed
            SetVehicleMod(currentVehicleEntity, ModTypes[i].num, OriginalVehicle[ModTypes[i].label])
        end
    end

    SetVehicleModColor_1(currentVehicleEntity, OriginalVehicle["Primary"]["paintType"], OriginalVehicle["Primary"]["colour"], OriginalVehicle["Primary"]["pearlescent"] or 0)
    SetVehicleModColor_2(currentVehicleEntity, OriginalVehicle["Secondary"]["paintType"], OriginalVehicle["Secondary"]["colour"])

    SetVehicleNeonLightEnabled(currentVehicleEntity, 0, OriginalVehicle["Neon"]["enabled"][1])
    SetVehicleNeonLightEnabled(currentVehicleEntity, 1, OriginalVehicle["Neon"]["enabled"][2])
    SetVehicleNeonLightEnabled(currentVehicleEntity, 2, OriginalVehicle["Neon"]["enabled"][3])
    SetVehicleNeonLightEnabled(currentVehicleEntity, 3, OriginalVehicle["Neon"]["enabled"][4])
    SetVehicleNeonLightsColour(currentVehicleEntity, OriginalVehicle["Neon"]["colour"][1], OriginalVehicle["Neon"]["colour"][2], OriginalVehicle["Neon"]["colour"][3])

    SetVehicleMod(currentVehicleEntity, 20, OriginalVehicle["Tyre Smoke"]["enabled"])
    if OriginalVehicle["Tyre Smoke"]["enabled"] == 1 then
        SetVehicleTyreSmokeColor(currentVehicleEntity, OriginalVehicle["Tyre Smoke"]["colour"][1], OriginalVehicle["Tyre Smoke"]["colour"][2], OriginalVehicle["Tyre Smoke"]["colour"][3])
    end

    SetVehicleXenonLightsColor(currentVehicleEntity, OriginalVehicle["Xenon Lights"]["colour"])
    
end




--Get ModTypes 
function GetModTypes(arr, key)
    -- print(Config.Prices[key], "key")
    local optionsTable = {}
    for i=1, #arr do
        local modType = ModTypes[arr[i]]
        local modTypeSlot = modType.num
        local modTypeLabel = modType.label
        local modNumMods = GetNumVehicleMods(currentVehicleEntity, modTypeSlot)
        local optionTable = {
            name = modTypeLabel,
            options = {}
        }
        -- if Config.Prices[key] 
        --check if Config.Prices[key] is a table
        local stockPrice = 0
        if type(Config.Prices[key]) == "table" then
            stockPrice = Config.Prices[key][1]
        else
            stockPrice = Config.Prices[key]
        end
        optionTable.options[#optionTable.options + 1] = {
            name = "Stock",
            price = stockPrice,
            modIndex = -1,
            modSlot = modTypeSlot,
        }
        for modIndex=0, modNumMods - 1 do
            local modName = getlabel(currentVehicleEntity, modTypeSlot, modIndex, modTypeLabel)
            -- print(modName)
            local modData = {
                name = modName,
                price = 0,
                modIndex = modIndex,
                modSlot = modTypeSlot,
            }
            local isPriceSet = false
            if Config.Prices[modTypeLabel] then
                if Config.Prices[modTypeLabel][modIndex] then
                modData.price = Config.Prices[modTypeLabel][modIndex]
                    isPriceSet = true
                end
            end
            if key == "performance" and not isPriceSet then
                if Config.Prices[key][modIndex+1] then
                    modData.price = Config.Prices[key][modIndex + 2]
                    isPriceSet = true
                end
            end
            if Config.Prices[key] and not isPriceSet then
                modData.price = Config.Prices[key]
                isPriceSet = true
            end

            optionTable.options[#optionTable.options + 1] = modData
        end

        local currentMod = GetVehicleMod(currentVehicleEntity, modTypeSlot)
        for i=1, #optionTable.options do
            if optionTable.options[i].modIndex == currentMod then
                optionTable.options[i].selected = true
            end
        end
        optionsTable[#optionsTable + 1] = optionTable
    end
    return optionsTable
end



--Get Performance
function GetPerformance()
    local optionsTable = GetModTypes(PerformanceIndexes, "performance")
    return optionsTable
end

--Get Cosmetics
function GetCosmetics()
    local optionsTable = GetModTypes(CosmeticIndexes, "cosmetics")
    optionsTable[#optionsTable + 1] = {
        name = "Neon",
        options = {
            {
                name = "Disabled",
                options = {
                    {
                        name = "Off",
                        price = Config.Prices["neon"],
                        action = "neon",
                    },
                    {
                        name = "On",
                        price = Config.Prices["neon"],
                        action = "neon",
                        colour = true,
                    },
                }
            },
            {
                name = "Enabled",
                price = Config.Prices["cosmetics"],
            },
        }
    }
    return optionsTable
end

--Get Colours
function GetColours()
    local optionsTable = {}
    optionsTable[#optionsTable + 1] = {
        name = "Primary",
        options = {}
    }
    optionsTable[#optionsTable + 1] = {
        name = "Secondary",
        options = {}
    }
    for i=1, #optionsTable do
        local optionTable = {}
        for k, v in pairs(Colours) do
            local category = v.label
            local categoryTable = {
                name = category,
                colour = true,
                target = optionsTable[i].name,
                options = {}
            }
            for j = 0, #v.values do
                local colour = v.values[j]
                local colourTable = {
                    name = colour.label,
                    num = colour.num,
                    price = Config.Prices["colours"],
                }
                categoryTable.options[#categoryTable.options + 1] = colourTable
            end
            optionTable[#optionTable + 1] = categoryTable
        end
        optionsTable[i].options = optionTable
    end

    local indexOptions = GetModTypes(ColourIndexes, "colours")
    for i=1, #indexOptions do
        optionsTable[#optionsTable + 1] = indexOptions[i]
    end
    local customColour = {
        name = "Custom",
        customColour = true,
    }
    --insert custom colour in the first position
    table.insert(optionsTable, 1, customColour)
    return optionsTable
end

--Get Wheels
function GetWheels()
    local optionsTable = {}
    for i=1, #WheelIndexes do
        local modType = ModTypes[WheelIndexes[i]]
        local modTypeSlot = modType.num
        local modTypeLabel = modType.label
        local modNumMods = GetNumVehicleMods(currentVehicleEntity, modTypeSlot)
        local optionTable = {
            name = modTypeLabel,
            options = {}
        }
        optionTable.options[1] = {
            name = "Stock",
            price = Config.Prices["wheels"],
            modIndex = -1,
            modSlot = modTypeSlot,
        }
        for modIndex=0, modNumMods - 1 do
            local modName = getlabel(currentVehicleEntity, modTypeSlot, modIndex, modTypeLabel)
            local modData = {
                name = modName,
                price = 0,
                modIndex = modIndex,
                modSlot = modTypeSlot,
            }
            local isPriceSet = false
            if Config.Prices[modTypeLabel] then
                if Config.Prices[modTypeLabel][modIndex] then
                modData.price = Config.Prices[modTypeLabel][modIndex]
                    isPriceSet = true
                end
            end
            if Config.Prices["wheels"]and not isPriceSet then
                modData.price = Config.Prices["wheels"]
                isPriceSet = true
            end
            optionTable.options[#optionTable.options + 1] = modData
        end
        local currentMod = GetVehicleMod(currentVehicleEntity, modTypeSlot)
        for i=1, #optionTable.options do
            if optionTable.options[i].modIndex == currentMod then
                optionTable.options[i].selected = true
            end
        end
        optionsTable[#optionsTable + 1] = optionTable
    end
    return optionsTable
end


--Vehicle Mods

--Preview Change
function PreviewChange(data)
    if data == nil then return end
    SetVehicleModKit(currentVehicleEntity, 0)
    if data.modSlot ~= nil then
        local modType = data.modSlot
        local modIndex = data.modIndex
        -- print(modType, modIndex)
        SetVehicleMod(currentVehicleEntity, modType, modIndex)
        -- print(GetVehicleMod(currentVehicleEntity, modType))
        if ModTypes[modType].bone ~= nil then
            if currentCamBone == ModTypes[modType].bone then
                goto continue
            end
            currentCamBone = ModTypes[modType].bone
            local veh = currentVehicleEntity
            local boneCoords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, ModTypes[modType].bone))
            -- print(boneCoords)
            if boneCoords.x == 0 and boneCoords.y == 0 and boneCoords.z == 0 then 
                goto continue
            end
            --find a heading that will make the camera look at the bone
            -- local heading = GetEntityHeading(veh) + 180
            
            -- print(heading)
            MoveCamera(boneCoords, heading)
            ::continue::
        end 
    end
    
    if data.colour == true then
        local target = data.target
        if target then 
            local primaryCol, secondaryCol = GetVehicleColours(currentVehicleEntity)
            if data.customColour == true then
                local colour = data.colourValue
                if target == "Primary" then
                    SetVehicleCustomPrimaryColour(currentVehicleEntity, colour.r, colour.g, colour.b)
                    SetVehicleModColor_1(currentVehicleEntity, ColourTypes[data.type])
                    print(ColourTypes[data.type])
                elseif target == "Secondary" then
                    SetVehicleCustomSecondaryColour(currentVehicleEntity, colour.r, colour.g, colour.b)
                    SetVehicleModColor_2(currentVehicleEntity, ColourTypes[data.type])
                end
                return
            end
            if GetVehicleCustomPrimaryColour(currentVehicleEntity) then
                ClearVehicleCustomPrimaryColour(currentVehicleEntity)
            end
            if GetVehicleCustomSecondaryColour(currentVehicleEntity) then
                ClearVehicleCustomSecondaryColour(currentVehicleEntity)
            end
            local colour = data.num
            if target == "Primary" then
                SetVehicleColours(currentVehicleEntity, colour, secondaryCol)
                SetVehicleModColor_1(currentVehicleEntity, ColourTypes[data.type], colour, 0)
            elseif target == "Secondary" then
                SetVehicleColours(currentVehicleEntity, primaryCol, colour)
                SetVehicleModColor_2(currentVehicleEntity, ColourTypes[data.type], colour, 0)
            end
        end
    end
end

function ResetVehicle()
    local currentVehicleEntity = GetVehiclePedIsIn(PlayerPedId(), false)
    local primaryType, primaryCol, pearl  = table.unpack(OriginalVehicle["Primary"])
    local secondaryType, secondaryCol = table.unpack(OriginalVehicle["Secondary"])
    SetVehicleColours(currentVehicleEntity, primaryCol, secondaryCol)
    SetVehicleModColor_1(currentVehicleEntity, primaryType, primaryCol, 0)
    SetVehicleModColor_2(currentVehicleEntity, secondaryType, secondaryCol, 0)
    currentCamBone = nil
end


--ACTIONS

Actions = {
    ["repair"] = function(data)
        --repair currentVehicleEntity
        SetVehicleFixed(currentVehicleEntity)
    end,

    ["mod"] = function(data)
        --mod currentVehicleEntity
        local modType = data.modSlot
        local modIndex = data.modIndex
        SetVehicleMod(currentVehicleEntity, modType, modIndex)
    end,

    ["colour"] = function(data)
        --colour currentVehicleEntity
        local colour = data.customColour and data.colourValue or data.num
        local target = data.target
        if colour then 
            local primaryCol, secondaryCol = GetVehicleColours(currentVehicleEntity)
            if target == "Primary" then
                SetVehicleColours(currentVehicleEntity, colour, secondaryCol)
                SetVehicleModColor_1(currentVehicleEntity, ColourTypes[data.type], colour, 0)
            elseif target == "Secondary" then
                SetVehicleColours(currentVehicleEntity, primaryCol, colour)
                SetVehicleModColor_2(currentVehicleEntity, ColourTypes[data.type], colour, 0)
            end
        end
    end,

    ["reset"] = function(data)
        --reset currentVehicleEntity
        ResetVehicleData()
    end,
}