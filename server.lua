ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_boat-rental:rentalprice")
AddEventHandler("esx_boat-rental:rentalprice", function(money)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(money)
	xPlayer.showNotification('You rented a boat for $' .. ESX.Math.GroupDigits(money))
end)