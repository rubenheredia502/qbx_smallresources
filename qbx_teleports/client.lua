local config = lib.loadJson('qbx_teleports.config')

if #config.teleports == 0 then return end

local zones = {}

AddEventHandler('onResourceStop', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for _, zone in ipairs(zones) do
        zone:remove()
    end
end)

local destination

CreateThread(function ()
    for _, passage in ipairs(config.teleports) do
        for i = 1, #passage do
            local entrance = passage[i]
            local exit = passage[(i % 2) + 1]
            local coords = vec3(entrance.coords)
            if entrance.blip == true then
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blip, entrance.blipSprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, entrance.blipColor)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(entrance.blipName)
                EndTextCommandSetBlipName(blip)
            end

            CreateThread(function()
                while true do
                    Wait(0)
                    DrawMarker(
                        entrance.markerType,              -- Tipo de marker
                        coords.x, coords.y, coords.z - 0.5,    -- Posición
                        0.0, 0.0, 0.0,                         -- Dirección
                        0.0, 0.0, 0.0,                         -- Rotación
                        0.5, 0.5, 0.5,                         -- Tamaño
                        10, 255, 116, 150,                        -- Color (verde)
                        false, true, 2, nil, nil, false        -- Otros params
                    )
                end
            end)

            -- Zona de entrada
            zones[#zones+1] = lib.zones.sphere({
                coords = coords,
                radius = 2,
                onEnter = function ()
                    lib.showTextUI(entrance.drawText)
                    destination = {
                        coords = vec(exit.coords),
                        ignoreGround = exit.ignoreGround,
                        allowVehicle = entrance.allowVehicle,
                        progressBar = entrance.progressBar or nil
                    }
                end,
                onExit = function ()
                    lib.hideTextUI()
                    destination = nil
                end
            })
        end
    end
end)


local keybind

local function onPressed()
    keybind:disable(true)

    if destination then
        if destination.progressBar then
            local success = lib.progressBar({
                duration = destination.progressBar.duration or 3000,
                label = destination.progressBar.label or 'Usando pasaje...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                    combat = true,
                    car = true
                }
            })

            if not success then
                keybind:disable(false)
                return
            end
        end

        local coordZ = destination.coords.z

        if not destination.ignoreGround then
            local isSafe, z = GetGroundZFor_3dCoord(
                destination.coords.x,
                destination.coords.y,
                destination.coords.z,
                false
            )

            if isSafe then coordZ = z end
        end

        if destination.allowVehicle and cache.vehicle then
            SetPedCoordsKeepVehicle(
                cache.ped,
                destination.coords.x,
                destination.coords.y,
                coordZ
            )

            SetVehicleOnGroundProperly(cache.vehicle)
        else
            SetEntityCoords(
                cache.ped,
                destination.coords.x,
                destination.coords.y,
                coordZ,
                true, false, false, false
            )
        end

        if type(destination.coords) == 'vector4' then
            SetEntityHeading(cache.ped, destination.coords.w)
        end
    end

    keybind:disable(false)
end



keybind = lib.addKeybind({
    name = 'passage',
    description = 'entry through passage',
    defaultKey = 'E',
    secondaryMapper = 'PAD_DIGITALBUTTONANY',
    secondaryKey = 'LRIGHT_INDEX',
    onPressed = onPressed
})
