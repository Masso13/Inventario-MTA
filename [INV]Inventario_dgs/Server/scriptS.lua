memoria = {}

function getTypeItemFromData(player, slot)
    local resultado
    if memoria[player].Mochila.slots[slot] then
        resultado = memoria[player].Mochila.slots[slot].tipo
    else
        resultado = false
    end
    return resultado
end

function getDataFromType(player, tipo)
    local resultado
    if memoria[player] then
        resultado = memoria[player].Mochila[tipo]
    else
        resultado = false
    end
    return resultado
end

addEvent("Mochila:setarItem", true)
addEventHandler("Mochila:setarItem", getRootElement(), function(playername, tipo, item_input)
    local player = getPlayerFromName(playername)
    local account = getAccountName(getPlayerAccount(getPlayerFromName(playername)))
    local slots = getDataFromType(account, "slots")
    if slots then
        if itens[tipo][item_input] then
            if table.getn(slots) <= 36 then
                for i = 1, 42 do
                    if not slots["slot"..i] then
                        local quantidade = nil
                        if not itens[tipo][item_input].acumulavel then
                            quantidade = 1
                        else
                            quantidade = itens[tipo][item_input].quantidade
                        end
                        local peso = getDataFromType(account, "peso")
                        local pesoTotal = peso + quantidade * itens[tipo][item_input].peso
                        local pesoMaximo = getDataFromType(account, "pesoMaximo")
                        if pesoTotal < pesoMaximo then
                            memoria[account]["Mochila"]["slots"]["slot"..i] = {}
                            memoria[account]["Mochila"]["slots"]["slot"..i]["item"] = item_input
                            memoria[account]["Mochila"]["slots"]["slot"..i]["tipo"] = tipo
                            memoria[account]["Mochila"]["slots"]["slot"..i]["quantidade"] = quantidade
                            memoria[account]["Mochila"]["slots"]["slot"..i]["peso"] = quantidade * itens[tipo][item_input].peso
                            if tipo == "Armamentos" then
                                memoria[account]["Mochila"]["slots"]["slot"..i]["calibre"] = itens[tipo][item_input].calibre
                            end
                            memoria[account]["Mochila"]["peso"] = pesoTotal
                            triggerClientEvent(player, "requestClientTable", root, memoria[account]["Mochila"])
                            triggerClientEvent(client, "add:notification", root, "Setado "..item_input.." no slot"..i.." Quantidade setada: "..quantidade, "success", true)
                        end
                        break
                    end
                end
            else
                triggerClientEvent(client, "add:notification", root, "Mochila Cheia", "warn", true)
            end
        else
            triggerClientEvent(client, "add:notification", root, "Este Item não existe", "warn", true)
        end
    end
end, true, "low")

addEvent("Mochila:usarItem", true)
addEventHandler("Mochila:usarItem", getRootElement(), function(item_input, slot)
    local account = getAccountName(getPlayerAccount(client))
    local tipo = getTypeItemFromData(account, slot)
    if tipo then
        if tipo == "Armamentos" then
            local weaponSlot = getPedWeapon(client)
            local armaEquipada = getElementData(client, "Armamento:Equipado:"..itens[tipo][item_input].tipo) or false
            if weaponSlot ~= itens[tipo][item_input].id and not armaEquipada then
                local muni = memoria[account]["Mochila"]["slots"][slot]["muni"] or 1
                giveWeapon(client, itens[tipo][item_input].id, muni, true)
                setElementData(client, "Armamento:Equipado:"..itens[tipo][item_input].tipo, true)
                local pesoMochila = memoria[account]["Mochila"]["peso"]
                local pesoTotal = pesoMochila - itens[tipo][item_input].peso
                if pesoTotal < 0 then
                    pesoTotal = 0
                end
                memoria[account]["Mochila"]["peso"] = pesoTotal
                memoria[account]["Mochila"]["slots"][slot] = nil
                triggerClientEvent(client, "requestClientTable", root, memoria[account]["Mochila"])
                triggerClientEvent(client, "add:notification", root, "Arma Equipada com sucesso", "success", true)
            else
                triggerClientEvent(client, "add:notification", root, "Arma Equipada ou Tipo Equipado", "warn", true)
            end
        elseif tipo == "Munições" then
            for item_list in pairs(itens["Armamentos"]) do
                local weaponSlot = getPedWeapon(client)
                if weaponSlot == itens["Armamentos"][item_list].id then
                    if item_input == itens["Armamentos"][item_list].calibre then
                        local muni = getPedTotalAmmo(client)
                        local quantidade = memoria[account]["Mochila"]["slots"][slot]["quantidade"] or 1
                        if muni < quantidade * 2 then
                            if setWeaponAmmo(client, itens["Armamentos"][item_list].id, muni + quantidade) then
                                local pesoMochila = memoria[account]["Mochila"]["peso"] or 0
                                local pesoTotal = pesoMochila - itens[tipo][item_input].peso * quantidade
                                if pesoTotal < 0 then
                                    pesoTotal = 0
                                end
                                memoria[account]["Mochila"]["peso"] = pesoTotal
                                memoria[account]["Mochila"]["slots"][slot] = nil
                                triggerClientEvent(client, "requestClientTable", root, memoria[account]["Mochila"])
                                triggerClientEvent(client, "add:notification", root, "Setado "..quantidade.." munições de "..item_input.." para "..item_list, "success", true)
                            end
                        else
                            triggerClientEvent(client, "add:notification", root, "Sua Arma não precisa de Munição", "warn", true)
                        end
                    else
                        triggerClientEvent(client, "add:notification", root, "Munição Errada", "error", true)
                    end
                    break
                end
            end
        elseif tipo == "Alimentos" then
            local info = getElementData(client, itens["Alimentos"][item_input].alteracao)
            if info < 100 then
                local quantidade = memoria[account]["Mochila"]["slots"][slot].quantidade or 1
                local valor = info + itens["Alimentos"][item_input].valor * quantidade
                if valor > 100 then
                    valor = 100
                end
                if setElementData(client, itens["Alimentos"][item_input].alteracao, valor) then
                    local pesoMochila = memoria[account]["Mochila"]["peso"] or 0
                    local pesoTotal = pesoMochila - itens[tipo][item_input].peso * quantidade
                    if pesoTotal < 0 then
                        pesoTotal = 0
                    end
                    memoria[account]["Mochila"]["peso"] = pesoTotal
                    memoria[account]["Mochila"]["slots"][slot] = nil
                    triggerClientEvent(client, "requestClientTable", root, memoria[account]["Mochila"])
                end
            else
                triggerClientEvent(client, "add:notification", root, "Você não está com "..itens["Alimentos"][item_input].alteracao, "error", true)
            end
        else
            triggerClientEvent(client, "add:notification", root, "Este Item não pode ser Usado", "error", true)
        end
    end
end, true, "low")

addEvent("Mochila:guardarItem", true)
addEventHandler("Mochila:guardarItem", getRootElement(), function()
    local arma = getPedWeapon(client)
    if arma ~= 0 then
        local account = getAccountName(getPlayerAccount(client))
        local slots = getDataFromType(account, "slots")
        for i = 1, 42 do
            if not slots["slot"..i] then
                for item_list in pairs(itens["Armamentos"]) do
                    if arma == itens["Armamentos"][item_list].id then
                        local peso = getDataFromType(account, "peso") or 0
                        local pesoTotal = peso + 1 * itens["Armamentos"][item_list].peso
                        local pesoMaximo = getDataFromType(account, "pesoMaximo")
                        local muni = getPedTotalAmmo(client)
                        if pesoTotal < pesoMaximo then
                            memoria[account]["Mochila"]["slots"]["slot"..i] = {}
                            memoria[account]["Mochila"]["slots"]["slot"..i]["item"] = item_list
                            memoria[account]["Mochila"]["slots"]["slot"..i]["tipo"] = "Armamentos"
                            memoria[account]["Mochila"]["slots"]["slot"..i]["muni"] = muni
                            memoria[account]["Mochila"]["slots"]["slot"..i]["calibre"] = itens["Armamentos"][item_list].calibre
                            memoria[account]["Mochila"]["peso"] = pesoTotal
                            triggerClientEvent(client, "requestClientTable", root, memoria[account]["Mochila"])
                            takeWeapon(client, arma)
                            removeElementData(client, "Armamento:Equipado:"..itens["Armamentos"][item_list].tipo)
                            triggerClientEvent(client, "add:notification", root, "Armamento Guardado", "success", true)
                        else
                            triggerClientEvent(client, "add:notification", root, "Sua mochila está cheia", "warn", true)
                        end
                        break
                    end
                end
                break
            end
        end
    end
end, true, "low")

addEvent("setPlayerInTable", true)
addEventHandler("setPlayerInTable", getRootElement(), function(player)
    memoria[player] = {}
    memoria[player]["Mochila"] = {}
    memoria[player]["Mochila"]["pesoMaximo"] = PesoMaximo
    memoria[player]["Mochila"]["peso"] = 0
    memoria[player]["Mochila"]["slots"] = {}
end, true, "low")

addEventHandler("onPlayerWasted", getRootElement(), 
    function(...)
        for item_list in pairs(itens["Armamentos"]) do
            local is_equiped = getElementData(source, "Armamento:Equipado:"..itens["Armamentos"][item_list].tipo) or false
            if is_equiped then
                removeElementData(source, "Armamento:Equipado:"..itens["Armamentos"][item_list].tipo)
            end
        end
    end
)

--[[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]]
addEventHandler("onPlayerLogin", getRootElement(), function(thePreviusAccount, theCurrentAccount)
    if not memoria[getAccountName(theCurrentAccount)] then
        triggerEvent("setPlayerInTable", getRootElement(), getAccountName(theCurrentAccount))
        memoria[getAccountName(theCurrentAccount)]["Mochila"]["equipada"] = true
    end
    triggerClientEvent(source, "requestClientTable", root, memoria[getAccountName(theCurrentAccount)]["Mochila"])
end, true, "low")