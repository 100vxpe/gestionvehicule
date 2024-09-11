-- by vape

ESX = exports['es_extended']:getSharedObject()

local function toggleVehicleDoor(doorIndex)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle and vehicle ~= 0 then
        if GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0 then
            SetVehicleDoorShut(vehicle, doorIndex, false)
        else
            SetVehicleDoorOpen(vehicle, doorIndex, false, false)
        end
    else
        ESX.ShowNotification("Vous devez être dans un véhicule", "error", "3000")
    end
end

local function toggleVehicleEngine()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle and vehicle ~= 0 then
        local engineOn = GetIsVehicleEngineRunning(vehicle)
        SetVehicleEngineOn(vehicle, not engineOn, true, true)
        local status = not engineOn and "allumé" or "éteint"
        ESX.ShowNotification("Le moteur est maintenant " .. status, "success", "3000")
    else
        ESX.ShowNotification("Vous devez être dans un véhicule", "error", "3000")
    end
end

local function openVehicleMenu()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        ESX.ShowNotification(Config.Notif, "error", "3000")
        return 
    end

    local doorsSubmenu = {
        {
            title = 'Ouvrir/Fermer Porte Avant Gauche',
            icon = 'door-open',
            onSelect = function()
                toggleVehicleDoor(0)
                lib.showContext('vehicle_doors_menu')
            end
        },
        {
            title = 'Ouvrir/Fermer Porte Avant Droite',
            icon = 'door-open',
            onSelect = function()
                toggleVehicleDoor(1)
                lib.showContext('vehicle_doors_menu')
            end
        },
        {
            title = 'Ouvrir/Fermer Porte Arrière Gauche',
            icon = 'door-open',
            onSelect = function()
                toggleVehicleDoor(2)
                lib.showContext('vehicle_doors_menu')
            end
        },
        {
            title = 'Ouvrir/Fermer Porte Arrière Droite',
            icon = 'door-open',
            onSelect = function()
                toggleVehicleDoor(3)
                lib.showContext('vehicle_doors_menu')
            end
        },
        {
            title = 'Retour',
            icon = 'arrow-left',
            onSelect = function()
                lib.showContext('vehicle_menu')
            end
        }
    }

    lib.registerContext({
        id = 'vehicle_menu',
        title = 'Gestion Véhicule',
        options = {
            {
                title = 'Portes',
                icon = 'door-open',
                onSelect = function()
                    lib.showContext('vehicle_doors_menu')
                end
            },
            {
                title = 'Ouvrir/Fermer Capot',
                icon = 'wrench',
                onSelect = function()
                    toggleVehicleDoor(4)
                    lib.showContext('vehicle_menu')
                end
            },
            {
                title = 'Ouvrir/Fermer Coffre',
                icon = 'box-open',
                onSelect = function()
                    toggleVehicleDoor(5)
                    lib.showContext('vehicle_menu')
                end
            },
            {
                title = 'Allumer/Éteindre le Moteur',
                icon = 'car',
                onSelect = function()
                    toggleVehicleEngine()
                    lib.showContext('vehicle_menu')
                end
            }
        }
    })

    lib.registerContext({
        id = 'vehicle_doors_menu',
        title = 'Portes du Véhicule',
        options = doorsSubmenu
    })

    lib.showContext('vehicle_menu')
end


RegisterCommand('vehiculemenu', function()
    openVehicleMenu()
end, false)

RegisterKeyMapping('vehiculemenu', 'Menu Gestion Véhicule', 'keyboard', Config.MenuKey)

