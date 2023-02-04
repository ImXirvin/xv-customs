local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('xv-customs:server:buyRepair', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = Config.Prices["repair"]
    if Player.Functions.RemoveMoney('cash', price, "vehicle-repair") then
        TriggerClientEvent('xv-customs:client:repairVehicle', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have enough cash', 'error')
    end
end)

RegisterNetEvent("xv-customs:server:buyCart", function(cart)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = 0
    local totalPrice = 0
    for _, item in pairs(cart) do
        if item.price ~= nil then
            totalPrice = totalPrice + item.price
        end
    end
    if not Player.Functions.RemoveMoney('cash', totalPrice, "vehicle-upgrade") then
        TriggerClientEvent('QBCore:Notify', src, 'You do not have enough cash', 'error')
        return
    end

    
end)