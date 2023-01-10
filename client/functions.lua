local veh = nil

--Main
function EnterCustom(location)
    local ped = PlayerPedId()
    veh = GetVehiclePedIsIn(ped, false)
    SetVehicleModKit(veh, 0)
    local data = {
        name = location,
        options = {}
    }
    SaveVehicleData()
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
end

function closeMenu()
    showMenu = false
    SendNUIMessage({
        action = "setVisible",
        data = showMenu
    })
    SetNuiFocus(showMenu, showMenu)
    OriginalVehicle = nil
end


--Misc
local function getlabel(veh, modType, modIndex, modTypeLabel)
    local label = GetLabelText(GetModTextLabel(veh, modType, modIndex))
    if label == "NULL" then
        label = modTypeLabel .. " " .. modIndex + 1
    end
    return label
end



--Vehicle

local OriginalVehicle = nil
--Save Vehicle
function SaveVehicleData()
    OriginalVehicle = {}
    for i=0, #ModTypes do 
        local mod = ModTypes[i]
        OriginalVehicle[mod.label] = GetVehicleMod(veh, mod.num)
    end

    local paintTypePrimary, colourPrimary, pearlescentColour = GetVehicleModColor_1(veh)
    OriginalVehicle["Primary"] = {
        ["paintType"] = paintTypePrimary,
        ["colour"] = colourPrimary,
        ["pearlescent"] = pearlescentColour,
    }
    local paintTypeSecondary, colourSecondary = GetVehicleModColor_2(veh)
    OriginalVehicle["Secondary"] = {
        ["paintType"] = paintTypeSecondary,
        ["colour"] = colourSecondary,
    }

    OriginalVehicle["Neon"] = {
        ["enabled"] = {IsVehicleNeonLightEnabled(veh, 0), IsVehicleNeonLightEnabled(veh, 1), IsVehicleNeonLightEnabled(veh, 2), IsVehicleNeonLightEnabled(veh, 3)},
        ["colour"] = table.pack(GetVehicleNeonLightsColour(veh)),
    }

    OriginalVehicle["Tyre Smoke"] = {
        ["enabled"] = GetVehicleMod(veh, 20),
        ["colour"] = GetVehicleTyreSmokeColor(veh),
    }

    OriginalVehicle["Xenon Lights"] = {
        ["colour"] = GetVehicleXenonLightsColor(veh), --if 255 then disabled
    }
end

--Reset Vehicle
function ResetVehicleData()
    local ignore = {
        ["Primary"] = true,
        ["Secondary"] = true,
        ["Neon"] = true,
        ["Tyre Smoke"] = true,
        ["Xenon Lights"] = true,
    }
    for i=0, #ModTypes do 
        if not ignore[ModTypes[i].label] then
            SetVehicleMod(veh, ModTypes[i].num, OriginalVehicle[ModTypes[i].label])
        end
    end

    SetVehicleModColor_1(veh, OriginalVehicle["Primary"]["paintType"], OriginalVehicle["Primary"]["colour"], OriginalVehicle["Primary"]["pearlescent"] or 0)
    SetVehicleModColor_2(veh, OriginalVehicle["Secondary"]["paintType"], OriginalVehicle["Secondary"]["colour"])

    SetVehicleNeonLightEnabled(veh, 0, OriginalVehicle["Neon"]["enabled"][1])
    SetVehicleNeonLightEnabled(veh, 1, OriginalVehicle["Neon"]["enabled"][2])
    SetVehicleNeonLightEnabled(veh, 2, OriginalVehicle["Neon"]["enabled"][3])
    SetVehicleNeonLightEnabled(veh, 3, OriginalVehicle["Neon"]["enabled"][4])
    SetVehicleNeonLightsColour(veh, OriginalVehicle["Neon"]["colour"][1], OriginalVehicle["Neon"]["colour"][2], OriginalVehicle["Neon"]["colour"][3])

    SetVehicleMod(veh, 20, OriginalVehicle["Tyre Smoke"]["enabled"])
    SetVehicleTyreSmokeColor(veh, OriginalVehicle["Tyre Smoke"]["colour"][1], OriginalVehicle["Tyre Smoke"]["colour"][2], OriginalVehicle["Tyre Smoke"]["colour"][3])

    SetVehicleXenonLightsColor(veh, OriginalVehicle["Xenon Lights"]["colour"])
end





--Get Performance
function GetPerformance()
    local optionsTable = {}
    for i=1, #PerformanceIndexes do
        local modType = ModTypes[PerformanceIndexes[i]]
        local modTypeSlot = modType.num
        local modTypeLabel = modType.label
        local modNumMods = GetNumVehicleMods(veh, modTypeSlot)
        local optionTable = {
            name = modTypeLabel,
            options = {}
        }
        optionTable.options[#optionTable.options + 1] = {
            name = "Stock",
            price = Config.Prices["performance"][1],
            modIndex = -1,
            modSlot = modTypeSlot,
        }
        for modIndex=0, modNumMods - 1 do
            local modName = getlabel(veh, modTypeSlot, modIndex, modTypeLabel)
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
            if Config.Prices["performance"] and not isPriceSet then
                if Config.Prices["performance"][modIndex+1] then
                    modData.price = Config.Prices["performance"][modIndex + 2]
                    isPriceSet = true
                end
            end
            if Config.Prices["performance"][1] and not isPriceSet then
                modData.price = Config.Prices["performance"][1]
                isPriceSet = true
            end
            -- print(#optionTable.options)
            optionTable.options[#optionTable.options + 1] = modData
        end

        local currentMod = GetVehicleMod(veh, modTypeSlot)
        for i=1, #optionTable.options do
            if optionTable.options[i].modIndex == currentMod then
                optionTable.options[i].selected = true
            end
        end
        optionsTable[#optionsTable + 1] = optionTable
    end
    return optionsTable
end

--Get Cosmetics
function GetCosmetics()
    local optionsTable = {}
    for i=1, #CosmeticIndexes do
        local modType = ModTypes[CosmeticIndexes[i]]
        local modTypeSlot = modType.num
        local modTypeLabel = modType.label
        local modNumMods = GetNumVehicleMods(veh, modTypeSlot)
        local optionTable = {
            name = modTypeLabel,
            options = {}
        }
        optionTable.options[#optionTable.options + 1] = {
            name = "Stock",
            price = Config.Prices["cosmetics"],
            modIndex = -1,
            modSlot = modTypeSlot,
        }

        for modIndex=0, modNumMods - 1 do
            local modName = getlabel(veh, modTypeSlot, modIndex, modTypeLabel)
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
            if Config.Prices["cosmetics"]and not isPriceSet then
                modData.price = Config.Prices["cosmetics"]
                isPriceSet = true
            end
            optionTable.options[#optionTable.options + 1] = modData
        end
        local currentMod = GetVehicleMod(veh, modTypeSlot)
        for i=1, #optionTable.options do
            if optionTable.options[i].modIndex == currentMod then
                optionTable.options[i].selected = true
            end
        end
        optionsTable[#optionsTable + 1] = optionTable
    end

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
    -- print(json.encode(optionsTable, {indent = true}))
    
    --ADD Colour Indexes
    for i=1, #ColourIndexes do
        local modType = ModTypes[ColourIndexes[i]]
        local modTypeSlot = modType.num
        local modTypeLabel = modType.label
        local modNumMods = GetNumVehicleMods(veh, modTypeSlot)
        local optionTable = {
            name = modTypeLabel,
            options = {}
        }
        optionTable.options[#optionTable.options + 1] = {
            name = "Stock",
            price = Config.Prices["colours"],
            modIndex = -1,
            modSlot = modTypeSlot,
        }
        for modIndex=0, modNumMods  - 1 do
            local modName = getlabel(veh, modTypeSlot, modIndex, modTypeLabel)
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
            if Config.Prices["colours"]and not isPriceSet then
                modData.price = Config.Prices["colours"]
                isPriceSet = true
            end
            optionTable.options[#optionTable.options + 1] = modData
        end
        local currentMod = GetVehicleMod(veh, modTypeSlot)
        for i=1, #optionTable.options do
            if optionTable.options[i].modIndex == currentMod then
                optionTable.options[i].selected = true
            end
        end
        optionsTable[#optionsTable + 1] = optionTable
    end
    return optionsTable
end

--Get Wheels
function GetWheels()
    local optionsTable = {}
    for i=1, #WheelIndexes do
        local modType = ModTypes[WheelIndexes[i]]
        local modTypeSlot = modType.num
        local modTypeLabel = modType.label
        local modNumMods = GetNumVehicleMods(veh, modTypeSlot)
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
            local modName = getlabel(veh, modTypeSlot, modIndex, modTypeLabel)
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
        local currentMod = GetVehicleMod(veh, modTypeSlot)
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
    SetVehicleModKit(veh, 0)

    if data.modSlot ~= nil then
        local modType = data.modSlot
        local modIndex = data.modIndex
        print(modType, modIndex)
        SetVehicleMod(veh, modType, modIndex)
        print(GetVehicleMod(veh, modType))
    end
    
    if data.colour == true then
        print("Colour")
        local colour = data.num
        local target = data.target
        if colour then 
            local primaryCol, secondaryCol = GetVehicleColours(veh)
            if target == "Primary" then
                SetVehicleColours(veh, colour, secondaryCol)
                SetVehicleModColor_1(veh, ColourTypes[data.type], colour, 0)
            elseif target == "Secondary" then
                SetVehicleColours(veh, primaryCol, colour)
                SetVehicleModColor_2(veh, ColourTypes[data.type], colour, 0)
            end
        end
    end
end

function ResetColour()
    local primaryType, primaryCol, pearl  = table.unpack(OriginalVehicle["Primary"])
    local secondaryType, secondaryCol = table.unpack(OriginalVehicle["Secondary"])
    SetVehicleColours(veh, primaryCol, secondaryCol)
    SetVehicleModColor_1(veh, primaryType, primaryCol, 0)
    SetVehicleModColor_2(veh, secondaryType, secondaryCol, 0)
end