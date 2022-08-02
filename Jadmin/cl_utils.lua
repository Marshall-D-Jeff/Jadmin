--[[
    INSTRUCTION BUTTONS
    BY ILLUSIVETEA
    GITHUB https://gist.github.com/IllusiveTea/c9e33f678586b02f68315c7ca3ceec33
]]

local function ButtonMessage(text)
    BeginTextCommandScaleformString(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform, data)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    for n, btn in next, data do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(n-1)
        Button(GetControlInstructionalButton(2, btn.control, true))
        ButtonMessage(btn.name)
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    return scaleform
end

TriggerEvent('chat:addSuggestion', '/tpa', "TP quelqu'un a un endroit spécifique", {
    { name="ID", help= "l'id du mec ?"},
    { name="type", help= "Ou le TP ?"},
})

RegisterNetEvent('jeffCommand:tpa')
AddEventHandler('jeffCommand:tpa', function(type)
    if type == ''..Config.TpaCommand1..'' then
        SetEntityCoords(PlayerPedId(), vector3(215.76, -810.12, 30.73))
    elseif type == ''..Config.TpaCommand2..'' then
        SetEntityCoords(PlayerPedId(), vector3(293.58, -597.83, 43.27))
    elseif type == ''..Config.TpaCommand3..'' then
        SetEntityCoords(PlayerPedId(), vector3(-75.287750244141, -818.49688720703, 326.17514038086))
    elseif type == ''..Config.TpaCommand4..'' then
        SetEntityCoords(PlayerPedId(), vector3(427.33917236328, -981.65747070313, 30.710050582886))
    elseif type == ''..Config.TpaCommand5..'' then
        SetEntityCoords(PlayerPedId(), vector3(105.56105804443, -154.32400512695, 54.834178924561))
    elseif type == ''..Config.TpaCommand6..'' then
        SetEntityCoords(PlayerPedId(), vector3(373.45001220703, -1610.5899658203, 29.288070678711))
    else
        print("Cet endroit n'existe pas")
    end
end)

local form = nil
local data = {}

local entries = {}

function SetInstructions()
    form = setupScaleform("instructional_buttons", entries)
end

function SetInstructionalButton(name, control, enabled)
    local found = false
    for k, entry in next, entries do
        if entry.name == name and entry.control == control then
            found = true
            if not enabled then
                table.remove(entries, k)
                SetInstructions()
            end
            break
        end
    end
    if not found then
        if enabled then
            table.insert(entries, {name = name, control = control})
            SetInstructions()
        end
    end
end

Citizen.CreateThread(function()
    while true do
        if form then
            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
        end
        Wait(0)
    end
end)
