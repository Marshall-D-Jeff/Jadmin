ESX = nil
local items = {}
local allReport = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
		for k, v in pairs(result) do
			items[k] = { label = v.label, name = v.name }
		end
	end)
end)

ESX.RegisterServerCallback('finalmenuadmin:getAllItems', function(source, cb)
	cb(items)
end)

RegisterCommand('tpa', function(source, args, rawCommand)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    if group == "superadmin" or group == "admin" or group == "_dev" or group == "owner" then
    if player ~= false then
        TriggerClientEvent('jeffCommand:tpa', args[1], args[2])
    end
end
end, false)

RegisterCommand(Config.Command, function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local isAllowed = false
        for _,group in pairs(Config.AllowedGroups) do
            if group == xPlayer.getGroup() then
                isAllowed = true
                break
            end
        end

        if isAllowed then
            TriggerClientEvent('relisoft_players:drawText',source)
        else
            TriggerEvent('chat:addMessage', source, { args = { '', '' }, color = { 255, 50, 50 } })
        end
    end
end)


TriggerEvent('es:addGroupCommand', 'noclip', "admin", function(source, args, user)
end, {help = "Met ou enlève le noclip zebi"})


RegisterNetEvent("finalmenuadmin:giveItem")
AddEventHandler("finalmenuadmin:giveItem", function(target, itemName, qty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        xPlayer.addInventoryItem(itemName, tonumber(qty))
        Config.notif = Config.TF
        if Config.notif then
            TriggerClientEvent('okokNotify:Alert', source, "Administration", "Give de %sx %s au joueur %s effectué", 5000, 'succes')
        else
            TriggerClientEvent("esx:showNotification", source, ("Give de ~o~%sx %s ~s~au joueur ~o~%s ~s~effectué"):format(qty, ESX.GetItemLabel(itemName), GetPlayerName(target)))
        end
    else
        Config.notif = Config.TF
        if Config.notif then
            TriggerClientEvent('okokNotify:Alert', "Administration", "Ce joueur n'est plus connecté ", 5000, 'error')
        else
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Administration', '~b~Give', '~r~Ce joueur n\'est plus connecté', 'CHAR_JEFF')
        end
    end
end)

RegisterNetEvent("Jmessage:sendMsg")
AddEventHandler("Jmessage:sendMsg", function(id, msg)
    local _src = id
    local xPlayer = ESX.GetPlayerFromId(_src)
    Config.notif = Config.TF
    if Config.notif then
        TriggerClientEvent('okokNotify:Alert', _src, "Administration", ""..msg.. "", 10000, 'phonemessage')
    else
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Administration', '~b~Message', msg, 'CHAR_JEFF')
    end
end)

RegisterNetEvent("Jannonce:annonceServer")
AddEventHandler("Jannonce:annonceServer", function(msg)
    TriggerClientEvent("Jannonce:annonceServerClient", -1, msg, true)
    Citizen.Wait(10000)
    TriggerClientEvent("Jannonce:annonceServerClient", -1, nil, false)
end)

ESX.RegisterServerCallback('rxwMenuAdmin:getAllReport', function(source, cb)
    cb(allReport)
    print(json.encode(allReport))
end)

if Config.Report then
    RegisterCommand("report", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if source then
            if #allReport > 0 then
            for k,v in pairs(allReport) do
                if v.idPlayer == source then
                    xPlayer.showNotification("vous avez ~r~déjà ~s~un report ouvert !")
                    --[[Config.notif = Config.TF
                    if Config.notif then
                        TriggerClientEvent('okokNotify:Alert', "Administration", "Vous avez déjà un report d'ouvert !", 5000, 'warning')
                    else
                        TriggerClientEvent('esx:showAdvancedNotification', 'Administration', '~b~Report', 'Vous avez ~r~déjà ~s~un report d\'ouvert !', 'CHAR_JEFF')
                    end]]--
                else
                    table.insert(allReport, {
                        namePlayer = xPlayer.getName(),
                        reasonReport = table.concat(args, " "),
                        idPlayer = source
                    })
                    xPlayer.showNotification("Votre report a été ~g~envoyé ~~!")
                    sendNotifyStaff("Un nouveau report a été ~g~envoyé ~s~!")
                end
            end
            else
                table.insert(allReport, {
                    namePlayer = xPlayer.getName(),
                    reasonReport = table.concat(args, " "),
                    idPlayer = source
                })
                xPlayer.showNotification("Votre report a été ~g~envoyé ~s~!")
                sendNotifyStaff("Un nouveau report a été ~g~envoyé ~s~!")
            end
        end
    end, false)

    
else
    RegisterCommand("report", function(source, args)
        TriggerClientEvent('esx:showAdvancedNotification', 'Administration', '~b~Report', 'Les reports sont en stand by', 'CHAR_JEFF')
    end, false)
end



RegisterServerEvent("rxwMenuAdmin:closeReport")
AddEventHandler("rxwMenuAdmin:closeReport", function(idReport, idPlayer)
    local _src = idPlayer
    local xPlayer = ESX.GetPlayerFromId(_src)
    table.remove(allReport, idReport)
    sendNotifyStaff("Le report de ~o~"..xPlayer.getName().." ~s~à été ~r~clôturé")
end)

function sendNotifyStaff(msg)
    local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.getGroup() == "mod" or thePlayer.getGroup() == "admin" or thePlayer.getGroup() == "superadmin" or thePlayer.getGroup() == "_dev" or thePlayer.getGroup() == "owner" then
            TriggerClientEvent("esx:showNotification", xPlayers[i], msg)
        end
	end
end

RegisterNetEvent('Ise_Logs2')
AddEventHandler('Ise_Logs2', function(Color, Title, Description)
	Ise_Logs2(Color, Title, Description)
end)

RegisterNetEvent('Ise_Logs3')
AddEventHandler('Ise_Logs3', function(Webhook, Color, Title, Description)
	Ise_Logs3(Webhook, Color, Title, Description)
end)

function Ise_Logs2(Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = Name,
	                ["icon_url"] = Logo,
	            },
	        }
	    }
	PerformHttpRequest(WebHook2, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

function Ise_Logs3(webhook3, Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = Name,
	                ["icon_url"] = Logo,
	            },
	        }
	    }
	PerformHttpRequest(webhook3, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('adminmenu:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)
  
	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout(),
			money = xPlayer.getMoney()
		}
  
		cb(data)
	end
end)
  


ESX.RegisterServerCallback('rxwMenuAdmin:getPlayerInfos', function(source, cb, id)
	local _src = id
    local xPlayer = ESX.GetPlayerFromId(_src)

    local allInfos = {
        namePlayer = xPlayer.getName(),
        inventory = xPlayer.getInventory(),
        job1 = xPlayer.job.name.." "..xPlayer.job.grade_name,
        job2 = xPlayer.job2.name.." "..xPlayer.job2.grade_name,
        moneyAmount = xPlayer.getMoney(),
        bankAmount = xPlayer.getAccount('bank').money,
        saleAmount = xPlayer.getAccount('black_money').money,
    }

    cb(allInfos)
end)



ESX.RegisterServerCallback('RubyMenu:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	print(GetPlayerName(source).." - "..group)
	cb(group)
end)

platenum = math.random(00001, 99998)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local r = math.random(00001, 99998)
		platenum = r
	end
end)


RegisterServerEvent("vAdmin:GiveCash")
AddEventHandler("vAdmin:GiveCash", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addMoney((total))

	local item = '$'
	local message = 'GIVE de '
	--TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
    TriggerClientEvent('okokNotify:Alert', _source, "Administration", ""..message .. total .. item.."", 5000, 'success')
end)

RegisterServerEvent("vAdmin:GiveBanque")
AddEventHandler("vAdmin:GiveBanque", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('bank', total)

	local item = '$ en banque'
	local message = 'GIVE de '
	--TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
    TriggerClientEvent('okokNotify:Alert', _source, "Administration", ""..message .. total .. item.."", 5000, 'success')
end)

RegisterServerEvent("vAdmin:GiveND")
AddEventHandler("vAdmin:GiveND", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('black_money', total)

	local item = '$ sale.'
	local message = 'GIVE de '
	
    --TriggerClientEvent('esx:showNotification', _source, message..total..item)
    TriggerClientEvent('okokNotify:Alert', _source, "Administration", ""..message .. total .. item.."", 5000, 'success')
end)

RegisterServerEvent('tp')
AddEventHandler('tp', function(money)
        ExecuteCommand("tp 221.2 -806.21 30.68 ")
end)


RegisterNetEvent("msg:Message")
AddEventHandler("msg:Message", function(id, type)
	TriggerClientEvent("msg:envoyer", id, type)
end)

KickPerso = "ADMIN SYSTEM -"

RegisterServerEvent('vStaff:KickPerso')
AddEventHandler('vStaff:KickPerso', function(target, msg)
    name = GetPlayerName(source)
    DropPlayer(source,target, msg)
end)


function NoIdent(ident)
    if ident == 'steam:11' then
        return true
    else
        return false
    end
end

function SendWebhookMessageMenuStaff(webhook,message)
	webhook = "https://discord.com/api/webhooks/994943867147264062/os-DlX8VIQglTvkpOadr0dwnOslyVLWG8d-j8r-W5zQjNtzrRA8NQF9QxG31N4xyjTbY"
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent("AdminMenu:StaffOnOff")
AddEventHandler("AdminMenu:StaffOnOff", function(status)

	local xPlayers	= ESX.GetPlayers()
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.getIdentifier()

	for i=1, #xPlayers, 1 do
          local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          if NoIdent(ident) == false then
              if status == true then
                   TriggerClientEvent('chatMessage', xPlayers[i], 'Citylife', {255, 0, 0}, "Un staff vient de passer un mode modération : "..source..".")
                   print(status)
              elseif status == false then
                   TriggerClientEvent('chatMessage', xPlayers[i], 'Citylife', {255, 0, 0}, "Un staff vient de quitter le mode modération : "..source..".")
                   print(status)
              end
		 end
	end
end)


RegisterServerEvent("logMenuAdmin")
AddEventHandler("logMenuAdmin", function(option)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ident = xPlayer.getIdentifier()
    	local date = os.date('*t')

    	if date.day < 10 then date.day = '0' .. tostring(date.day) end
    	if date.month < 10 then date.month = '0' .. tostring(date.month) end
    	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    	if date.min < 10 then date.min = '0' .. tostring(date.min) end
    	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    	name = GetPlayerName(source)
    	if ident == 'steam:11' then--Special character in username just crash the server
			print('Ignoring error.')
    	else
    		print('Staff: '..name.." used "..option..".")
    		SendWebhookMessageMenuStaff(webhook,"**Menu Admin Utilisé** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.." \nOption activé: "..option.."\n+ Date: " .. date.day .. "." .. date.month .. "." .. date.year .. " - " .. date.hour .. ":" .. date.min .. ":" .. date.sec .. "\n[Detection #".. platenum .."].```")
    	end
end)


RegisterServerEvent("kickAllPlayer2")
AddEventHandler("kickAllPlayer2", function()
	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()
	TriggerEvent('SavellPlayerAuto')
	Citizen.Wait(2000)
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		DropPlayer(xPlayers[i], 'BlueVinity Administration | RESTART DU SERVEUR. Vous avez été exlus du serveur avant son restart pour sauvgarder votre personnage\nMerci d\'attendre le message comme quoi le serveur à restart sur le discord avant de vous connecté')
	end


end)

RegisterServerEvent("jeff:teleportcoords")
AddEventHandler("jeff:teleportcoords", function(id, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" or xPlayer.getGroup() == "owner" then
        PerformHttpRequest(function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "``TP GARAGE``\n```\nNom : " .. GetPlayerName(source) .. "\nAction : Tp sur garage ! " .. "\n\n" .. "Nom de la personne : " .. GetPlayerName(id) .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("jeff:teleport", id, vector3(215.76, -810.12, 30.73))
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterNetEvent('xAdmin:reviveall')
AddEventHandler('xAdmin:reviveall', function()
    local source = source if source ~= nil then TriggerClientEvent('xAdmin:revive', -1) end
end)

RegisterServerEvent("deleteVehAll")
AddEventHandler("deleteVehAll", function()
	TriggerClientEvent("RemoveAllVeh", -1)
end)

RegisterServerEvent("spawnVehAll")
AddEventHandler("spawnVehAll", function()
	TriggerClientEvent("SpawnAllVeh", -1)
end)



--RegisterServerEvent("SavellPlayer")
--AddEventHandler("SavellPlayer", function(source)
--	local _source = source
--	local xPlayer = ESX.GetPlayerFromId(_source)
--	--ESX.SavePlayers(cb)
--	ESX.SavePlayer(xPlayer, cb)
--	print('^2Save de '..xPlayer..' ^3Effectué')
--	--for i=1, #xPlayers, 1 do
--	--	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
--	--	--TriggerClientEvent('esx:showNotification', xPlayers[i], '✅ Synchronisation inventaire effectuée.')
--	--end
--
--
--end)


RegisterServerEvent("SavellPlayerAuto")
AddEventHandler("SavellPlayerAuto", function()
	ESX.SavePlayers(cb)
	--print('^2Save des joueurs ^3Effectué')
	TriggerClientEvent('okokNotify:Alert', "Info Citylife", "Save des joueurs effectuée ", 5000, 'info')
end)


count = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		count = count + 1

		if count >= 240 then
			ESX.SavePlayers(cb)
			--print('^2Save des joueurs ^3Effectué')
			TriggerClientEvent('okokNotify:Alert', "Info Citylife", "Save des joueurs effectuée ", 5000, 'info')
			count = 0
		end
	end
end)

Pz_admin = {

    ranks = {
        [2] = {
            label = "Admin", 
            color = "~r~",
            outfit = 4,
            permissions = {
                1,2,3,4,5,6,7,8, -- Interactions civiles
                
                9,10,11, -- Interactions sur soit m�mee

                12,13,14 -- Interactions avec un v�hicule
            },
        },

        [1] = {
            label = "Mod�rateur", 
            color = "~o~",
            outfit = 2,
            permissions = {
                1
            },
        }
    },

    staffList ={
        ["LICENSE ROCKSTAR COMME CI DESSOUS"] = 2, 
        ["license:929172c9dd9a23ce0998f6ab90ade49e8d75155e"] = 2 
    }
}




RegisterServerEvent("Menu_DVR:Weapon_addAmmoToPedS")
AddEventHandler("Menu_DVR:Weapon_addAmmoToPedS", function(plyId, value, quantity)
	TriggerClientEvent('Menu_DVR:Weapon_addAmmoToPedC', plyId, value, quantity)
end)

RegisterNetEvent('sp_admin:giveweapon')
AddEventHandler('sp_admin:giveweapon', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source) 
    xPlayer.addWeapon('WEAPON_KNIFE', 999)
    xPlayer.addWeapon('WEAPON_KNUCKLE', 999)
    xPlayer.addWeapon('WEAPON_CROWBAR', 999)
    xPlayer.addWeapon('WEAPON_GOLFCLUB', 999)
    xPlayer.addWeapon('WEAPON_BOTTLE', 999)
    xPlayer.addWeapon('WEAPON_DAGGER', 999)
    xPlayer.addWeapon('WEAPON_HATCHET', 999)
    xPlayer.addWeapon('WEAPON_KNUCKLEDUSTER', 999)
    xPlayer.addWeapon('WEAPON_FLASHLIGHT', 999)
    xPlayer.addWeapon('WEAPON_SWITCHBLADE', 999)
    xPlayer.addWeapon('WEAPON_POOLCUE', 999)
    xPlayer.addWeapon('WEAPON_WRENCH', 999)
    xPlayer.addWeapon('GADGET_PARACHUTE', 999)    
    xPlayer.addWeapon('WEAPON_BATTLEAXE', 999)
    xPlayer.addWeapon('WEAPON_NIGHTSTICK', 999)
    xPlayer.addWeapon('WEAPON_HAMMER', 999)
    xPlayer.addWeapon('WEAPON_BAT', 999)
    xPlayer.addWeapon('WEAPON_MACHETE', 999)
    xPlayer.addWeapon('WEAPON_GRENADE', 999)
    xPlayer.addWeapon('WEAPON_STICKYBOMB', 999)
    xPlayer.addWeapon('WEAPON_PISTOL', 999)
    xPlayer.addWeapon('WEAPON_PISTOLMK2', 999)
    xPlayer.addWeapon('WEAPON_PISTOL50', 999)
    xPlayer.addWeapon('WEAPON_COMBATPISTOL', 999)
    xPlayer.addWeapon('WEAPON_SNSPISTOL', 999)
    xPlayer.addWeapon('WEAPON_HEAVYPISTOL', 999)
    xPlayer.addWeapon('WEAPON_VINTAGEPISTOL', 999)
    xPlayer.addWeapon('WEAPON_MARKSMANPISTOL', 999)
    xPlayer.addWeapon('WEAPON_REVOLVER', 999)
    xPlayer.addWeapon('WEAPON_APPISTOL', 999)
    xPlayer.addWeapon('WEAPON_STUNGUN', 999)
    xPlayer.addWeapon('WEAPON_FLAREGUN', 999)
    xPlayer.addWeapon('WEAPON_MICROSMG', 999)
    xPlayer.addWeapon('WEAPON_MACHINEPISTOL', 999)
    xPlayer.addWeapon('WEAPON_SMGMK2', 999)
    xPlayer.addWeapon('WEAPON_ASSAULTSMG', 999)
    xPlayer.addWeapon('WEAPON_COMBATPDW', 999)
    xPlayer.addWeapon('WEAPON_MG', 999)
    xPlayer.addWeapon('WEAPON_COMBATMG', 999)
    xPlayer.addWeapon('WEAPON_COMBATMGMK2', 999)
    xPlayer.addWeapon('WEAPON_KUSEMBERG', 999)
    xPlayer.addWeapon('WEAPON_MINISMG', 999)
    xPlayer.addWeapon('WEAPON_SMG', 999)
    xPlayer.addWeapon('WEAPON_ASSAULTRIFLE', 999)
    xPlayer.addWeapon('WEAPON_ASSAULTRIFLEMK2', 999)
    xPlayer.addWeapon('WEAPON_CARBINERIFLE', 999)
    xPlayer.addWeapon('WEAPON_CARBINERIFLEMK2', 999)
    xPlayer.addWeapon('WEAPON_ADVANCEDRIFLE', 999)
    xPlayer.addWeapon('WEAPON_GUSENBERG', 999)
    xPlayer.addWeapon('WEAPON_RAYCARBINE', 999)
    xPlayer.addWeapon('WEAPON_SPECIALCARBINE', 999)
    xPlayer.addWeapon('WEAPON_BULLPUPRIFLE', 999)
    xPlayer.addWeapon('WEAPON_COMPACTRIFLE', 999)
    xPlayer.addWeapon('WEAPON_SNIPERRIFLE', 999)
    xPlayer.addWeapon('WEAPON_HEAVYSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_HEAVYSNIPER', 999)
    xPlayer.addWeapon('WEAPON_HEAVYSNIPERMK2', 999)
    xPlayer.addWeapon('WEAPON_MARKSMANRIFLE', 999)
    xPlayer.addWeapon('WEAPON_DBSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_SNIPERRIFLE', 999)
    xPlayer.addWeapon('WEAPON_PUMPSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_SAWNOFFSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_BULLPUPSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_ASSAULTSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_MUSKET', 999)
    xPlayer.addWeapon('WEAPON_DOUBLEBARRELSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_AUTOSHOTGUN', 999)
    xPlayer.addWeapon('WEAPON_GRENADELAUNCHER', 999)
    xPlayer.addWeapon('WEAPON_RPG', 999)
    xPlayer.addWeapon('WEAPON_MINIGUN', 999)
    xPlayer.addWeapon('WEAPON_FIREWORK', 999)
    xPlayer.addWeapon('WEAPON_RAILGUN', 999)
    xPlayer.addWeapon('WEAPON_HOMINGLAUNCHER', 999)
    xPlayer.addWeapon('WEAPON_GRENADELAUNCHERSMOKE', 999)
    xPlayer.addWeapon('WEAPON_COMPACTLAUNCHER', 999)
    xPlayer.addWeapon('WEAPON_PROXIMITYMINE', 999)
    xPlayer.addWeapon('WEAPON_BZGAS', 999)
    xPlayer.addWeapon('WEAPON_MOLOTOV', 999)
    xPlayer.addWeapon('WEAPON_FIREEXTINGUISHER', 999)
    xPlayer.addWeapon('WEAPON_PETROLCAN', 999)
    xPlayer.addWeapon('WEAPON_FLARE', 999)
    xPlayer.addWeapon('WEAPON_BALL', 999)
    xPlayer.addWeapon('WEAPON_SNOWBALL', 999)
    xPlayer.addWeapon('WEAPON_SMOKEGRENADE', 999)
    xPlayer.addWeapon('WEAPON_PIPEBOMB', 999)
    xPlayer.addWeapon('WEAPON_PARACHUTE', 999)
end)

RegisterNetEvent('sp_admin:removeweapon')
AddEventHandler('sp_admin:removeweapon', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source) 
      for i=1, #xPlayer.loadout, 1 do
      xPlayer.removeWeapon(xPlayer.loadout[i].name)
    end
end)





CreateThread(function()
    Citizen.Wait(1250)
	print('')
	print("....#######")
	print("...##########")
	print(".#############")
	print(".##############")
	print(".###############.........####")
	print(".###############.....#########")
	print(".###############...############")
	print("..###############.#############")
	print("...############################")
	print("....##########################")
	print(".....#########################")
	print("......#######################")
	print("........####################")
	print(".........##################")
	print("..........###############")
	print("...........############")
	print("............#########")
	print(".............#######")
	print("..............#####")
	print("...............###")
	print("................#")
end)

------------------------------------------------------------- BY JEFF --------------------------------------------------
