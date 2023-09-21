loadstring(exports.dgs:dgsImportFunction())()

local font = dgsCreateFont(":include/src/fonts/font.ttf", 13)
local is_visible = false
local is_showing = false
local slot_selected = nil
local icons = edit.icons
local mochila = {}

--[[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]]
local InvHUD = {}

function renderSlots()
    for i = 1, 42 do
        local item = nil
        if mochila["slots"]["slot"..i] then
            item = mochila["slots"]["slot"..i].item
        else
            item = "Vazio"
        end
        InvHUD["slots"]["slot"..i] = dgsCreateImage(slotsposi["slot"..i].x, slotsposi["slot"..i].y, slotReso["w"], slotReso["h"], icons[item], true, InvHUD.Inv)
    end
end


function InvDgs()
    InvHUD["slots"] = {}
    InvHUD["Inv"] = dgsCreateWindow(0.23, 0.25, 0.54, 0.58, "INVENTÁRIO", true)
    dgsSetProperty(InvHUD.Inv, "font", font)

    renderSlots()
    
    InvHUD["progressBarBackGround"] = dgsCreateImage(0.01, 0.875, 0.55, slotReso["h"] / 2, _, true, InvHUD.Inv)
    dgsSetProperty(InvHUD.progressBarBackGround, "color", tocolor(0, 0 , 0, 127.5))
    local peso = mochila.peso or 0
    local pesoMaximo = mochila.pesoMaximo or 40
    local percent = (peso * 100) / pesoMaximo
    local barra = (percent / 100) * 0.25
    InvHUD["progressBarValue"] = dgsCreateImage(0.01, 0.875, barra, slotReso["h"] / 2, _, true, InvHUD.Inv)
    dgsSetProperty(InvHUD.progressBarValue, "color", tocolor(255, 0, 0))
    InvHUD.peso = dgsCreateLabel(0.01, 0.875, 0.56, slotReso["h"] / 2, string.format("%.2f", peso).."Kg | "..pesoMaximo.."Kg", true, InvHUD.Inv)
    dgsSetProperty(InvHUD.peso, "font", font)
    dgsSetProperty(InvHUD.peso, "alignment", {"center", "center"})
    --renderIntemSelected()
    
    addEventHandler("onDgsWindowClose", InvHUD.Inv, CancelClose, true, "low")
end

function renderIntemSelected()
    local item = mochila["slots"][slot_selected].item or "Vazio"
    local quantidade = mochila["slots"][slot_selected].quantidade or 1
    local peso = mochila["slots"][slot_selected].peso or 0
    InvHUD["selecionadoHUD"] = {}
    InvHUD["selecionadoHUD"]["fundo"] = dgsCreateImage(0.59, 0.02, 0.40, 0.91, _, true, InvHUD.Inv)
    dgsSetProperty(InvHUD.selecionadoHUD.fundo, "color", tocolor(0, 0 , 0, 178,5))
    InvHUD["selecionadoHUD"]["preview"] = dgsCreateImage(0.03, 0.02, 0.94, 0.48, icons[item], true, InvHUD.selecionadoHUD.fundo)
    --dgsSetProperty(InvHUD.selecionadoHUD.preview, "color", tocolor(105, 105, 105, 127.5))
    InvHUD["selecionadoHUD"]["botao"] = dgsCreateButton(0.03, 0.91, 0.94, 0.07, "USAR | EQUIPAR", true, InvHUD.selecionadoHUD.fundo, _, _, _, _, _, _, tocolor(255, 0, 0, 127.5), tocolor(255, 99, 71, 127.5), tocolor(255, 99, 71, 127.5))
    dgsSetProperty(InvHUD.selecionadoHUD.botao, "font", font)
    InvHUD["selecionadoHUD"]["item"] = dgsCreateLabel(0.03, 0.52, 0.93, 0.04, "ITEM: "..item, true, InvHUD.selecionadoHUD.fundo)
    dgsSetProperty(InvHUD.selecionadoHUD.item, "font", font)
    dgsSetProperty(InvHUD.selecionadoHUD.item, "alignment", {"center", "center"})
    InvHUD["selecionadoHUD"]["quantidade"] = dgsCreateLabel(0.03, 0.64, 0.93, 0.04, "QUANTIDADE: "..quantidade, true, InvHUD.selecionadoHUD.fundo)
    dgsSetProperty(InvHUD.selecionadoHUD.quantidade, "font", font)
    dgsSetProperty(InvHUD.selecionadoHUD.quantidade, "alignment", {"center", "center"})
    InvHUD["selecionadoHUD"]["peso"] = dgsCreateLabel(0.03, 0.76, 0.93, 0.04, "PESO: "..string.format("%.2f", peso).."Kg", true, InvHUD.selecionadoHUD.fundo)
    dgsSetProperty(InvHUD.selecionadoHUD.peso, "font", font)
    dgsSetProperty(InvHUD.selecionadoHUD.peso, "alignment", {"center", "center"})
end

function CancelClose()
    cancelEvent()
    destroyElement(InvHUD.Inv)
    showCursor(false)
    InvHUD = {}
end

--[[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]]
function usarItem(item, quantidade, slot)
    if quantidade > 0 and item ~= "Vazio" then
        triggerServerEvent("Mochila:usarItem", localPlayer, item, slot)
    end
end

addEvent("requestClientTable", true)
addEventHandler("requestClientTable", getRootElement(), function(table)
    mochila = table
    if InvHUD.Inv then
        renderSlots()
    end
end, true, "high")
--[[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]]

--[[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]]
addEventHandler("onDgsMouseDown", getRootElement(),
    function(button, x, y)
        if is_visible and button == "left"then
            if not is_showing then
                for slot in pairs(InvHUD["slots"]) do
                    if source == InvHUD["slots"][slot] then
                        local item = nil
                        if mochila["slots"][slot] then
                            item = mochila["slots"][slot].item
                        else
                            item = "Vazio"
                        end
                        if item and item ~= "Vazio" then
                            slot_selected = slot
                            renderIntemSelected()
                            is_showing = true
                            break
                        end
                    end
                end
            else
                local item = nil
                if mochila["slots"][slot_selected] then
                    item = mochila["slots"][slot_selected].item
                else
                    item = "Vazio"
                end
                if InvHUD.selecionadoHUD then
                    destroyElement(InvHUD.selecionadoHUD.fundo)
                end
                is_showing = false
            end
            if InvHUD.selecionadoHUD and source == InvHUD.selecionadoHUD.botao then
                local item = nil
                if mochila["slots"][slot_selected] then
                    item = mochila["slots"][slot_selected].item
                else
                    item = "Vazio"
                end
                if item and item ~= "Vazio" then
                    local quantidade = mochila["slots"][slot_selected].quantidade or 1
                    usarItem(item, quantidade, slot_selected)
                end
            end
        end
    end, true, "low")

bindKey("i", "down", function()
    local is_equiped = mochila["equipada"] or false
    if is_equiped then
        if InvHUD.Inv then
            if isElement(InvHUD.Inv) then
                removeEventHandler("onDgsWindowClose", InvHUD.Inv, CancelClose)
                destroyElement(InvHUD.Inv)
                showCursor(false)
                if InvHUD.selecionadoHUD then
                    if isElement(InvHUD.selecionadoHUD.fundo) then
                        destroyElement(InvHUD.selecionadoHUD.fundo)
                        InvHUD["selecionadoHUD"] = nil
                        is_showing = false
                    end
                end
                is_visible = false
                InvHUD = {}
            end
        else
            InvDgs()
            showCursor(true)
            is_visible = true
        end
    else
        outputChatBox("X-X-X-X-X-X-Nenhuma Mochila Equipada-X-X-X-X-X-X", client)
    end
end)
--[[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]]




addCommandHandler("setItem", function(commandName, playerName, tipo, item_input)
    triggerServerEvent("Mochila:setarItem", localPlayer, playerName, tipo, item_input)
end)