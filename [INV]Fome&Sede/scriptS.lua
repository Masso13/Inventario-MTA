addEventHandler("onPlayerLogin", getRootElement(), function(thePreviusAccount, theCurrentAccount)
    local player = getAccountPlayer(theCurrentAccount)
    if not getElementData(player, "Fome") or false and not getElementData(player, "Sede") or false then
        setElementData(player, "Fome", 100)
        setElementData(player, "Sede", 100)
        setElementData(player, "Estamina", 500)
        triggerClientEvent("StartEstamina", getRootElement())
        outputChatBox("Fome e Sede setados", player)
    end
    setTimer(function()
        local fome = getElementData(player, "Fome") or 0
        local sede = getElementData(player, "Sede") or 0
        local estamina = getElementData(player, "Estamina") or 500
        if estamina > 250 then
            estamina = 10
        elseif estamina < 250 and estamina > 50 then
            estamina = 50
        elseif estamina < 50 then
            estamina = 75
        end
        if fome > 0 then
            setElementData(player, "Fome", fome - (fome*10e-6) * estamina)
        elseif fome > 100 then
            setElementData(player, "Fome", 100)
        elseif fome < 0 then
            setElementData(player, "Fome", 0)
        end
        if sede > 0 then
            setElementData(player, "Sede", sede - (sede*10e-5) * estamina)
        elseif sede > 100 then
            setElementData(player, "Sede", 100)
        elseif sede < 0 then
            setElementData(player, "Sede", 0)
        end

        if fome == 0 or sede == 0 then
            local vida = getElementHealth (player) or 0
            setElementHealth(player, vida - 2)
        end
    end, 5000, 0)
end, true, "low")