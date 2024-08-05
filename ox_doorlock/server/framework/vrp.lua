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
