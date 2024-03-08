local resourceName = 'vrp'

if not GetResourceState(resourceName):find('start') then return end



SetTimeout(0, function()
    local Tunnel = module("vrp", "lib/Tunnel")
    local Proxy = module("vrp", "lib/Proxy")

    vRPclient = Tunnel.getInterface("vRP", "ox_doorlock") 
    vRP = Proxy.getInterface("vRP")

    function RemoveItem(source, item)
        local user_id = vRP.getUserId({source})

        if user_id then 
            vRP.tryGetInventoryItem({user_id,item,1})
        end
    end

    --[[function DoesPlayerHaveItem(player, items)
        for i = 1, #items do
            local item = items[i]
            local data = player.getInventoryItem(item.name)

            if data?.count > 0 then
                if item.remove then
                    player.removeInventoryItem(item.name, 1)
                end

                return item.name
            end
        end

        return false]]
    function DoesPlayerHaveItem(source, items)
        for i = 1, #items do
            local user_id = vRP.getUserId({source})
            local item = items[i]
            print(json.encode(items[i]))
            if vRP.getInventoryItemAmount({user_id,item.name}) > 0 then
                if item.remove then
                    vRP.tryGetInventoryItem({user_id,item.name,1})
                end
                return item.name
            end
        end

        return false
    end
end)

function GetCharacterId(source)
    return vRP.getUserId({source})
end

function IsPlayerInGroup(source, filter)
    local user_id = vRP.getUserId({source})
    local type = type(filter)
    if type == 'string' then
        if vRP.hasGroup({user_id, filter}) then
            return vRP.hasGroup({user_id, filter}), 0
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for groupName, _ in pairs(filter) do
                if vRP.hasGroup({user_id, groupName}) then
                    return vRP.hasGroup({user_id, groupName}), 0
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if vRP.hasGroup({user_id, filter[i]}) then
                    return vRP.hasGroup({user_id, filter[i]}), 0
                end
            end
        end
    end
end