ESX = nil
Citizen.CreateThread(function()
	while true do
		Wait(5)
		if ESX ~= nil then
		
		else
			ESX = nil
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		end
	end
end)

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
			
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	
        for k in pairs(Config.MarkerZones) do
        	local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
            local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
			if distance <= 4.50 then
				for k in pairs(Config.MarkerZones) do
		
					DrawMarker(1, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 0, 150, 150, 100, 0, 0, 0, 0)	
				end

					DisplayHelpText('E - Open Menu')
					
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
						OpenBoatsMenu(Config.MarkerZones[k].xs, Config.MarkerZones[k].ys, Config.MarkerZones[k].zs)
					end 
			elseif distance < 1.45 then
				ESX.UI.Menu.CloseAll()
            end
		end
	
		for k in pairs(Config.deleteZone) do
        	local ped 		= PlayerPedId()
        	local playerPed = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
            local vehicle 	= GetVehiclePedIsIn(playerPed, false)
            local distance 	= Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.deleteZone[k].x, Config.deleteZone[k].y, Config.deleteZone[k].z)
            if IsPedSittingInAnyVehicle(playerPed) then
				if distance <= 4.50 then
		        		letSleep = false
						DisplayHelpText('E - Delete Boat')
						
						if IsControlJustPressed(0, Keys['E']) then
							ESX.Game.DeleteVehicle(vehicle)
						end 
				elseif distance < 1.45 then
					ESX.UI.Menu.CloseAll()
		        end
		    end
        end

    end
end)

for _, info in pairs(Config.MarkerZones) do
	info.blip = AddBlipForCoord(info.x, info.y, info.z)
	SetBlipSprite(info.blip, 455)
	SetBlipDisplay(info.blip, 4)
	SetBlipScale(info.blip, 0.7)
	SetBlipColour(info.blip, 20)
	SetBlipAsShortRange(info.blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Boat Rental")
	EndTextCommandSetBlipName(info.blip)
end

function OpenBoatsMenu(x, y , z)
	local ped = PlayerPedId()
	PlayerData = ESX.GetPlayerData()
	local elements = {}
	
	
		table.insert(elements, {label = '<span style="color:white;">Dinghy</span> <span style="color:green;">$2500</span>', value = 'boat'})
		table.insert(elements, {label = '<span style="color:white;">Suntrap</span> <span style="color:green;">$3500</span>', value = 'boat6'}) 
		table.insert(elements, {label = '<span style="color:white;">Jetmax</span> <span style="color:green;">$4500</span>', value = 'boat5'}) 	
		table.insert(elements, {label = '<span style="color:white;">Toro</span> <span style="color:green;">$5500</span>', value = 'boat2'}) 
		table.insert(elements, {label = '<span style="color:white;">Marquis</span> <span style="color:green;">$6000</span>', value = 'boat3'}) 
		table.insert(elements, {label = '<span style="color:white;">Tug boat</span> <span style="color:green;">$7500</span>', value = 'boat4'})
		
	if PlayerData.job.name == "police" then
		table.insert(elements, {label = '<span style="color:white;">Police Predator</span> <span style="color:green;">$7500</span>', value = 'police'})
	end
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = 'Rent a boat',
		align    = 'bottom-right',
		elements = elements,
    },
	
	
	function(data, menu)

	if data.current.value == 'boat' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("esx_boat-rental:rentalprice", 2500) 
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "dinghy4")
	end
	
	if data.current.value == 'boat2' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("esx_boat-rental:rentalprice", 5500) 
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "TORO")
	end
	
	if data.current.value == 'boat3' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("esx_boat-rental:rentalprice", 6000) 
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "MARQUIS")
	end

	if data.current.value == 'boat4' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("esx_boat-rental:rentalprice", 7500) 
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "tug")
	end
	
	if data.current.value == 'boat5' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("esx_boat-rental:rentalprice", 4500) 
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "jetmax")
	end
	
	if data.current.value == 'boat6' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("esx_boat-rental:rentalprice", 3500) 
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "suntrap")
	end
	
	
	if data.current.value == 'police' then
		ESX.UI.Menu.CloseAll()

		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerServerEvent("esx_boat-rental:rentalprice", 7500) 
		TriggerEvent('esx:spawnVehicle', "predator")
	end
	ESX.UI.Menu.CloseAll()
	

    end,
	function(data, menu)
		menu.close()
		end
	)
end