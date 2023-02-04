local currentVehicleEntity = nil
local OriginalVehicle = {}
local currentCamBone = nil
local NewVehicle = {} -- Includes cart data
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
    NewVehicle = copy(OriginalVehicle)
    --Repair
    if Config.Spots[location].allowed.repair then
        local repairMenu = {
            name = Config.Options["repair"].name,
            icon = Config.Options["repair"].icon,
            price = Config.Prices["repair"],
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
    ResetVehicleData(true)

    SetNuiFocus(showMenu, showMenu)
    OriginalVehicle = nil
    NewVehicle = nil
    currentVehicleEntity = nil
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


--Save Vehicle
function SaveVehicleData()
    local DataVehicle = {}
    for i=0, #ModTypes do 
        local mod = ModTypes[i]
        DataVehicle[mod.label] = GetVehicleMod(currentVehicleEntity, mod.num)
    end


    --check if colour is custom
    DataVehicle["Primary"] = {}
    if GetIsVehiclePrimaryColourCustom(currentVehicleEntity) then
        DataVehicle["Primary"]["colour"] = table.pack(GetVehicleCustomPrimaryColour(currentVehicleEntity))
        DataVehicle["Primary"]["custom"] = true
    else 
        local primaryColour, secondaryColour = GetVehicleColours(currentVehicleEntity)

        DataVehicle["Primary"] = {
            ["colour"] = primaryColour,
        }
    end

    --check if colour is custom
    DataVehicle["Secondary"] = {}
    if GetIsVehicleSecondaryColourCustom(currentVehicleEntity) then
        DataVehicle["Secondary"]["colour"] = table.pack(GetVehicleCustomSecondaryColour(currentVehicleEntity))
        DataVehicle["Secondary"]["custom"] = true
    else 
        local primaryColour, secondaryColour = GetVehicleColours(currentVehicleEntity)
        DataVehicle["Secondary"] = {
            ["colour"] = secondaryColour,
        }
    end

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
    local pearlescentColour, wheelColour = GetVehicleExtraColours(currentVehicleEntity)
    DataVehicle["Primary"]["pearlescent"] = pearlescentColour
    DataVehicle["wheelColour"] = wheelColour
    -- _, DataVehicle["wheelColour"] = GetVehicleExtraColours(currentVehicleEntity)

    return DataVehicle

end

--dont know of to do the reset without this, if I reset the vehicle to the original vehicle, since its a reference, it will reset the OriginalVehicle as well
function copy(table)
    local newTable = {}
    for k, v in pairs(table) do
        if type(v) == "table" then
            newTable[k] = copy(v)
        else
            newTable[k] = v
        end
    end
    return newTable

end
---@param full boolean // if true then reset to original vehicle, if false then reset to cart items
--Reset Vehicle
function ResetVehicleData(full)
    if OriginalVehicle == nil then return end
    local sourceData = full and OriginalVehicle or NewVehicle
    local vehData = copy(sourceData)
    currentCamBone = nil
    ResetCamera()
    local ignore = {
        ["Primary"] = true,
        ["Secondary"] = true,
        ["Neon"] = true,
        ["Tyre Smoke"] = true,
        ["Xenon Lights"] = true,
    }

    print("RESET VEHICLE DATA")
    --check if colour is custom
    if vehData["Primary"]["custom"] == true then
        local r, g, b = GetVehicleCustomPrimaryColour(currentVehicleEntity)
        if r ~= vehData["Primary"]["colour"][1] or g ~= vehData["Primary"]["colour"][2] or b ~= vehData["Primary"]["colour"][3] then
            SetVehicleCustomPrimaryColour(currentVehicleEntity, vehData["Primary"]["colour"][1], vehData["Primary"]["colour"][2], vehData["Primary"]["colour"][3])
        end
    else 
        local primary, secondary = GetVehicleColours(currentVehicleEntity)
        local pearlescentColour, wheelColour = GetVehicleExtraColours(currentVehicleEntity)
        if primary ~= vehData["Primary"]["colour"] then
            SetVehicleColours(currentVehicleEntity, vehData["Primary"]["colour"], vehData["Secondary"]["colour"])
            -- SetVehicleModColor_1(currentVehicleEntity, OriginalVehicle["Primary"]["paintType"], OriginalVehicle["Primary"]["colour"], OriginalVehicle["Primary"]["pearlescent"] or 0)
        end
        if pearlescentColour ~= vehData["Primary"]["pearlescent"] then
            SetVehicleExtraColours(currentVehicleEntity, vehData["Primary"]["pearlescent"], vehData["wheelColour"])
        end
    end

    --check if colour is custom
    if vehData["Secondary"]["custom"] == true then
        local r, g, b = GetVehicleCustomSecondaryColour(currentVehicleEntity)
        if r ~= vehData["Secondary"]["colour"][1] or g ~= vehData["Secondary"]["colour"][2] or b ~= vehData["Secondary"]["colour"][3] then
            SetVehicleCustomSecondaryColour(currentVehicleEntity, vehData["Secondary"]["colour"][1], vehData["Secondary"]["colour"][2], vehData["Secondary"]["colour"][3])
        end
    else 
        local primary, secondary = GetVehicleColours(currentVehicleEntity)
        if secondary ~= vehData["Secondary"]["colour"] then
            SetVehicleColours(currentVehicleEntity, vehData["Primary"]["colour"], vehData["Secondary"]["colour"])
            -- SetVehicleModColor_2(currentVehicleEntity, OriginalVehicle["Secondary"]["paintType"], OriginalVehicle["Secondary"]["colour"])
        end
    end

    for i=0, #ModTypes do 
        if not ignore[ModTypes[i].label] then
            --check if mod changed
            local prevMod = GetVehicleMod(currentVehicleEntity, ModTypes[i].num)
            if prevMod ~= OriginalVehicle[ModTypes[i].label] then
                SetVehicleMod(currentVehicleEntity, ModTypes[i].num, vehData[ModTypes[i].label])
            end 
        end
    end

    SetVehicleNeonLightEnabled(currentVehicleEntity, 0, vehData["Neon"]["enabled"][1])
    SetVehicleNeonLightEnabled(currentVehicleEntity, 1, vehData["Neon"]["enabled"][2])
    SetVehicleNeonLightEnabled(currentVehicleEntity, 2, vehData["Neon"]["enabled"][3])
    SetVehicleNeonLightEnabled(currentVehicleEntity, 3, vehData["Neon"]["enabled"][4])
    SetVehicleNeonLightsColour(currentVehicleEntity, vehData["Neon"]["colour"][1], vehData["Neon"]["colour"][2], vehData["Neon"]["colour"][3])

    SetVehicleMod(currentVehicleEntity, 20, OriginalVehicle["Tyre Smoke"]["enabled"])
    if vehData["Tyre Smoke"]["enabled"] == 1 then
        SetVehicleTyreSmokeColor(currentVehicleEntity, vehData["Tyre Smoke"]["colour"][1], vehData["Tyre Smoke"]["colour"][2], vehData["Tyre Smoke"]["colour"][3])
    end

    SetVehicleXenonLightsColor(currentVehicleEntity, vehData["Xenon Lights"]["colour"])
    vehData = nil
end




--Get ModTypes 
function GetModTypes(arr, key)
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
        if modNumMods == 0 then 
            -- optionsTable[#optionsTable + 1] = optionTable
            goto continue
        end
        -- if Config.Prices[key] 
        --check if Config.Prices[key] is a table
        local stockPrice = 0
        if type(Config.Prices[key]) == "table" then
            stockPrice = Config.Prices[key][1]
        else
            stockPrice = Config.Prices[key]
        end
        -- optionTable.options[#optionTable.options + 1] = {
        --     name = "Stock",
        --     price = stockPrice,
        --     modIndex = -1,
        --     modSlot = modTypeSlot,
        -- }
        for modIndex=0, modNumMods - 1 do
            local modName = getlabel(currentVehicleEntity, modTypeSlot, modIndex, modTypeLabel)
            local isPriceSet = false
            local price = 0
            if modIndex == 0 then
                modIndex = -1
                price = stockPrice
                isPriceSet = true
            end
            local modData = {
                name = modName,
                price = price,
                modIndex = modIndex,
                modSlot = modTypeSlot,
            }
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

        ::continue::
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

    local originalPrimary, originalSecondary = GetVehicleColours(currentVehicleEntity)
    local pearlescent, wheelColour = GetVehicleExtraColours(currentVehicleEntity)
    for i=1, #optionsTable do
        local optionTable = {}
        for k, v in pairs(Colours) do
            local category = v.label
            if category == "Pearlescent" and optionsTable[i].name == "Secondary" then
                goto continue
            end
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
                if optionsTable[i].name == "Primary" then
                    if originalPrimary == colour.num then
                        colourTable.selected = true
                    end
                else
                    if originalSecondary == colour.num then
                        colourTable.selected = true
                    end
                end
                categoryTable.options[#categoryTable.options + 1] = colourTable
            end
            optionTable[#optionTable + 1] = categoryTable
            ::continue::
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

        if modNumMods == 0 then
            goto continue
        end

        local optionTable = {
            name = modTypeLabel,
            options = {}
        }
        for modIndex=0, modNumMods - 1 do
            local modName = getlabel(currentVehicleEntity, modTypeSlot, modIndex, modTypeLabel)

            if modIndex == 0 then
                modIndex = -1
            end
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
        ::continue::
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
        SetVehicleMod(currentVehicleEntity, modType, modIndex)
        if ModTypes[modType].bone ~= nil then
            if currentCamBone == ModTypes[modType].bone then
                goto continue
            end
            currentCamBone = ModTypes[modType].bone
            local veh = currentVehicleEntity
            local boneCoords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, ModTypes[modType].bone))
            if boneCoords.x == 0 and boneCoords.y == 0 and boneCoords.z == 0 then 
                goto continue
            end
            MoveCamera(boneCoords, heading)
            ::continue::
        end 
    end
end



function PreviewColour(data)
    print(json.encode(data))
    local target = data.target
    if target == nil then return end
    local primaryCol, secondaryCol = GetVehicleColours(currentVehicleEntity)
    if data.customColour == true then
        local colour = data.colourValue
        if target == "Primary" then
            SetVehicleCustomPrimaryColour(currentVehicleEntity, colour.r, colour.g, colour.b)
            SetVehicleModColor_1(currentVehicleEntity, ColourTypes[data.type])
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
        if data.type == "Pearlescent" then
            print("pearlescent")
            SetVehicleExtraColours(currentVehicleEntity, colour, NewVehicle["wheelColour"])
        else
            SetVehicleColours(currentVehicleEntity, colour, secondaryCol)
        end
    elseif target == "Secondary" then
        SetVehicleColours(currentVehicleEntity, primaryCol, colour)
    end
end

RegisterNetEvent('xv-customs:client:repairVehicle', function()
    SetVehicleFixed(currentVehicleEntity)
end)


function UpdateCart(data)
    local isNil = next(NewVehicle)
    if isNil == nil then return end
    local newVeh = NewVehicle
    local cartItems = {}
    for i=1, #data do
        local item = data[i]
        if item.colour == true then
            local target = item.target
            if target == "Primary" then
                cartItems["Primary"] = {}
                if item.customColour == true then
                    local colour = item.colourValue
                    cartItems["Primary"]["custom"] = true
                    cartItems["Primary"]["colour"]= {r = colour.r, g = colour.g, b = colour.b}
                else
                    -- if item.pearlescent == true then
                    --     cartItems["Primary"]["pearlescent"] = item.num
                    -- else
                        -- cartItems["Primary"]["colour"] = item.num
                    -- end
                    if item.type == "Pearlescent" then
                        cartItems["Primary"]["pearlescent"] = item.num
                        print("pearlescent")
                    else
                        cartItems["Primary"]["colour"] = item.num
                    end
                end
            elseif target == "Secondary" then
                cartItems["Secondary"] = {}
                if item.customColour == true then
                    local colour = item.colourValue
                    cartItems["Secondary"]["custom"] = true
                    cartItems["Secondary"]["colour"]= {r = colour.r, g = colour.g, b = colour.b}
                else
                    cartItems["Secondary"]["colour"] = item.num
                end
            end
        else
            cartItems[item.parent] = item.modIndex
        end
    end

    for modName, val in pairs(newVeh) do
        if cartItems[modName] ~= nil then
            newVeh[modName] = cartItems[modName]
        else 
            newVeh[modName] = OriginalVehicle[modName]
        end
    end

    NewVehicle = newVeh
    ResetVehicleData(false)
end

function PurchaseCart(data)
    UpdateCart(data)
    local totalPrice = 0
    for _, item in pairs(data) do
        if item.price ~= nil then
            totalPrice = totalPrice + item.price
        end
    end
end

RegisterNetEvent("xv-customs:client:buyCart", function(data)


end)