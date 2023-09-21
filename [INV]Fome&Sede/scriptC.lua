local stamina = 500
local stamina_MAX = 500

function staminaCycle ( )
    if getPedMoveState ( localPlayer ) == "stand" then
        stamina = stamina+5
    elseif getPedMoveState ( localPlayer ) == "walk" then
        stamina = stamina+5
    elseif getPedMoveState ( localPlayer ) == "powerwalk" then
        stamina = stamina+4
    elseif getPedMoveState ( localPlayer ) == "jog" then
        stamina = stamina+3
    elseif getPedMoveState ( localPlayer ) == "sprint" then
        stamina = stamina-8
    elseif getPedMoveState ( localPlayer ) == "jump" then
        stamina = stamina-15
    elseif getPedMoveState ( localPlayer ) == "crouch" then
        stamina = stamina+8
    else
        stamina = stamina+1
    end

    if stamina > stamina_MAX then
        stamina = stamina_MAX
    end
    if stamina > 20 then
        toggleControl("jump", true)
    end
    if stamina > 100 then
        toggleControl("sprint", true)
    end
    if stamina < 0 then
        toggleControl("jump", false)
        toggleControl("sprint", false)
        stamina = 0
    end
    setElementData(localPlayer, "Estamina", stamina)
end

addEvent("StartEstamina", true)
addEventHandler ( "StartEstamina", resourceRoot, function()
    setTimer(staminaCycle, 200, 0)
end, true, "low")
