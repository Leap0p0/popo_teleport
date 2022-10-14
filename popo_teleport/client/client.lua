ESX = nil
local teleportpoint = {}
local name = nil
local name_suppr = nil
local first_place = nil
local second_place = nil
local builder = {
    first_coord = nil,
    second_coord = nil
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RMenu.Add("teleport", "categorie", RageUI.CreateMenu("Souhaitez-vous", "~b~ Créer / Supprimer"))
RMenu:Get("teleport", "categorie").Closed = function()
end

RMenu.Add("teleport", "create", RageUI.CreateSubMenu(RMenu:Get("teleport", "categorie"), _U('create_point'), nil))
RMenu:Get("teleport", "create").Closed = function()
    second_place = "~r~❌"
    first_place = "~r~❌"
    name = nil
    builder.teleport_name = nil
    first_place = nil
    second_place = nil
    builder.first_coord = nil
    builder.second_coord = nil
end

RMenu.Add("teleport", "delete", RageUI.CreateSubMenu(RMenu:Get("teleport", "categorie"), _U('delete_point'), nil))
RMenu:Get("teleport", "delete").Closed = function()end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

local function teleport()
    while true do
        local interval = 500
        local pos = GetEntityCoords(PlayerPedId())
        for i, teleportpoints in pairs(teleportpoint) do
            local a = teleportpoints.first_coord
            local b = teleportpoints.second_coord
            
            --POINT A--
            local dist = #(pos - a)
                if (dist <= 100) then
                    interval = 0
                    DrawMarker(25, a.x, a.y, (a.z - 0.98), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, true, 2, false, false, false, false)
                    if (dist <= 10) then
                        AddTextEntry("try", _U('open'))
                        DisplayHelpTextThisFrame("try", false)
                        if (IsControlJustPressed(0, 51)) then
                            SetEntityCoords(PlayerPedId(), b)
                        end
                    end
                end
    
            --POINT B--
            dist = #(pos - b)
                if (dist <= 100) then
                    interval = 0
                    DrawMarker(25, b.x, b.y, (b.z - 0.98), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, true, 2, false, false, false, false)
                    if (dist <= 1) then
                        AddTextEntry("tryb", _U('open'))
                        DisplayHelpTextThisFrame("tryb", false)
                        if (IsControlJustPressed(0, 51)) then
                            SetEntityCoords(PlayerPedId(), a)
                        end
                    end
                end
        end
        Wait(interval)
    end
end



--open the menu in RageUI--

local function openMenu()

    RageUI.Visible(RMenu:Get("teleport","categorie"), true)
    Citizen.CreateThread(function()
        while true do
            --Create / Delete--
            RageUI.IsVisible(RMenu:Get("teleport","categorie"),true,true,true,function()
                RageUI.Button("Créer" , "Créer", {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                    end
                end, RMenu:Get("teleport", "create"))
                RageUI.Button("Supprimer" , "Supprimer", {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                    end
                end, RMenu:Get("teleport", "delete"))
            end, function()end)

            --Create Menu--
            RageUI.IsVisible(RMenu:Get("teleport","create"),true,true,true,function()
                RageUI.Button(_U('name') , _U('name'), {RightLabel = builder.teleport_name}, true,function(h,a,s)
                    if (s) then
                        name = KeyboardInput("POPO_BOX", _U('name'), "", 15)
                        if name and name ~= "" then
                            builder.teleport_name = tostring(name)
						    builder.teleport_name = string.lower(string.gsub(builder.teleport_name, "%s+", "_"))
                            print(builder.teleport_name)
                        end
                    end
                end)
			    if builder.first_coord == nil then 
				    first_place = "~r~❌"
			    else 
				    first_place = "~b~✅"
			    end 
                RageUI.Button(_U('first_point') , _U('first_point'), {RightLabel = first_place}, true,function(h,a,s)
                    if (s) then
                        local Ped = PlayerPedId()
					    local pedCoords = GetEntityCoords(Ped)
                        builder.first_coord = pedCoords
                        print(builder.first_coord)
                        ESX.ShowNotification(_U('first'))
                    end
                end)
			    if builder.second_coord == nil then 
				    second_place = "~r~❌"
			    else 
				    second_place = "~b~✅"
			    end 
                RageUI.Button(_U('second_point') , _U('second_point'), {RightLabel = second_place}, true,function(h,a,s)
                    if (s) then
                        local Ped = PlayerPedId()
					    local pedCoords = GetEntityCoords(Ped)
                        builder.second_coord = pedCoords
                        print(builder.second_coord)
                        ESX.ShowNotification(_U('second'))
                    end
                end)
                RageUI.Button(_U('create') , _U('create'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                        if second_place == "~b~✅" and first_place == "~b~✅" then
                            ESX.ShowNotification(_U('good_create')..builder.teleport_name.._U('good_create_bis'))
                            TriggerServerEvent('popo_teleport:register_tp_point', builder)
                            second_place = "~r~❌"
                            first_place = "~r~❌"
                            name = nil
                            builder.teleport_name = nil
                            first_place = nil
                            second_place = nil
                            builder.first_coord = nil
                            builder.second_coord = nil
                        else
                            ESX.ShowNotification(_U('no'))
                        end
                    end
                end)
            end, function()end, 1)

             --Delete Menu--
             RageUI.IsVisible(RMenu:Get("teleport","delete"),true,true,true,function()
                RageUI.Button(_U('name') , _U('name'), {RightLabel = name_suppr}, true,function(h,a,s)
                    if (s) then
                        name_suppr = KeyboardInput("POPO_BOX_BIS", _U('name'), "", 15)
                        name_suppr = tostring(name_suppr)
						name_suppr = string.lower(string.gsub(name_suppr, "%s+", "_"))
                    end
                end)
                RageUI.Button(_U('delete'), _U('delete'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                        if name_suppr and name_suppr ~= "" then
                            for i, points in pairs(teleportpoint) do
                                if points.teleport_name and name_suppr == points.teleport_name then
                                    ESX.ShowNotification(_U('good_delete')..points.teleport_name.._U('good_delete_bis'))
                                    TriggerServerEvent('popo_teleport:remove_tp_point', points)
                                end
                            end
                        else
                            ESX.ShowNotification(_U('no_bis'))
                        end
                    end
                end)
            end, function()end, 1)
            Citizen.Wait(0)
        end
    end)
end


RegisterNetEvent("popo_teleport:newtppoint", function(zone)
    table.insert(teleportpoint, zone)
end)

RegisterNetEvent("popo_teleport:nbpoint", function(zones)
    teleportpoint = zones
    teleport()
end)

RegisterCommand("teleportbuilder", function()
    openMenu()
end, false)

SetTimeout(1500, function()
    xPlayer = ESX.GetPlayerData()
    TriggerServerEvent("popo_teleport:requestZones")
end)