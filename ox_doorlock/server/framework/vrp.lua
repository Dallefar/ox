local resourceName = 'vrp'

if not GetResourceState(resourceName):find('start') then return end

SetTimeout(0, function()
    local Proxy = module("vrp", "lib/Proxy")
    vRP = Proxy.getInterface("vRP")

    function RemoveItem(source, item)
        vRP.tryGetInventoryItem({vRP.getUserId({source}), item, 1})
    end

    function DoesPlayerHaveItem(source, items)
        for i = 1, #items do
            local user_id = vRP.getUserId({source})
            local item = items[i]
            if vRP.getInventoryItemAmount({user_id, item.name}) > 0 then
                if item.remove then
                    vRP.tryGetInventoryItem({user_id, item.name,1})
                end
                return item.name
            end
        end

        return false
    end
end)

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