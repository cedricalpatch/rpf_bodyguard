RegisterServerEvent('buy:guard')
AddEventHandler('buy:guard', function(price,gard)
    TriggerEvent('redemrp:getPlayerFromId', source, function(user,data)
    local currentMoney = user.getMoney()
    --end)
    if currentMoney >= price then
        TriggerEvent('redemrp:getPlayerFromId', source, function(user,data)
          user.removeMoney(price)
        end)
        TriggerClientEvent('loadguard', source, gard)
    else
        TriggerClientEvent('cancel', source)
    end
    end)
end)