 ESX = nil
 local allReportClient = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	
	RMenu.Add('menu', 'main', RageUI.CreateMenu("Menu Staff", ""))
	RMenu.Add('menu', 'options', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Actions Joueurs", "Actions disponibles"))
	RMenu.Add('menu', 'watodo', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Moi ou Eux ?", "Actions disponibles"))
	RMenu.Add('menu', 'joueurs', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Joueurs", "Actions disponibles"))	
	RMenu.Add('menu', 'modo', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Gestion modos", "Actions disponibles"))
	RMenu.Add('menu', 'inde', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Independant", "Actions disponibles"))
	RMenu.Add('menu', 'me', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Personnel", "Actions disponibles"))
	RMenu.Add('menu', 'world', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Options", "Options disponibles"))
	RMenu.Add('menu', 'commande', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Commandes", "Liste des raccourcis de commande"))
	RMenu.Add('menu', 'sanction', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Sanctions", "Santions disponibles"))
	RMenu.Add('menu', 'action', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Actions", "Actions disponibles"))
	RMenu.Add('menu', 'inventaire', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Inventaire", "Inventaire by Enøs#0001"))
	RMenu.Add('menu', 'tele', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Téléportation", "Téléportations disponibles"))
	RMenu.Add('menu', 'soin', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Soins", "Soins disponibles"))
	RMenu.Add('menu', 'whipe', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Whipe", "Whipe disponibles"))
	RMenu.Add('menu', 'give', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Give", "Give disponibles"))
	RMenu.Add('menu', 'setjob', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Métier", "jeff"))
	RMenu.Add('menu', 'setjob2', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Gang", "jeff"))
	RMenu.Add('menu', 'report', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Liste des Reports", "Prendre en charge un report"))
	RMenu.Add('menu', 'report2', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Reports", "Panel d'options pour les Reports"))
	RMenu.Add('menu', 'item', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Item", "Items by Enøs#0001"))
    RMenu:Get('menu', 'main'):SetSubtitle("Actions disponibles")
    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()

        VM.Staff = false
    end
end)

VM = {
    Staff = false,
}

superadmin = nil
local invincible = false
local crossthemap = false
local affichername = false
local afficherblips = false
local Items = {}
local explossiveAmmo = false
local infiniteAmmo = false
local teleportGun = false
local vehicleGun = false
local whaleGun = false
local annonceState = false

local function getPlayerInv(id)
	Items = {}
	
	ESX.TriggerServerCallback('xAdmin:getOtherPlayerData', function(data)
		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(Items, {
					label    = data.inventory[i].label,
					right    = data.inventory[i].count,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end
	end, id)
end

local filterArray = { "Aucun", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1


local menuColor = {135, 135, 135}
Citizen.CreateThread(function()
    Wait(1000)
    menuColor[1] = GetResourceKvpInt("menuR")
    menuColor[2] = GetResourceKvpInt("menuG")
    menuColor[3] = GetResourceKvpInt("menuB")
    ReloadColor()
end)

local AllMenuToChange = nil
function ReloadColor()
    Citizen.CreateThread(function()
        if AllMenuToChange == nil then
            AllMenuToChange = {}
            for Name, Menu in pairs(RMenu['menu']) do
                if Menu.Menu.Sprite.Dictionary == "commonmenu" then
                    table.insert(AllMenuToChange, Name)
                end
            end
        end
        for k,v in pairs(AllMenuToChange) do
            RMenu:Get('menu', v):SetRectangleBanner(Config.R, Config.G, Config.B)
        end
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end

function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if drawInfo then
			local text = {}
			-- cheat checks
			local targetPed = GetPlayerPed(drawTarget)
			
			table.insert(text,"[E] Stop")
			
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
			
			if IsControlJustPressed(0,103) then
				local targetPed = PlayerPedId()
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
	
				StopDrawPlayerInfo()
				
			end
			
		end
	end
end)
function SpectatePlayer(targetPed,target,name)
    local playerPed = PlayerPedId() -- yourself
	enable = true
	if targetPed == playerPed then enable = false end

    if(enable)then

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(target)
        ESX.ShowNotification('Mode spectateur ~g~en cours')
    else

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
		StopDrawPlayerInfo()
        ESX.ShowNotification('Mode spectateur ~r~arrêté')
    end
end


local playerscacheC = {}
RegisterNetEvent('xAdmin:listplayer')
AddEventHandler('xAdmin:listplayer', function(playerscache) if InStaff then playerscacheC = playerscache end end)

--


function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end

if Config.Report then
	TriggerEvent('chat:addSuggestion', '/report', 'Faire un appel staff', {
    	{ name="Raison", help="Merci de détailler votre demande" },
	})
end

function GetTargetedVehicle(pCoords, ply)
    for i = 1, 200 do
        coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, (6.281)/i, 0.0)
        targetedVehicle = GetVehicleInDirection(pCoords, coordB)
        if(targetedVehicle ~= nil and targetedVehicle ~= 0)then
            return targetedVehicle
        end
    end
    return
end

Citizen.CreateThread(function()

    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())

end)

function GetVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

local function JeffKeyboard(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end


function ShowMarker()
	local ply = GetPlayerPed(-1)
	local pCoords = GetEntityCoords(ply, true)
    local veh = GetTargetedVehicle(pCoords, ply)
    if veh ~= 0 and GetEntityType(veh) == 2 then
        local coords = GetEntityCoords(veh)
        local x,y,z = table.unpack(coords)
        DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
    end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

Citizen.CreateThread(function() -- INFINITE Ammo
    while true do
      Citizen.Wait(0)
  
      if infiniteAmmo then
        SetPedInfiniteAmmo(GetPlayerPed(-1), true)
              SetPedInfiniteAmmoClip(GetPlayerPed(-1), true)
              SetPedAmmo(GetPlayerPed(-1), (GetSelectedPedWeapon(GetPlayerPed(-1))), 99999)
      else
        SetPedInfiniteAmmo(GetPlayerPed(-1), false)
              SetPedInfiniteAmmoClip(GetPlayerPed(-1), false)
      end
    end
  end) 


local Freeze = false
RegisterNetEvent("admin:Freeze")
AddEventHandler("admin:Freeze",function()

    FreezeEntityPosition(GetPlayerPed(-1), not Freeze)
    Freeze = not Freeze
end)

RegisterNetEvent("admin:tp")
AddEventHandler("admin:tp",function(coords)
    SetEntityCoords(GetPlayerPed(-1),coords)
end)

RegisterNetEvent('Jannonce:annonceServerClient')
AddEventHandler('Jannonce:annonceServerClient', function(text, bool)
    texteAnnonce = text
	annonceState = bool
    if bool then
        PlaySoundFrontend(-1, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset", 1)
    end
end)

function DrawAdvancedTextCNN(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end



Citizen.CreateThread(function()

    while true do
      Citizen.Wait(1)

     
      if infStamina then
        RestorePlayerStamina(source, 1.0)
      end

      if superJump then
        SetSuperJumpThisFrame(PlayerId())
	  end
    end
  
  end)

local Spectating = false


function SpectatePlayer(player)
	Spectating = not Spectating
	local targetPed = GetPlayerPed(player)

	if(Spectating)then

		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(true, targetPed)

		--drawNotification('Spectating '..GetPlayerName(player))
		ESX.ShowNotification('Mode spectateur de \n['..Config.Colors..''..reportSelected.namePlayer..'~s~] ~g~en cours')
	else

		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(false, targetPed)

		--drawNotification('Stopped Spectating '..GetPlayerName(player))
		ESX.ShowNotification('Mode spectateur de \n['..Config.Colors..''..reportSelected.namePlayer..'~s~] ~r~arrêté')
	end
end


local ServersIdSession = {}

Citizen.CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end


function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function GetCloseVehi()
    local player = GetPlayerPed(-1)
    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
    local vCoords = GetEntityCoords(vehicle)
    DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end


local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

RegisterNetEvent("CA")
AddEventHandler("CA", function()
  local pos = GetEntityCoords(GetPlayerPed(-1), true)
  ClearAreaOfObjects(pos.x, pos.y, pos.z, 50.0, 0)
end)

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end

function soufle()
    infStamina = not infStamina
      if infStamina then
        Notify("Endurance infini ~g~activé")
      else
        Notify("Endurance infini ~r~desactivé")
      end
   end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()--ADEMO YZK JIBRIL
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

RegisterCommand("help", function(source, args, sonid)
    for _, i in ipairs(GetActivePlayers()) do
		local sonid = GetPlayerServerId(i)
		local nom = GetPlayerName(i)
		table.insert(Reports, {Id = sonid, name = nom, message = table.concat(args, " ")})
    end
end)

function superman()
	superJump = not superJump	  
end


local superJump = false
local fastSprint = false
local infStamina = false
local Frigo = false
local Frigo2 = false
local godmode = true
local fastSwim = false
local blipsStatus = 0
local ademo26 = false
local StaffMod = false
local NoClip = false
local NoClipSpeed = 2.0
local invisible = false
local PlayerInZone = 0
local ShowName = false
local gamerTags = {}
local GetBlips = false
local pBlips = {}
local armor = 0
local InStaff = false
local pris = false
local staff = false
local tenue = false
local modeDelgun = false
local delgun = false


local PlayerData = {}
local Items = {}
local allItemsServer = {}
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local index = 1 

local function getPlayerInv(player)
    
	Items = {}
	Armes = {}
	ArgentSale = {}
	ArgentCash = {}
	ArgentBank = {}
	
	ESX.TriggerServerCallback('adminmenu:getOtherPlayerData', function(data)
	
	
		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'bank' and data.accounts[i].money > 0 then
				table.insert(ArgentBank, {
					label    = ESX.Math.Round(data.accounts[i].money),
					value    = 'bank',
					itemType = 'item_bank',
					amount   = data.accounts[i].money
				})
	
				break
			end
		end
	
	
		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'money' and data.accounts[i].money > 0 then
				table.insert(ArgentCash, {
					label    = ESX.Math.Round(data.accounts[i].money),
					value    = 'money',
					itemType = 'item_cash',
					amount   = data.accounts[i].money
				})
	
				break
			end
		end
	
		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(ArgentSale, {
					label    = ESX.Math.Round(data.accounts[i].money),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})
	
				break
			end
		end
	
		for i=1, #data.weapons, 1 do
			table.insert(Armes, {
				label    = ESX.GetWeaponLabel(data.weapons[i].name),
				value    = data.weapons[i].name,
				right    = data.weapons[i].ammo,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end
	
		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(Items, {
					label    = data.inventory[i].label,
					right    = data.inventory[i].count,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end
	end, GetPlayerServerId(player))
	end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if StaffMod then

            if NoClip then
                HideHudComponentThisFrame(19)
                local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local camCoords = getCamDirection()
                SetEntityVelocity(GetPlayerPed(-1), 0.01, 0.01, 0.01)
                SetEntityCollision(GetPlayerPed(-1), 0, 1)
            
                if IsControlPressed(0, 32) then
                    pCoords = pCoords + (NoClipSpeed * camCoords)
                end
            
                if IsControlPressed(0, 269) then
                    pCoords = pCoords - (NoClipSpeed * camCoords)
                end

                if IsControlPressed(1, 15) then
                    NoClipSpeed = NoClipSpeed + 0.5
                end
                if IsControlPressed(1, 16) then
                    NoClipSpeed = NoClipSpeed - 0.5
                    if NoClipSpeed < 0 then
                        NoClipSpeed = 0
                    end
                end
                SetEntityCoordsNoOffset(GetPlayerPed(-1), pCoords, true, true, true)
            end

            if invisible then
                SetEntityVisible(GetPlayerPed(-1), 0, 0)
                NetworkSetEntityInvisibleToNetwork(pPed, 1)
            else
                SetEntityVisible(GetPlayerPed(-1), 1, 0)
                NetworkSetEntityInvisibleToNetwork(pPed, 0)
			end

			if ShowName then
				local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
				for _, v in pairs(GetActivePlayers()) do
					local otherPed = GetPlayerPed(v)
					local job = ESX.PlayerData.job.name
					local job2 = ESX.PlayerData.job2.name
	
					if otherPed ~= pPed then
						if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
							gamerTags[v] = CreateFakeMpGamerTag(otherPed, (" ["..GetPlayerServerId(v).."] "..GetPlayerName(v).." \nVie : "..GetEntityHealth(otherPed).." Bouclier : "..GetPedArmour(otherPed).."  \nJobs : "..job.." | "..job2), false, false, '', 0)
							SetMpGamerTagVisibility(gamerTags[v], 4, 1)
						else
							RemoveMpGamerTag(gamerTags[v])
							gamerTags[v] = nil
						end
					end
				end
			else
				for _, v in pairs(GetActivePlayers()) do
					RemoveMpGamerTag(gamerTags[v])
				end
			end

            for k,v in pairs(GetActivePlayers()) do
                if NetworkIsPlayerTalking(v) then
                    local pPed = GetPlayerPed(v)
                    local pCoords = GetEntityCoords(pPed)
                    DrawMarker(2, pCoords.x, pCoords.y, pCoords.z+1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
			end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if GetBlips then
            local players = GetActivePlayers()
            for k,v in pairs(players) do
                local ped = GetPlayerPed(v)
                local blip = AddBlipForEntity(ped)
                table.insert(pBlips, blip)
                SetBlipScale(blip, 0.85)
                if IsPedOnAnyBike(ped) then
                    SetBlipSprite(blip, 226)
                elseif IsPedInAnyHeli(ped) then
                    SetBlipSprite(blip, 422)
                elseif IsPedInAnyPlane(ped) then
                    SetBlipSprite(blip, 307)
                elseif IsPedInAnyVehicle(ped, false) then
                    SetBlipSprite(blip, 523)
                else
                    SetBlipSprite(blip, 1)
                end

                if IsPedInAnyPoliceVehicle(ped) then
                    SetBlipSprite(blip, 56)
                    SetBlipColour(blip, 3)
                end
                SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
			end
		else
			for k,v in pairs(pBlips) do
                RemoveBlip(v)
            end
        end
        if tenue then
            ExecuteCommand("staff ")
        end
    end
end)

local ServersIdSession = {}

Citizen.CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)

Admin = {
	showcrosshair = false,
	showName = false,
    gamerTags = {}
}
MainColor = {
	r = 225, 
	g = 55, 
	b = 55,
	a = 255
}

Citizen.CreateThread(function()
	while true do
		if Admin.showName then
			for k, v in ipairs(ESX.Game.GetPlayers()) do
				local otherPed = GetPlayerPed(v)

				if otherPed ~= plyPed then
					if #(GetEntityCoords(plyPed, false) - GetEntityCoords(otherPed, false)) < 5000.0 then
						Admin.gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
					else
						RemoveMpGamerTag(Admin.gamerTags[v])
						Admin.gamerTags[v] = nil
					end
				end
			end
		end

		Citizen.Wait(100)
	end
end)

function DrawTxt(text,r,z)
    SetTextColour(MainColor.r, MainColor.g, MainColor.b, 255)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0,0.4)
    SetTextDropshadow(1,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(r,z)
 end


function KeyBoardText(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
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
	

local money = {
	index = 1,
	list = {'~g~Liquide~s~', '~b~Banque~s~', '~r~Non déclaré~s~'},
}

local tp = {
	index = 2,
	list = {''..Config.TpName1..'', ''..Config.TpName2..'', ''..Config.TpName3..'', ''..Config.TpName4..'', ''..Config.TpName5..'', ''..Config.TpName6..'', ''..Config.TpName7..''},
}

local prison = {
	index = 3,
	list = {'1 Minute', '2 minutes', '3 minutes', '4 minutes', '5 minutes', '10 minutes', '15 minutes', '30 minutes', '1 heure'},
}

local kick = {
	index = 4,
	list = {'HRP Vocal', 'Conduite HRP', 'Insultes Staff', 'Soundpad', 'Troll', 'Use Beug'},
}

local voiture = {
	index = 5,
	list = {''..Config.Cars1..'', ''..Config.Cars2..'', ''..Config.Cars3..''},
}

local setjob = {
	index = 6,
	list = {''..Config.SetjobN1..'', ''..Config.SetjobN2..'', ''..Config.SetjobN3..'', ''..Config.SetjobN4..'', ''..Config.SetjobN5..'', ''..Config.SetjobN6..'', ''..Config.SetjobN7..'', ''..Config.SetjobN8..'', ''..Config.SetjobN9..''},
}

local setjob2 = {
	index = 7,
	list = {'Ballas', 'Families', 'Vagos'},
}

local tpa = {
	index = 8,
	list = {''..Config.TpaName1..'', ''..Config.TpaName2..'', ''..Config.TpaName3..'', ''..Config.TpaName4..'', ''..Config.TpaName5..'', ''..Config.TpaName6..''},
}

local tpreport = {
	index = 9,
	list = {'Se TP à lui', 'Le TP sur moi'},
}

local armesdepoinggive = {
	index = 10,
	list = {'Couteau', 'Poing Américain', 'Pied de Biche', 'Club de Golf', 'Bouteille', 'Poignard', 'Hachette', 'test', 'lampe Torche', 'Couteau à crant d\'arrêt', 'Queue de Billard', 'Clé', 'Parachute', 'Hache de combat', 'Matraque', 'Marteau', 'Batte', 'Machette'},
}

local explosif = {
	index = 11,
	list = {'Grenade', 'Bombe Collante', 'Mine de Proximité', 'Bombe de Gaz', 'Cocktail Molotov', 'Extincteur', 'Jerican D\'essence', 'Fumées Rouge', 'Balle', 'Boule de neige', 'Fumigène', 'Parachute'},
}

local pistolet ={
	index = 12,
	list = {'Pistolet', 'Pistolet MKII', 'Pistolet Cal. 50', 'Pistolet de Combat', 'Pistolet SNS', 'Pistolet Lourd', 'Pistolet Vintage', 'Pistolet à double coup', 'Revolver', 'Pistolet Automatique', 'Tazer', 'Pistolet de détresse', '', }
}

local smg = {
	index = 11,
	list = {'Micro SMG', 'Mitraillette', 'SMG MKII', 'SMG D\'assault', 'SMG de combat', 'MG', 'MG de combat', 'MG de combat MKII', 'Kusemberg', 'Mini SMG', 'SMG'},
}

local fusil = {
	index = 12,
	list = {'Fusil D\'assault', 'Fusil D\'assault MKII', 'Carabine', 'Carabine MKII', 'Fusil Avancé', 'Gusenberg', 'Carabine Laser', 'Carabine Spéciale', 'Fusil Bullpup', 'Fusil D\'assault Compact'},
}

local sniper = {
	index = 13,
	list = {'Semi-Automatique', 'Sniper Lourd', 'Sniper Lourd MKII', 'Sniper MarksMan'},
}

local pompe = {
	index = 14,
	list = {'Fusil de chasse', 'Fusil à Pompe', 'Fusil à Pompe Compact', 'Pompe Bullpup', 'Fusil à pompe D\'assault', 'Mousquet', 'Double Barel', 'Pompe Automatique'},
}

local RPG = {
	index = 11,
	list = {'Lance-Grenade', 'RPG', 'Minigun', 'Lance-Artifices', 'RailGun', 'Lance-Missile', 'test', 'Lance-Grenade Compact'},
}


local IdSelected = 0
local ReportSelected = 0

Reports = {}
function openStaffMenu()
    if VM.Staff then
        VM.Staff = false
    else
        VM.Staff = true
        RageUI.Visible(RMenu:Get('menu', 'main'), true)

        Citizen.CreateThread(function()
			while VM.Staff do
				RageUI.IsVisible(RMenu:Get('menu', 'main'), true, true, true, function()
					RageUI.Checkbox("Activer le Mode Staff 5-Dev", "Active la case si tou souhaites passer en mode Modération :)", InStaff, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
						InStaff = Checked;
						if Selected then 
							if Checked then
								InStaff = true
								StaffMod = true
							else
								InStaff = false
								StaffMod = false
				
								FreezeEntityPosition(GetPlayerPed(-1), false)
								NoClip = false
				
								SetEntityVisible(GetPlayerPed(-1), 1, 0)
								NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), 0)
								SetEntityCollision(GetPlayerPed(-1), 1, 1)
				
								for _, v in pairs(GetActivePlayers()) do
									RemoveMpGamerTag(gamerTags[v])
								end
							end
						end
					end)
					if InStaff then

							RageUI.Separator("")

							local name = GetPlayerName(PlayerId())
							local id = GetPlayerServerId(PlayerId())

							if mod then
								RageUI.Separator("Modérateur : ~g~" .. name )
							end
							
							if admin then
								RageUI.Separator("Administrateur : ~o~" .. name )
							end

							if _dev then
								RageUI.Separator("Développeur : ~p~" .. name )
							end

							if superadmin then
								RageUI.Separator("Super Admin : ~r~ " .. name )
							end

							if owner then
								RageUI.Separator("Owner : ~y~ " .. name )
							end

							players = {}
							for _, player in ipairs(GetActivePlayers()) do
    							local ped = GetPlayerPed(player)
    							table.insert( players, player )
							end

							
							RageUI.Separator("Joueur(s) en ligne  →  "..Config.Colors..""..#players.."~s~/512")
							RageUI.Separator("")

							RageUI.Separator(" "..Config.Colors.."↓ ~s~Options complémentaires "..Config.Colors.."↓")
							if owner or superadmin or _dev or admin then
								RageUI.ButtonWithStyle("Joueurs", "Afficher la liste des joueurs et les options disponible", { RightLabel = "→→→" },true, function()
								end, RMenu:Get('menu', 'joueurs'))
							else 
								RageUI.ButtonWithStyle('Joueurs', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
								end)
							end	
							
						if owner or superadmin or _dev or admin or mod then
					        RageUI.ButtonWithStyle("Indispensable", "Options indispensables pour administrer", { RightLabel = "→→→" },true, function()
							end, RMenu:Get('menu', 'me'))
						end	

						if owner or superadmin or _dev or admin then	
						    RageUI.ButtonWithStyle("Options", "Options de mon personnage / voitures", { RightLabel = "→→→" },true, function()
							end, RMenu:Get('menu', 'world'))
						else 
							RageUI.ButtonWithStyle('Options', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
							end)
						end	

						if Config.Report then
							RageUI.ButtonWithStyle("Gestion Report", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
								if Selected then
									ESX.TriggerServerCallback('rxwMenuAdmin:getAllReport', function(result)
										allReportClient = result
									end)
								end
							end, RMenu:Get('menu', 'report'))
						end
							
						RageUI.ButtonWithStyle("Commandes", "Liste des raccourcis de commande", { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'commande'))

					end	
				end, function()
				end, 1)
				RageUI.IsVisible(RMenu:Get('menu', 'me'), true, true, true, function()
					RageUI.Checkbox("Noclip", "Molette vers le bas = Vitesse ~g~Lente\n~s~Molette vers le haut = Vitesse ~r~Rapide", crossthemap,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							crossthemap = Checked
							if Checked then
								FreezeEntityPosition(GetPlayerPed(-1), true)
								NoClip = true
								invisible = true
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Noclip activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noclip', 'Noclip ~g~Activé', 'CHAR_JEFF', 8)
								end
							else
								FreezeEntityPosition(GetPlayerPed(-1), false)
								SetEntityCollision(GetPlayerPed(-1), 1, 1)
								NoClip = false
								invisible = false
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Noclip désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noclip', 'Noclip ~r~désactivé', 'CHAR_JEFF', 8)
								end
							end
						end
					end)

					--[[RageUI.Checkbox("Afficher les Noms", description, affichername,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							affichername = Checked
							if Checked then
								ShowName = true
								--ESX.ShowAdvancedNotification('Staff Citylife', '~b~Affichage des noms', 'Les noms ont été ~g~activé', 'CHAR_JEFF', 8)
								exports['okokNotify']:Alert("Administration", "Les noms ont été activé", 5000, 'success')
							else
								ShowName = false
								--ESX.ShowAdvancedNotification('Staff Citylife', '~b~Affichage des noms', 'Les noms ont été ~r~désactivé', 'CHAR_JEFF', 8)
								exports['okokNotify']:Alert("Administration", "Les noms ont été désactivé", 5000, 'error')
							end
						end
					end)]]-----  Affichage de noms qui fonctionne très bien avec vie/bouclier + jobs/jobs2

					RageUI.Checkbox("Afficher les Noms", description, Name,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							Name = Checked
							if Checked then
								ExecuteCommand(""..Config.Command.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Les noms ont été activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noms', 'Les noms ont été ~g~activé', 'CHAR_JEFF', 8)
								end
							else
								ExecuteCommand(""..Config.Command.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Les noms ont été désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noms', 'Les noms ont été ~r~désactivé', 'CHAR_JEFF', 8)
								end
						end
					end
					end)
					RageUI.Checkbox("Afficher les Blips", description, afficherblips,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							afficherblips = Checked
							if Checked then
								GetBlips = true
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Les blips ont été activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Affichage des Blips', 'Les blips ont été ~g~activé', 'CHAR_JEFF', 8)
								end
							else
								GetBlips = false
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Les blips ont été désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Affichage des Blips', 'Les Blips ont été ~r~désactivé', 'CHAR_JEFF', 8)
								end								
							end
						end
					end)
					RageUI.Checkbox("Tenue de modération", description, staff,{},function(Hovered,Ative,Selected,Checked)
						if (Selected) then
							if Checked then
								ExecuteCommand(""..Config.Tenue.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Tenue de modération activée", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Tenue', 'Tenue de modération ~g~activée', 'CHAR_JEFF', 8)
								end
							else
								ExecuteCommand(""..Config.Tenue.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Tenue de modération désactivée", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Tenue', 'Tenue de modération ~r~désactivée', 'CHAR_JEFF', 8)
								end
							end
						end
					end)
					RageUI.Checkbox("Delgun",nil, modeDelgun,{},function(Hovered,Ative,Selected,Checked)

						if Selected then
							modeDelgun = Checked
							if Checked then
								delgun = true
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Delgun Activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Delgun', 'Delgun ~g~Activé', 'CHAR_JEFF', 8)
								end
							else
								delgun = false
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Delgun Désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Delgun', 'Delgun ~r~Désactivé', 'CHAR_JEFF', 8)
								end
							end
						end
					end)
					RageUI.ButtonWithStyle("Heal",description, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetEntityHealth(GetPlayerPed(-1), 200)
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Vous venez de vous heal", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Staff Citylife', '~b~Heal', 'Vous venez de vous ~g~HEAL', 'CHAR_JEFF', 8)
							end
						end
					end)
					RageUI.ButtonWithStyle("Téléporter sur son marqueur", nil, {RightLabel = "→"}
					, true, function(_, _, Selected)
					if Selected then
						local playerPed = GetPlayerPed(-1)
						local WaypointHandle = GetFirstBlipInfoId(8)
						if DoesBlipExist(WaypointHandle) then
							local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
							SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.9, false, false, false, true)
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "TP sur marker effectué", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Staff Citylife', '~b~TP sur marker', 'TP sur marker ~g~effectué', 'CHAR_JEFF', 8)
							end
		
						end
					end
					end)
					
					local CarPrev

					RageUI.List('Voiture', voiture.list, voiture.index, "Fait-toi spwan une voiture", {}, true, function(Hovered, Active, Selected, Index)
						if (Selected) then
							if Index == 1 then
								if DoesEntityExist(CarPrev) then
									DeleteEntity(CarPrev)
								end
								while not HasModelLoaded(GetHashKey(""..Config.Cars1.."")) do
									RequestModel(GetHashKey(""..Config.Cars1..""))
									Wait(100)
								end
								local FinalCar = CreateVehicle(GetHashKey(""..Config.Cars1..""), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true)
								TaskWarpPedIntoVehicle(GetPlayerPed(-1), FinalCar, -1)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Ton "..Config.Cars1.." viens de spawn", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'Ton ~g~ '..Config.Cars1..' ~w~viens de spawn', 'CHAR_JEFF', 8)
								end
							elseif Index == 2 then
								if DoesEntityExist(CarPrev) then
									DeleteEntity(CarPrev)
								end
								while not HasModelLoaded(GetHashKey(""..Config.Cars2.."")) do
									RequestModel(GetHashKey(""..Config.Cars2..""))
									Wait(100)
								end
								local FinalCar = CreateVehicle(GetHashKey(""..Config.Cars2..""), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true)
								TaskWarpPedIntoVehicle(GetPlayerPed(-1), FinalCar, -1)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Ta "..Config.Cars2.." viens de spawn", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'Ta ~g~'..Config.Cars2..' ~w~viens de spawn', 'CHAR_JEFF', 8)
								end
							elseif Index == 3 then
								if DoesEntityExist(CarPrev) then
									DeleteEntity(CarPrev)
								end
								while not HasModelLoaded(GetHashKey(""..Config.Cars3.."")) do
									RequestModel(GetHashKey(""..Config.Cars3..""))
									Wait(100)
								end
								local FinalCar = CreateVehicle(GetHashKey(""..Config.Cars3..""), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true)
								TaskWarpPedIntoVehicle(GetPlayerPed(-1), FinalCar, -1)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Ta "..Config.Cars3.." viens de spawn", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'Ta ~g~'..Config.Cars3..' ~w~viens de spawn', 'CHAR_JEFF', 8)
								end
							end  
						end
						voiture.index = Index
					end)
					if owner or admin or superadmin or _dev then
						RageUI.List('Téléportations', tp.list, tp.index, "Un porto-loin nécessite une formule magique !", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("tp "..Config.Tp1.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "TP au "..Config.TpName1.." réussi", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au '..Config.TpName1..' ~g~réussi', 'CHAR_JEFF', 8)
									end
																		
								elseif Index == 2 then
									ExecuteCommand("tp "..Config.Tp2.."")
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "TP a la "..Config.TpName2.." réussi", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP a la '..Config.TpName2..' ~g~réussi', 'CHAR_JEFF', 8)
										end
								elseif Index == 3 then
									ExecuteCommand("tp "..Config.Tp3.."")
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "TP au "..Config.TpName3.." réussi", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au '..Config.TpName3..' ~g~réussi', 'CHAR_JEFF', 8)
										end	
								elseif Index == 4 then
									ExecuteCommand("tp "..Config.Tp4.."")
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "TP au "..Config.TpName4.." réussi", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au '..Config.TpName4..' ~g~réussi', 'CHAR_JEFF', 8)
										end
								elseif Index == 5 then
									ExecuteCommand("tp "..Config.Tp5.."")
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "TP "..Config.TpName5.." réussi", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP '..Config.TpName5..' ~g~réussi', 'CHAR_JEFF', 8)
										end
								elseif Index == 6 then
									ExecuteCommand("tp "..Config.Tp6.."")
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "TP "..Config.TpName6.." réussi", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP '..Config.TpName6..' ~g~réussi', 'CHAR_JEFF', 8)
										end
										
								elseif Index == 7 then 
									ExecuteCommand("tp "..Config.Tp7.."")
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "TP "..Config.TpName7.." réussi", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP '..Config.TpName7..' ~g~réussi', 'CHAR_JEFF', 8)
										end
								end  
							end
							tp.index = Index
						end)
					end
					if owner or superadmin or _dev then
						RageUI.List('Remboursement', money.list, money.index, "Give toi pour après faire la transaction à une personne !", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									GiveCash()
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "Give argent cash effectué", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Argent Cash', 'give d\'argent ~g~effectué', 'CHAR_JEFF', 8)
										end
								elseif Index == 2 then
									GiveBanque()
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "Give argent banque effectué", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Argent Banque', 'give d\'argent ~g~effectué', 'CHAR_JEFF', 8)
										end
								elseif Index == 3 then
										Config.notif = Config.TF
										if Config.notif then
											exports['okokNotify']:Alert("Administration", "Give argent sale effectué", 5000, 'success')
										else
											ESX.ShowAdvancedNotification('Staff Citylife', '~b~Argent ~r~Sale', 'give d\'argent ~g~effectué', 'CHAR_JEFF', 8)
										end
									GiveND()
								end
							end
							money.index = Index
						end)
					else 
						RageUI.ButtonWithStyle('Remboursement', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
						end)
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'joueurs'), true, true, true, function()
					for k,v in ipairs(ServersIdSession) do
						if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then table.remove(ServersIdSession, k) end
						RageUI.ButtonWithStyle(v.." - " ..GetPlayerName(GetPlayerFromServerId(v)), nil, {}, true, function(Hovered, Active, Selected)
							if (Selected) then
								IdSelected = v
								ESX.TriggerServerCallback('rxwMenuAdmin:getPlayerInfos', function(result)
									playerResult = result
								end, IdSelected)
							end
						end, RMenu:Get('menu', 'options'))
					end
				end, function ()
				end, RMenu:Get('menu', 'options'))

				RageUI.IsVisible(RMenu:Get('menu', 'action'), true, true, true, function()
					RageUI.ButtonWithStyle("Ouvrir l'inventaire", "inventaire du joueur", { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
						if Selected then
							getPlayerInv(GetPlayerFromServerId(IdSelected))
						end
					end, RMenu:Get('menu', 'inventaire'))
					RageUI.ButtonWithStyle("Envoyer un message", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
						if Selected then
							local msg = JeffKeyboard("Message ?", "", 20)
							if msg then
								TriggerServerEvent("Jmessage:sendMsg", IdSelected, msg)
							else
								Config.notif = Config.TF
								if Config.notif then
									elseexports['okokNotify']:Alert("Administration", "Votre message ne peut être vide !", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Informations', 'Votre message ne peut pas être vide !', 'CHAR_JEFF', 8)
								end
							end
						end
					end)

					if owner or superadmin or _dev then	
						RageUI.ButtonWithStyle("Métier", "choisis un métier", { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'setjob'))
					else
						RageUI.ButtonWithStyle('Métier', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
						end)
					end

					if owner or superadmin or _dev then	
						RageUI.ButtonWithStyle("Gang", "choisis un Gang", { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'setjob2'))
					else
						RageUI.ButtonWithStyle('Gang', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
						end)
					end

					end, function()
					end, RMenu:Get("menu", "joueurs"))
					
					RageUI.IsVisible(RMenu:Get('menu', 'sanction'), true, true, true, function()
						RageUI.ButtonWithStyle("Bannir", "bannir un joueur", {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local day = KeyboardInput("Jours", "", 100)
								local raison = KeyboardInput("Raison du kick", "", 100)
								if day and raison then
									ExecuteCommand("sqlban "..IdSelected.. " " ..day.. " " ..raison)
									Config.notif = Config.TF
									if Config.notif then
										elseexports['okokNotify']:Alert("Administration", "Tu viens de ~Bannir~ le joueur : ("..GetPlayerName(GetPlayerFromServerId(IdSelected))..")", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Ban', 'Tu viens de ~Bannir~ le joueur : ('..GetPlayerName(GetPlayerFromServerId(IdSelected))..')', 'CHAR_JEFF', 8)
									end
	
								else
									ESX.ShowNotification("~r~ERROR 404\nChamp Invalide")
									RageUI.CloseAll()	
								end      
							end
						end, RMenu:Get('menu', 'joueurs'))

						RageUI.List('Mettre en Prison', prison.list, money.index, "mettre un joueur en prison", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime1.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime1.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime1..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 2 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime2.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime2.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime2..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime3.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime3.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime3..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime4.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime4.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime4..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 5 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime5.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime5.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime5..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 6 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime6.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime6.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime6..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 7 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime7.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime7.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime7..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 8 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime8.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime8.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime8..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								elseif Index == 9 then
									ExecuteCommand("jail "..IdSelected.. " "..Config.PrisonTime9.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Tu viens de mettre en prison un joueur pendant "..Config.PrisonTime9.." minutes, Bien joué !", 10000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de mettre en prison un joueur pendant '..Config.PrisonTime9..' minutes, Bien joué !', 'CHAR_JEFF', 8)
									end
								end  
							end
							money.index = Index
						end)
					
					RageUI.ButtonWithStyle("Retirer de Prison", "retirer un joueur de prison", {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
								ExecuteCommand("unjail "..IdSelected)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Tu viens de retirer le joueur de sa prison zbi", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Prison', 'Tu viens de retirer le joueur de sa prison zbi', 'CHAR_JEFF', 8)
								end     
						end
					end, RMenu:Get('menu', 'options'))
				end, function()
				end)
					
				RageUI.IsVisible(RMenu:Get('menu', 'tele'), true, true, true, function()
					
					RageUI.ButtonWithStyle("S'y Téléporter", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected))))
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Téléportation sur le Joueur Réussie", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Staff Citylife', '~b~Téléportation', 'Téléportation sur le Joueur ~g~Réussie', 'CHAR_JEFF', 8)
							end			
						end
					end, RMenu:Get('menu', 'tele'))
					RageUI.ButtonWithStyle("Téléporter à vous", nil, {}, true, function(Hovered, Active, Selected, target)
						if (Selected) then
							local pos = GetEntityCoords(PlayerPedId())
							ExecuteCommand("bring "..IdSelected)
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Joueur Téléporté", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Staff Citylife', '~b~Téléportation', 'Joueur ~g~Téléporté', 'CHAR_JEFF', 8)
							end		
						end
					end, RMenu:Get('menu', 'tele'))
					RageUI.List('Téléporter à', tpa.list, tpa.index, "Choisis une destination. Le joueur sera automatiquement tp là-bas.", {}, true, function(Hovered, Active, Selected, Index)
						if (Selected) then
							if Index == 1 then
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp au "..Config.TpaName1.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName1..'', 'CHAR_JEFF', 8)
								end	
								ExecuteCommand("tpa "..IdSelected.. " "..Config.TpaCommand1.."")
							elseif Index == 2 then
								ExecuteCommand("tpa "..IdSelected.. " "..Config.TpaCommand2.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName2.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName2..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 3 then
								ExecuteCommand("tpa "..IdSelected.. " "..Config.TpaCommand3.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName3.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName3..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 4 then
								ExecuteCommand("tpa "..IdSelected.. " "..Config.TpaCommand4.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName4.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName4..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 5 then
								ExecuteCommand("tpa "..IdSelected.. " "..Config.TpaCommand5.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName5.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName5..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 6 then
								ExecuteCommand("tpa "..IdSelected.. " "..Config.TpaCommand6.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName6.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName6..'', 'CHAR_JEFF', 8)
								end	
							end  
						end
						tpa.index = Index
					end)
				end, function ()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'soin'), true, true, true, function()
					RageUI.ButtonWithStyle("Heal", "Restaurer la vie, le bouclier, la faim et la soif à 100% du joueur.", {RightBadge = RageUI.BadgeStyle.Heart}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("heal "..IdSelected)
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Heal du joueur réussi", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Administration', '~b~Heal', 'Heal du joueur ~g~réussi', 'CHAR_JEFF', 8)
							end	
						end
					end, RMenu:Get('menu', 'soin'))
					RageUI.ButtonWithStyle("Revive", "Réanimer un joueur", {RightBadge = RageUI.BadgeStyle.Heart}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("revive "..IdSelected)
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Réanimation du joueur réussie", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Administration', '~b~Réanimation', 'Réanimation du joueur ~g~réussie', 'CHAR_JEFF', 8)
							end	
						end
					end, RMenu:Get('menu', 'soin'))
				end, function ()
				end, RMenu:Get('menu', 'soin'))

				RageUI.IsVisible(RMenu:Get('menu', 'whipe'), true, true, true, function()
					if owner or superadmin or _dev then
						RageUI.ButtonWithStyle("Wipe l'inventaire", "~r~ATTENTION\nLe joueur perdra tout son inventaire !", {RightBadge = RageUI.BadgeStyle.Weed}, true, function(Hovered, Active, Selected)
							if (Selected) then
								ExecuteCommand("clearinventory "..IdSelected)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Whipe de l'inventaire réussi", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Whipe Inventaire', 'Whipe du joueur ~g~réussi', 'CHAR_JEFF', 8)
								end	
							end
						end)
					end
					if owner or superadmin or _dev then
						RageUI.ButtonWithStyle("Wipe les armes", "~r~ATTENTION\nLe joueur perdra toutes ses armes !", {RightBadge = RageUI.BadgeStyle.Gun}, true, function(Hovered, Active, Selected)
							if (Selected) then
								ExecuteCommand("clearloadout "..IdSelected)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Whipe des armes réussi", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Whipe des armes', 'Whipe du joueur ~g~réussi', 'CHAR_JEFF', 8)
								end	
							end
						end)
					end
				end, function ()
				end, 1)

				RageUI.IsVisible(RMenu:Get('menu', 'give'), true, true, true, function()
					if owner or superadmin or _dev then
						RageUI.ButtonWithStyle("Give Items", "Give un item au choix au joueur sélectionné.", { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'item'))
					end
					--[[if owner or superadmin or _dev then
						RageUI.ButtonWithStyle("Give Weapon", "~r~Pour connaître le nom des armes :\nhttps://forum.cfx.re/t/list-of-weapon-spawn-names-after-hours/90750", {RightBadge = RageUI.BadgeStyle.Gun}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local weapon = KeyboardInput("WEAPON_...", "", 100)
								local ammo = KeyboardInput("Munitions", "", 100)
								if weapon and ammo then
									ExecuteCommand("giveweapon "..IdSelected.. " " ..weapon.. " " ..ammo)
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Give armes réussi", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Give Armes', 'Give Armes ~g~réussi', 'CHAR_JEFF', 8)
									end			
								else
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Give item réussi", 5000, 'Champ Invalide')
									else
										ESX.ShowNotification("~r~ERROR 404\nChamp Invalide")
									end		
									RageUI.CloseAll()	
								end
							end
						end, RMenu:Get('menu', 'give'))
					end]]---- Give weapon grâce au noms
					RageUI.Separator(""..Config.Colors.."↓ ~w~Give Weapons "..Config.Colors.."↓")
					if owner or superadmin or _dev then 
						RageUI.List('Armes de poing', armesdepoinggive.list, money.index, "Choisis une Arme de poing parmis celles présentes dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_KNIFE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_KNUCKLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_CROWBAR 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_GOLFCLUB 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 5 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_BOTTLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 6 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_DAGGER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 7 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_HATCHET 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 8 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_KNUCKLEDUSTER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 9 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_FLASHLIGHT 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 10 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SWITCHBLADE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 11 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_POOLCUE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 12 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_WRENCH 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 13 then
									ExecuteCommand("giveweapon "..IdSelected.. " GADGET_PARACHUTE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 14 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_BATTLEAXE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 15 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_NIGHTSTICK 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 16 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_HAMMER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 17 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_BAT 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 18 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MACHETE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							money.index = Index
						end)
					end
					if owner or superadmin or _dev then 
						RageUI.List('Pistolets', pistolet.list, pistolet.index, "Choisis un Pistolet parmis ceux présentes dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_PISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_PISTOLMK2 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_PISTOLMK2 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_COMBATPISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 5 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SNSPISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 6 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_HEAVYPISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 7 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_VINTAGEPISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 8 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MARKSMANPISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 9 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_REVOLVER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 10 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_APPISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 11 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_STUNGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 12 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_FLAREGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							pistolet.index = Index
						end)
					end
					if owner or superadmin or _dev then 
						RageUI.List('Pistolets', smg.list, smg.index, "Choisis un SMG parmis ceux présentes dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MICROSMG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MACHINEPISTOL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SMGMK2 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_ASSAULTSMG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 5 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_COMBATPDW 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 6 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 7 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_COMBATMG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 8 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_COMBATMGMK2 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 9 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_KUSEMBERG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 10 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MINISMG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 11 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SMG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							smg.index = Index
						end)
					end
					if owner or superadmin or _dev then 
						RageUI.List('Fusils', fusil.list, fusil.index, "Choisis un Fusils parmis ceux présentes dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_ASSAULTRIFLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_ASSAULTRIFLEMK2 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_CARBINERIFLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_CARBINERIFLEMK2 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 5 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_ADVANCEDRIFLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 6 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_GUSENBERG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 7 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_RAYCARBINE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 8 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SPECIALCARBINE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 9 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_BULLPUPRIFLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 10 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_COMPACTRIFLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							fusil.index = Index
						end)
					end
					if owner or superadmin or _dev then 
						RageUI.List('Sniper', sniper.list, sniper.index, "Choisis un Fusils Sniper parmis ceux présentes dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SNIPERRIFLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_HEAVYSNIPER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_HEAVYSNIPERMK2 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MARKSMANRIFLE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							sniper.index = Index
						end)
					end
					if owner or superadmin or _dev then 
						RageUI.List('Fusil à Pompe', pompe.list, pompe.index, "Choisis un Fusil à Pompe parmis ceux présentes dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_DBSHOTGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_PUMPSHOTGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SAWNOFFSHOTGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_BULLPUPSHOTGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 5 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_ASSAULTSHOTGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 6 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MUSKET 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 7 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_DOUBLEBARRELSHOTGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 8 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_AUTOSHOTGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							pompe.index = Index
						end)
					end
					if owner or superadmin or _dev then 
						RageUI.List('RPG', RPG.list, RPG.index, "Choisis un RPG parmis ceux présents dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_GRENADELAUNCHER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_RPG 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MINIGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_FIREWORK 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 5 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_RAILGUN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 6 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_HOMINGLAUNCHER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 7 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_GRENADELAUNCHERSMOKE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 8 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_COMPACTLAUNCHER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							RPG.index = Index
						end)
					end
					if owner or superadmin or _dev then 
						RageUI.List('Explosifs', explosif.list, explosif.index, "Choisis un Explosif parmis ceux présents dans le serveur.\nL'arme sera automatiquement give au joueur avec des munitions", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_GRENADE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_STICKYBOMB 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_PROXIMITYMINE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 4 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_BZGAS 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								elseif Index == 5 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_MOLOTOV 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 6 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_FIREEXTINGUISHER 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 7 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_PETROLCAN 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 8 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_FLARE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 9 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_BALL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 10 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SNOWBALL 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 11 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_SMOKEGRENADE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								
								elseif Index == 12 then
									ExecuteCommand("giveweapon "..IdSelected.. " WEAPON_PARACHUTE 250")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son Arme", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Le joueur a bien reçu son Arme', 'CHAR_JEFF', 8)
									end
								end
							end
							explosif.index = Index
						end)
					end
				end, function ()
				end, RMenu:Get('menu', 'give'))

				RageUI.IsVisible(RMenu:Get('menu', 'setjob'), true, true, true, function()
					if owner or superadmin or _dev then
						RageUI.List('Métier', setjob.list, money.index, "Choisis un métier parmis ceux présent dans le serveur. Le joueur seras automatiquement patron de l'entreprise.", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN1.." "..Config.GradeMax1.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron "..Config.SetjobN1.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron '..Config.SetjobN1..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 2 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN2.." "..Config.GradeMax2.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron du "..Config.SetjobN2.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron du '..Config.SetjobN2..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 3 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN3.." "..Config.GradeMax3.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron du "..Config.SetjobN3.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron du '..Config.SetjobN3..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 4 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN4.." "..Config.GradeMax4.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron du "..Config.SetjobN4.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron du '..Config.SetjobN4..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 5 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN5.." "..Config.GradeMax5.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron de la "..Config.SetjobN5.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron de la '..Config.SetjobN5..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 6 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN6.." "..Config.GradeMax6.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron du "..Config.SetjobN6.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron du '..Config.SetjobN6..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 7 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN7.." "..Config.GradeMax7.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patrondu "..Config.SetjobN7.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patrondu '..Config.SetjobN7..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 8 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN8.." "..Config.GradeMax8.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron du "..Config.SetjobN8.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron du '..Config.SetjobN8..'', 'CHAR_JEFF', 8)
									end	
								elseif Index == 9 then
									ExecuteCommand("setjob "..IdSelected.. " "..Config.SetjobN9.." "..Config.GradeMax9.."")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant patron du "..Config.SetjobN9.."", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant patron du '..Config.SetjobN9..'', 'CHAR_JEFF', 8)
									end
								end  
							end
							money.index = Index
						end)
					end
				end, function()
				end, RMenu:Get("menu", "setjob"))

				RageUI.IsVisible(RMenu:Get('menu', 'setjob2'), true, true, true, function()
					if owner or superadmin or _dev then
						RageUI.List('Gang', setjob2.list, money.index, "Choisis un gang parmis ceux présent dans le serveur. Le joueur sera automatiquement Chef du Gang.", {}, true, function(Hovered, Active, Selected, Index)
							if (Selected) then
								if Index == 1 then
									ExecuteCommand("setjob2 "..IdSelected.. " ballas 3")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant Chef Ballas", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant Chef Ballas', 'CHAR_JEFF', 8)
									end
								elseif Index == 2 then
									ExecuteCommand("setjob2 "..IdSelected.. " families 3")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant Chef Families", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant Chef Families', 'CHAR_JEFF', 8)
									end
								elseif Index == 3 then
									ExecuteCommand("setjob2 "..IdSelected.. " vagos 3")
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur est maintenant Chef Vagos", 5000, 'info')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Setjob', 'Le joueur est maintenant Chef Vagos', 'CHAR_JEFF', 8)
									end
								end  
							end
							money.index = Index
						end)
					end
				end, function()
				end, RMenu:Get("menu", "setjob2"))

				RageUI.IsVisible(RMenu:Get('menu', 'inventaire'), true, true, true, function()

					RageUI.Separator("Inventaire de "..GetPlayerName(GetPlayerFromServerId(IdSelected)).." ["..Config.Colors.."".. GetPlayerServerId(PlayerId()) .."~s~]")
	
					RageUI.Separator(""..Config.Colors.."↓ ~s~Money "..Config.Colors.."↓")
	
					for k,v  in pairs(ArgentBank) do
						RageUI.ButtonWithStyle("Argent en banque :", nil, {RightLabel = "~b~"..v.label.."$"}, true, function(_, _, s)
						end)
					end
		
					for k,v  in pairs(ArgentCash) do
						RageUI.ButtonWithStyle("Argent Liquide :", nil, {RightLabel = "~g~"..v.label.."$"}, true, function(_, _, s)
						end)
					end
		
					for k,v  in pairs(ArgentSale) do
						RageUI.ButtonWithStyle("Argent sale :", nil, {RightLabel = "~r~"..v.label.."$"}, true, function(_, _, s)
						end)
					end
			
					RageUI.Separator(""..Config.Colors.."↓ ~s~Items "..Config.Colors.."↓")
	
					for k,v  in pairs(Items) do
						RageUI.ButtonWithStyle(v.label, nil, {RightLabel = ""..Config.Colors.."x"..v.right}, true, function(_, _, s)
						end)
					end
	
					RageUI.Separator(""..Config.Colors.."↓ ~s~Armes "..Config.Colors.."↓")
		
					for k,v  in pairs(Armes) do
						RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~r~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)
						end)
					end
			
				end, function() 
				end, RMenu:Get("menu", "inventaire"))
	
				RageUI.IsVisible(RMenu:Get('menu', 'options'), true, true, true, function()
					RageUI.Separator(""..Config.Colors.."↓ ~s~Actions "..Config.Colors.."↓", nil, {}, true, function(_, _, _)
                    end)
					RageUI.Separator("")
					RageUI.Separator("["..Config.Colors.."".. GetPlayerServerId(PlayerId()) .."~s~] "   ..GetPlayerName(GetPlayerFromServerId(IdSelected)))
					RageUI.Separator("")

					local job = ESX.PlayerData.job.name
					local job2 = ESX.PlayerData.job2.name

					RageUI.Info("~g~5-Dev", {"Nom Steam →", "Métier →", "Gang →", ""}, {""..GetPlayerName(GetPlayerFromServerId(IdSelected)).."", ""..job.."", ""..job2.."", "" })

					RageUI.ButtonWithStyle("Actions", "Actions disponibles sur le joueur", { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'action'))

					RageUI.ButtonWithStyle("Sanctions", "Afficher les sanctions disponible", { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'sanction'))

					RageUI.ButtonWithStyle("Téléportation", "Actions disponibles sur le joueur", { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'tele'))

					RageUI.ButtonWithStyle("Soins", "Actions disponibles sur le joueur", { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'soin'))

				if owner or superadmin or _dev then	
					RageUI.ButtonWithStyle("Whipe", "Actions disponibles sur le joueur", { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'whipe'))
				else
					RageUI.ButtonWithStyle('Whipe', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end
					
				if owner or superadmin or _dev then
					RageUI.ButtonWithStyle("Give", "Actions disponibles sur le joueur", { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'give'))
				else
					RageUI.ButtonWithStyle('Give', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end
            
			end, function()
			end, RMenu:Get("menu", "joueurs"))

			RageUI.IsVisible(RMenu:Get('menu', 'item'), true, true, true, function()

				RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
					filter = i
				end)


				RageUI.Separator("↓ ~g~Items disponibles ~s~↓")
				for id, itemInfos in pairs(allItemsServer) do
					if starts(itemInfos.label:lower(), filterArray[filter]:lower()) then
						RageUI.ButtonWithStyle("~b~→~s~ " .. itemInfos.label, nil, { RightLabel = "~b~Donner ~s~→→" }, true, function(_, _, s)
							if s then
								local qty = KeyBoardText("Quantité", "", 20)
								if qty ~= nil then
									TriggerServerEvent("finalmenuadmin:giveItem", IdSelected, itemInfos.name, qty)
									TriggerEvent('Ise_Logs2', 15158332, "Give Items", "Nom : "..GetPlayerName(PlayerId())..".\na donner "..itemInfos.name.." x "..qty.." à ".. GetPlayerName(GetPlayerFromServerId(IdSelected)))
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Le joueur a bien reçu son item", 7500, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Give Item', 'Le joueur a bien reçu son item', 'CHAR_JEFF', 8)
									end
								end
							end
						end)
					end
				end

			end, function()
			end) 

				RageUI.IsVisible(RMenu:Get('menu', 'commande'), true, true, true, function()
					RageUI.Separator(Config.RaccourcisCommand1)
					RageUI.Separator(Config.RaccourcisCommand2)
					RageUI.Separator(Config.RaccourcisCommand3)
					RageUI.Separator(Config.RaccourcisCommand4)
					RageUI.Separator(Config.RaccourcisCommand5)
					RageUI.Separator(Config.RaccourcisCommand6)
					RageUI.Separator(Config.RaccourcisCommand7)
					RageUI.Separator(Config.RaccourcisCommand8)
					RageUI.Separator(Config.RaccourcisCommand9)
					RageUI.Separator(Config.RaccourcisCommand10)
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'report'), true, true, true, function()

					if #allReportClient == 0 then
						RageUI.Separator("")
						RageUI.Separator("~r~Aucun report ouvert")
						RageUI.Separator("")
					else
						for k,infoPlayer in pairs(allReportClient) do
							RageUI.ButtonWithStyle("[~y~"..infoPlayer.idPlayer.."~s~] →→ "..infoPlayer.namePlayer, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
								if Selected then
									reportSelected, idReport = infoPlayer, k
								end
							end, RMenu:Get('menu', 'report2'))
						end
					end
	
				end, function()
				end)
	
				RageUI.IsVisible(RMenu:Get('menu', 'report2'), true, true, true, function()
				
					RageUI.Separator("")
					RageUI.Separator("Report de → "..Config.Colors..""..reportSelected.namePlayer.." ~s~[ "..Config.Colors.."".. GetPlayerServerId(PlayerId()) .."~s~ ]")
					RageUI.Separator("Raison du report~s~ → "..Config.Colors..""..reportSelected.reasonReport)
					RageUI.Separator("")

					RageUI.List('Téléporation', tpreport.list, tpreport.index, "Téléporte le joueur sur toi et inversement", {}, true, function(Hovered, Active, Selected, Index)
						if (Selected) then
							if Index == 1 then
								SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(reportSelected.idPlayer))))
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "TP vers joueur Réussi", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Administration', 'TP vers joueur ~g~Réussi', 'CHAR_JEFF', 8)
								end
							elseif Index == 2 then
								ExecuteCommand("bring "..reportSelected.idPlayer.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Bring du joueur Réussi", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Administration', 'Bring du joueur ~g~Réussi', 'CHAR_JEFF', 8)
								end
							end
						end
						tpreport.index = Index
					end)

					RageUI.List('Téléporter à', tpa.list, money.index, "Choisis une destination. Le joueur sera automatiquement tp là-bas.", {}, true, function(Hovered, Active, Selected, Index)
						if (Selected) then
							if Index == 1 then
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp au "..Config.TpaName1.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName1..'', 'CHAR_JEFF', 8)
								end	
								ExecuteCommand("tpa "..reportSelected.idPlayer.." "..Config.TpaCommand1.."")
							elseif Index == 2 then
								ExecuteCommand("tpa "..reportSelected.idPlayer.." "..Config.TpaCommand2.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName2.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName2..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 3 then
								ExecuteCommand("tpa "..reportSelected.idPlayer.." "..Config.TpaCommand3.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName3.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName3..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 4 then
								ExecuteCommand("tpa "..reportSelected.idPlayer.." "..Config.TpaCommand4.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName4.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName4..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 5 then
								ExecuteCommand("tpa "..reportSelected.idPlayer.." "..Config.TpaCommand5.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName5.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName5..'', 'CHAR_JEFF', 8)
								end	
							elseif Index == 6 then
								ExecuteCommand("tpa "..reportSelected.idPlayer.." "..Config.TpaCommand6.."")
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Vous l'avez tp à "..Config.TpaName6.."", 5000, 'info')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Téléportation', 'Vous l\'avez tp à '..Config.TpaName6..'', 'CHAR_JEFF', 8)
								end	
							end  
						end
						money.index = Index
					end)
	
					RageUI.ButtonWithStyle("Réanimer", "Réanime le joueur", {RightLabel = "→"},true, function(Hovered, Active, Selected)
						if Selected then
							ExecuteCommand("revive "..reportSelected.idPlayer.."")
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Revive de "..GetPlayerName(GetPlayerFromServerId(reportSelected.idPlayer)).." Réussi", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Administration', '~b~Administration', 'Revive de '..GetPlayerName(GetPlayerFromServerId(reportSelected.idPlayer))..' ~g~Réussi', 'CHAR_JEFF', 8)
							end
						end
					end)

					local job = ESX.PlayerData.job.name
					local job2 = ESX.PlayerData.job2.name

					RageUI.Info("~g~5-Dev", {"Nom Steam →", "Métier →", "Gang →", ""}, {""..reportSelected.namePlayer.."", ""..job.."", ""..job2.."", "" })

					RageUI.ButtonWithStyle("Regarder", "Permet de spect le joueur", {RightLabel = "→"},true, function(Hovered, Active, Selected)
						if Selected then
							local playerId = GetPlayerFromServerId(IdSelected)
							SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
						end
					end)
	
					RageUI.Separator(""..Config.Colors.."↓ ~s~Actions sur le report "..Config.Colors.."↓")
	
					RageUI.ButtonWithStyle("Cloturer ce report", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
						if Selected then
							TriggerServerEvent("rxwMenuAdmin:closeReport", idReport, reportSelected.idPlayer)
							ESX.TriggerServerCallback('rxwMenuAdmin:getAllReport', function(result)
								allReportClient = result
							end)
							RageUI.GoBack()
						end
					end)
	
	
				end, function()
				end, RMenu:Get("menu", "report2"))
	

				RageUI.IsVisible(RMenu:Get('menu', 'world'), true, true, true, function()
					RageUI.Separator(""..Config.Colors.."↓ ~s~Utilitaire "..Config.Colors.."↓")
					if owner or superadmin or _dev then
					RageUI.Checkbox("Invincible", description, invincible,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							invincible = Checked
							if Checked then
								SetEntityInvincible(PlayerPedId(), true)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "God Mod activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~God Mod', 'God Mod ~g~Activé', 'CHAR_JEFF', 8)
								end
							else
								SetEntityInvincible(PlayerPedId(), false)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "God Mod désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~God Mod', 'God Mod ~r~désactivé', 'CHAR_JEFF', 8)
								end
							end
						end
					end)
				else
					RageUI.ButtonWithStyle('Invincible', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end
				if owner or superadmin or _dev then
					RageUI.Checkbox("SuperJump", description, superJump,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							superJump = Checked
							if Checked then
								superman()
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Superjump activé", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Superjump', 'Superjump ~g~Activé', 'CHAR_JEFF', 8)
									end
							else
								superman()
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Superjump désactivé", 5000, 'error')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~Superjump', 'Superjump ~r~désactivé', 'CHAR_JEFF', 8)
									end
							end
						end
					end)
				else 
					RageUI.ButtonWithStyle('SuperJump', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end
				if owner or superadmin or _dev then
					RageUI.Checkbox("SuperNage", description, fastSwim,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							fastSwim = Checked
							if Checked then
								SetSwimMultiplierForPlayer(PlayerId(), 1.49)
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Supernage activé", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~SuperNage', 'SuperNage ~g~Activé', 'CHAR_JEFF', 8)
									end
							else
								SetSwimMultiplierForPlayer(PlayerId(), 1.0)
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Supernage désactivé", 5000, 'error')
									else
										ESX.ShowAdvancedNotification('Staff Citylife', '~b~SuperNage', 'SuperNage ~r~désactivé', 'CHAR_JEFF', 8)
									end
							end
						end
					end)
				else 
					RageUI.ButtonWithStyle('SuperNage', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end
				if owner or superadmin or _dev then
					RageUI.Checkbox("SuperSprint", description, fastSprint,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							fastSprint = Checked
							if Checked then
								SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Supersprint activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Supersprint', 'SuperSprint ~g~Activé', 'CHAR_JEFF', 8)
								end
							else
								SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Supersprint déactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Staff Citylife', '~b~Supersprint', 'Supersprint ~r~désactivé', 'CHAR_JEFF', 8)
								end
							end
						end
					end)
				else 
					RageUI.ButtonWithStyle('SuperSprint', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end
				if owner or superadmin or _dev or admin then
					RageUI.Checkbox("CrossHair", description, inforeta,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							inforeta = Checked
							if Checked then
								Admin.showcrosshair = not Admin.showcrosshair
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "CrossHair activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Crosshair', 'Crosshair ~g~Activé', 'CHAR_JEFF', 8)
								end
							else
								Admin.showcrosshair = not Admin.showcrosshair
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "CrossHair désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Crosshair', 'Crosshair ~r~Désactivé', 'CHAR_JEFF', 8)
								end
						end
					end
					end)
				else 
					RageUI.ButtonWithStyle('SuperSprint', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end

					if owner or superadmin or _dev then
						RageUI.ButtonWithStyle("Delete Zone", "~r~ATTENTION \n~s~Cette action delete tout les props, véhicules et peds qui ont spawn durant la session et qui ne sont pas fixe, y compris donc les voiture des joueurs", {RightBadge = RageUI.BadgeStyle.Star},true, function(Hovered, Active, Selected)
							if Selected then
								local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
								TriggerEvent('wld:delallveh')
								ClearAreaOfPeds(x,y,z, 50.0, 1)
								ClearAreaOfVehicles(x,y,z, 50.0, 1)  
								ClearAreaOfVehicles(x,y,z, 50.0, 1)
								
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Ped, Props et Voiture ont été delete", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Delete Zone', 'Ped, Props et Voiture ont été ~r~delete', 'CHAR_JEFF', 8)
								end
								
								return x,y,z
							end
						end)
					else 
						RageUI.ButtonWithStyle('Delete Zone', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
						end)
					end

					if owner or superadmin or _dev then
						RageUI.ButtonWithStyle("Annonce", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
							if Selected then
								local msg = JeffKeyboard("Message de l'annonce ?", "", 30)
								if msg then
									TriggerServerEvent("Jannonce:annonceServer", msg)
								else
									ESX.ShowNotification("L'annonce ne peut pas être vide !")
								end
							end
						end)
					else 
						RageUI.ButtonWithStyle('Annonce', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
						end)
					end
					RageUI.Separator(""..Config.Colors.."↓ ~s~Véhicule "..Config.Colors.."↓")
					RageUI.ButtonWithStyle("Spawn un Véhicule", nil, {RightBadge = RageUI.BadgeStyle.Car}
					, true, function(_, _, Selected)
					if Selected then
		
						local ped = GetPlayerPed(tgt)
						local ModelName = KeyboardInput("Véhicule", "", 100)
		
						if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
							RequestModel(ModelName)
							while not HasModelLoaded(ModelName) do
								Citizen.Wait(0)
							end
								local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true, true)
								TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
								Wait(50)
									Config.notif = Config.TF
									if Config.notif then
										exports['okokNotify']:Alert("Administration", "Spawn de la voiture effectué", 5000, 'success')
									else
										ESX.ShowAdvancedNotification('Administration', '~b~Spawn Véhicule', 'Spawn de la voiture ~g~effectué', 'CHAR_JEFF', 8)
									end
						else
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Erreur !", 5000, 'error')
							else
								ESX.ShowAdvancedNotification('Administration', '~b~Spawn Véhicule', '~r~Erreur !', 'CHAR_JEFF', 8)
							end
						end
					end
					end)
					RageUI.ButtonWithStyle("Réparer un Véhicule", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ExecuteCommand("repair ")
						end
					end)
					RageUI.ButtonWithStyle("Mettre en Fourrière", nil, {RightBadge = RageUI.BadgeStyle.Car}
					, true, function(_, Active, Selected)
					if Active then
						ShowMarker()
					end
					if Selected then
						TriggerEvent("esx:deleteVehicle")
					end
					end)
					if owner or superadmin or _dev then
						RageUI.ButtonWithStyle("Custom au maximum", nil, {RightBadge =  RageUI.BadgeStyle.Car}, true, function(Hovered, Active, Selected)
							if (Selected) then   
						    	FullVehicleBoost()
							end   
						end)
					else 
						RageUI.ButtonWithStyle('Custom au maximum', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
						end)
					end
					if owner or superadmin or _dev then
					RageUI.ButtonWithStyle("Changer la plaque du véhicule", nil, {RightBadge = RageUI.BadgeStyle.Car}
					, true, function(_, Active, Selected)
					if Selected then
						if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
							local plaqueVehicule = KeyboardInput("Plaque", "", 8)
							SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "La plaque du véhicule est désormais : "..plaqueVehicule.."", 5000, 'success')
							else
								ESX.ShowAdvancedNotification('Administration', '~b~Véhicule', 'La plaque du véhicule est désormais : ~g~'..plaqueVehicule..'', 'CHAR_JEFF', 8)
							end
						else
							ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Vous n'êtes pas dans un véhicule !", 5000, 'error')
							else
								ESX.ShowAdvancedNotification('Administration', '~b~Véhicule', '~r~Erreur\n~s~Vous n\'êtes pas dans un véhicule !', 'CHAR_JEFF', 8)
							end
						end
					end
					end)
				else 
					RageUI.ButtonWithStyle('Changer la plaque du véhicule', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end
				RageUI.Separator(""..Config.Colors.."↓ ~s~Armes "..Config.Colors.."↓")
				if owner or superadmin or _dev then
					RageUI.Checkbox("Ajouter/Retirer toutes les armes", description, give,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							give = Checked
							if Checked then
								TriggerServerEvent('sp_admin:giveweapon')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Toutes les armes sont dans ton inventaire", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Toutes les armes sont dans ton inventaire', 'CHAR_JEFF', 8)
								end
							else
							TriggerServerEvent('sp_admin:removeweapon')
							Config.notif = Config.TF
							if Config.notif then
								exports['okokNotify']:Alert("Administration", "Toutes les armes ont été retirés de ton inventaire", 5000, 'error')
							else
								ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Toutes les armes ont été ~r~retirés ~s~de ton inventaire', 'CHAR_JEFF', 8)
							end
						end
					end
					end) 
				else 
					RageUI.ButtonWithStyle('Ajouter/Retirer toutes les armes', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end	
				if owner or superadmin or _dev then
					RageUI.Checkbox("Balles infinies", description, infamo,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							infamo = Checked
							if Checked then
								TriggerEvent('sp_admin:toggleExplosiveAmmo')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Balles infinies activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Balles infinies ~g~activé', 'CHAR_JEFF', 8)
								end
							else
								TriggerEvent('sp_admin:toggleExplosiveAmmo')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Balles infinies désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Balles infinies ~r~désactivé', 'CHAR_JEFF', 8)
								end
						end
					end
					end) 
				else 
					RageUI.ButtonWithStyle('Balles infinies', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end	
		
				if owner or superadmin or _dev then
					RageUI.Checkbox("Teleport Gun", description, tpgun,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							tpgun = Checked
							if Checked then
								TriggerEvent('sp_admin:teleportGun')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Teleport Gun activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Teleport Gun ~g~activé', 'CHAR_JEFF', 8)
								end
							else
								TriggerEvent('sp_admin:teleportGun')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Teleport Gun désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Teleport Gun ~r~désactivé', 'CHAR_JEFF', 8)
								end
						end
					end
					end)
				else 
					RageUI.ButtonWithStyle('Teleport Gun', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end	 

				if owner or superadmin or _dev then
					RageUI.Checkbox("Balles explosives", description, exploammo,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							exploammo = Checked
							if Checked then
								TriggerEvent('sp_admin:explossiveAmmo')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Balles Explosives activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Balles Explosives ~g~activé', 'CHAR_JEFF', 8)
								end
							else
								TriggerEvent('sp_admin:explossiveAmmo')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Balles Explosives désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Balles Explosives ~r~désactivé', 'CHAR_JEFF', 8)
								end
						end
					end
					end) 
				else 
					RageUI.ButtonWithStyle('Balles explosives', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end	
				
				if owner or superadmin or _dev then
					RageUI.Checkbox("Véhicule Gun", description, guntraj,{},function(Hovered,Ative,Selected,Checked)
						if Selected then
							guntraj = Checked
							if Checked then
								TriggerEvent('sp_admin:vehicleGun')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Véhicule Gun activé", 5000, 'success')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Véhicule Gun ~g~activé', 'CHAR_JEFF', 8)
								end
							else
								TriggerEvent('sp_admin:vehicleGun')
								Config.notif = Config.TF
								if Config.notif then
									exports['okokNotify']:Alert("Administration", "Véhicule Gun désactivé", 5000, 'error')
								else
									ESX.ShowAdvancedNotification('Administration', '~b~Armes', 'Véhicule Gun ~r~désactivé', 'CHAR_JEFF', 8)
								end
						end
					end
					end) 
				else 
					RageUI.ButtonWithStyle('Véhicule Gun', "Vous n'avez pas le grade nécessaire", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
					end)
				end	

				end, function()
				end)
				Wait(0)
			end
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
				if IsControlJustPressed(0, Config.KeyOpenMenuAdmin) then
					ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
						playergroup = group
						if playergroup == 'owner' then
							owner = true
							superadmin = false
							openStaffMenu()
							tcheckmoisa()
						end
						if playergroup == 'superadmin' then
							superadmin = true
							openStaffMenu()
							tcheckmoisa()
						elseif playergroup == 'admin' then
							superadmin = false
							admin = true
							openStaffMenu()
						end
						if playergroup == 'mod' then
							superadmin = false
							admin = false
							mod = true
							openStaffMenu()
						elseif playergroup == '_dev' then
							_dev = true
							superadmin = false
							openStaffMenu()
							tcheckmoisa()
						end

					end)

				end -- Touche F10
	end
end)

function FullVehicleBoost()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		SetVehicleModKit(vehicle, 0)
		SetVehicleMod(vehicle, 14, 0, true)
		SetVehicleNumberPlateTextIndex(vehicle, 5)
		ToggleVehicleMod(vehicle, 18, true)
		SetVehicleColours(vehicle, 0, 0)
		SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
		SetVehicleModColor_2(vehicle, 5, 0)
		SetVehicleExtraColours(vehicle, 111, 111)
		SetVehicleWindowTint(vehicle, 2)
		ToggleVehicleMod(vehicle, 22, true)
		SetVehicleMod(vehicle, 23, 11, false)
		SetVehicleMod(vehicle, 24, 11, false)
		--SetVehicleWheelType(vehicle, 12) 
		SetVehicleWindowTint(vehicle, 3)
		ToggleVehicleMod(vehicle, 20, true)
		SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
		LowerConvertibleRoof(vehicle, true)
		SetVehicleIsStolen(vehicle, false)
		SetVehicleIsWanted(vehicle, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetCanResprayVehicle(vehicle, true)
		SetPlayersLastVehicle(vehicle)
		SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleTyresCanBurst(vehicle, false)
		SetVehicleWheelsCanBreak(vehicle, false)
		SetVehicleCanBeTargetted(vehicle, false)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		SetVehicleHasStrongAxles(vehicle, true)
		SetVehicleDirtLevel(vehicle, 0)
		SetVehicleCanBeVisiblyDamaged(vehicle, false)
		IsVehicleDriveable(vehicle, true)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleStrong(vehicle, true)
		RollDownWindow(vehicle, 0)
		RollDownWindow(vehicle, 1)
		SetVehicleNeonLightEnabled(vehicle, 0, true)
		SetVehicleNeonLightEnabled(vehicle, 1, true)
		SetVehicleNeonLightEnabled(vehicle, 2, true)
		SetVehicleNeonLightEnabled(vehicle, 3, true)
		SetVehicleNeonLightsColour(vehicle, 0, 0, 255)
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
		SetPedRagdollOnCollision(PlayerPedId(), false)
		ResetPedVisibleDamage(PlayerPedId())
		ClearPedDecorations(PlayerPedId())
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
		for i = 0,14 do
			SetVehicleExtra(veh, i, 0)
		end
		SetVehicleModKit(veh, 0)
		for i = 0,49 do
			local custom = GetNumVehicleMods(veh, i)
			for j = 1,custom do
				SetVehicleMod(veh, i, math.random(1,j), 1)
			end
		end
	end
end


RegisterCommand('reviveall', function()
    ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
        for _,v in pairs(Admin.Acces.General) do
            if group == v then
                TriggerServerEvent('xAdmin:reviveall')
            end
        end   
    end)
end)

RegisterCommand("spect", function(source, args, rawCommand) 
	ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
	playergroup = group
	if playergroup == 'owner' or playergroup == 'superadmin' or playergroup == '_dev' or playergroup == 'admin' or playergroup == 'mod' then
	idnum = tonumber(args[1])
	local playerId = GetPlayerFromServerId(idnum)
	SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
	else
	  Config.notif = Config.TF
	  if Config.notif then
		  exports['okokNotify']:Alert("Administration", "Vous n'avez pas accès à cette commande", 5000, 'warning')
	  else
		  ESX.ShowAdvancedNotification('Staff Citylife', '~b~Spec', 'Vous n\'avez pas accès à cette commande', 'CHAR_JEFF', 8)
	  end
	end
  end)
  end)


RegisterCommand(""..Config.CommandNoclip.."", function(source, args, rawCommand)
	NoClip = true
	invisible = true
	Config.notif = Config.TF
	if Config.notif then
		exports['okokNotify']:Alert("Administration", "Noclip activé", 5000, 'success')
	else
		ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noclip', 'Noclip ~g~activé', 'CHAR_JEFF', 8)
	end
end, false)

RegisterCommand(""..Config.CommandStopNoclip.."", function(source, args, rawCommand)
	FreezeEntityPosition(GetPlayerPed(-1), false)
	SetEntityCollision(GetPlayerPed(-1), 1, 1)
	NoClip = false
	invisible = false
	Config.notif = Config.TF
	if Config.notif then
		exports['okokNotify']:Alert("Administration", "Noclip désactivé", 5000, 'error')
	else
		ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noclip', 'Noclip ~r~désactivé', 'CHAR_JEFF', 8)
	end
end, false)

RegisterCommand("v2name", function(source, args, rawCommand)
	ShowName = true
	if Config.notif then
		exports['okokNotify']:Alert("Administration", "Les noms ont été activé", 5000, 'success')
	else
		ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noms', 'Les noms ont été ~g~activé', 'CHAR_JEFF', 8)
	end
end, false)

RegisterCommand("v2noname", function(source, args, rawCommand)
	ShowName = false
	Config.notif = Config.TF
	if Config.notif then
		exports['okokNotify']:Alert("Administration", "Les noms ont été désactivé", 5000, 'error')
	else
		ESX.ShowAdvancedNotification('Staff Citylife', '~b~Noms', 'Les noms ont été ~r~désactivé', 'CHAR_JEFF', 8)
	end
end, false)

RegisterCommand(""..Config.TpCommand1.."", function(source, args, rawCommand)
	if InStaff then
	ExecuteCommand("tp 221.2 -806.21 30.68 ")
	Config.notif = Config.TF
	if Config.notif then
		exports['okokNotify']:Alert("Administration", "TP au Parking Central réussi", 5000, 'success')
	else
		ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au Parking Central ~g~réussi', 'CHAR_JEFF', 8)
	end
	end
end, false)

RegisterCommand(""..Config.TpCommand4.."", function(source, args, rawCommand)
	if InStaff then
		ExecuteCommand("tp 425.16 -979.57 30.71 ")
		Config.notif = Config.TF
		if Config.notif then
			exports['okokNotify']:Alert("Administration", "TP au Commissariat réussi", 5000, 'success')
		else
			ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au Commissariat ~g~réussi', 'CHAR_JEFF', 8)
		end
	end
end, false)

RegisterCommand(""..Config.TpCommand2.."", function(source, args, rawCommand)
	if InStaff then
		ExecuteCommand("tp 373.45 -1610.59 29.29 ")
		Config.notif = Config.TF
		if Config.notif then
			exports['okokNotify']:Alert("Administration", "TP a la Fourrière réussi", 5000, 'success')
		else
			ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP a la Fourriere ~g~réussi', 'CHAR_JEFF', 8)
		end
	end
end, false)

RegisterCommand(""..Config.TpCommand3.."", function(source, args, rawCommand)
	if InStaff then
		ExecuteCommand("tp -231.57 6235.07 31.5 ")
		Config.notif = Config.TF
		if Config.notif then
			exports['okokNotify']:Alert("Administration", "TP au Serrurier réussi", 5000, 'success')
		else
			ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au Sérrurier ~g~réussi', 'CHAR_JEFF', 8)
		end
	end
end, false)

RegisterCommand(""..Config.TpCommand5.."", function(source, args, rawCommand)
	if InStaff then
		ExecuteCommand("tp 105.55137634277 -154.32872009277 54.830783843994 ")
		Config.notif = Config.TF
		if Config.notif then
			exports['okokNotify']:Alert("Administration", "TP au Concessionnaire réussi", 5000, 'success')
		else
			ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au Concessionnaire ~g~réussi', 'CHAR_JEFF', 8)
		end
	end
end, false)

RegisterCommand(""..Config.TpCommand6.."", function(source, args, rawCommand)
	if InStaff then
		ExecuteCommand("tp -75.287750244141 -818.49688720703 326.17514038086 ")
		Config.notif = Config.TF
		if Config.notif then
			exports['okokNotify']:Alert("Administration", "TP sur MazeBank réussi", 5000, 'success')
		else
			ESX.ShowAdvancedNotification('Staff Citylife', '~b~Administration', 'TP au Concessionnaire ~g~réussi', 'CHAR_JEFF', 8)
		end
	end
end, false)


RegisterCommand("staff", function(source, args, rawCommand)
    ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
        playergroup = group
        if playergroup ~= "user" then
            if not staff then
                staff = true
                local couleur = math.random(0,9)
                local model = GetEntityModel(GetPlayerPed(-1))
                armor = GetPedArmour(GetPlayerPed(-1))
                TriggerEvent('skinchanger:getSkin', function(skin)
					if model == GetHashKey("mp_m_freemode_01") then
						if owner then 
							clothesSkin = {
								['bags_1'] = 0, ['bags_2'] = 0,
								['tshirt_1'] = 15, ['tshirt_2'] = 2,
								['torso_1'] = 178, ['torso_2'] = 0,
								['arms'] = 31,
								['pants_1'] = 77, ['pants_2'] = 0,
								['shoes_1'] = 55, ['shoes_2'] = 0,
								['mask_1'] = 0, ['mask_2'] = 0,
								['bproof_1'] = 0,
								['chain_1'] = 0,
							    ['helmet_1'] = 91, ['helmet_2'] = 0,
							}
						end
						if superadmin then
							clothesSkin = {
								['bags_1'] = 0, ['bags_2'] = 0,
								['tshirt_1'] = 15, ['tshirt_2'] = 2,
								['torso_1'] = 178, ['torso_2'] = 5,
								['arms'] = 31,
								['pants_1'] = 77, ['pants_2'] = 5,
								['shoes_1'] = 55, ['shoes_2'] = 5,
								['mask_1'] = 0, ['mask_2'] = 5,
								['bproof_1'] = 0,
								['chain_1'] = 0,
							    ['helmet_1'] = 91, ['helmet_2'] = 5,
							}
						end
						if _dev then
							clothesSkin = {
								['bags_1'] = 0, ['bags_2'] = 0,
								['tshirt_1'] = 15, ['tshirt_2'] = 2,
								['torso_1'] = 178, ['torso_2'] = 3,
								['arms'] = 31,
								['pants_1'] = 77, ['pants_2'] = 3,
								['shoes_1'] = 55, ['shoes_2'] = 3,
								['mask_1'] = 0, ['mask_2'] = 0,
								['bproof_1'] = 0,
								['chain_1'] = 0,
							    ['helmet_1'] = 91, ['helmet_2'] = 3,
							}
						end
						if admin then
							clothesSkin = {
								['bags_1'] = 0, ['bags_2'] = 0,
								['tshirt_1'] = 15, ['tshirt_2'] = 2,
								['torso_1'] = 178, ['torso_2'] = 2,
								['arms'] = 31,
								['pants_1'] = 77, ['pants_2'] = 2,
								['shoes_1'] = 55, ['shoes_2'] = 2,
								['mask_1'] = 0, ['mask_2'] = 0,
								['bproof_1'] = 0,
								['chain_1'] = 0,
							    ['helmet_1'] = 91, ['helmet_2'] = 2,
							}
						end
						if mod then
							clothesSkin = {
								['bags_1'] = 0, ['bags_2'] = 0,
								['tshirt_1'] = 15, ['tshirt_2'] = 2,
								['torso_1'] = 178, ['torso_2'] = 1,
								['arms'] = 31,
								['pants_1'] = 77, ['pants_2'] = 1,
								['shoes_1'] = 55, ['shoes_2'] = 1,
								['mask_1'] = 0, ['mask_2'] = 0,
								['bproof_1'] = 0,
								['chain_1'] = 0,
							    ['helmet_1'] = 91, ['helmet_2'] = 1,
							}
						end
                    else
                        clothesSkin = {
                            ['bags_1'] = 0, ['bags_2'] = 0,
                            ['tshirt_1'] = 31, ['tshirt_2'] = 0,
                            ['torso_1'] = 180, ['torso_2'] = couleur,
                            ['arms'] = 36, ['arms_2'] = 0,
                            ['pants_1'] = 79, ['pants_2'] = couleur,
                            ['shoes_1'] = 58, ['shoes_2'] = couleur,
                            ['mask_1'] = 0, ['mask_2'] = 0,
                            ['bproof_1'] = 0,
                            ['chain_1'] = 0,
                            ['helmet_1'] = 90, ['helmet_2'] = couleur,
                        }
                    end
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                staff = false
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local isMale = skin.sex == 0
                    TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('skinchanger:loadSkin', skin)
                            TriggerEvent('esx:restoreLoadout')
                        end)
                    end)
                end)
                SetPedArmour(GetPlayerPed(-1), armor)

                FreezeEntityPosition(GetPlayerPed(-1), false)
                NoClip = false

                SetEntityVisible(GetPlayerPed(-1), 1, 0)
                NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), 0)

                for _, v in pairs(GetActivePlayers()) do
                    RemoveMpGamerTag(gamerTags[v])
                end

                for k,v in pairs(pBlips) do
                    RemoveBlip(v)
                end
            end
        end
    end)
end, false)

function bulletCoords()
    local result, coord = GetPedLastWeaponImpactCoord(GetPlayerPed(-1))
    return coord
end
      
function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player)
	return entity
end

function getGroundZ(x, y, z)
    local result, groundZ = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, z + 0.0, Citizen.ReturnResultAnyway())
    return groundZ
end

RegisterNetEvent("sp_admin:toggleExplosiveAmmo")
AddEventHandler("sp_admin:toggleExplosiveAmmo", function()
  infiniteAmmo = not infiniteAmmo
end) 

Citizen.CreateThread(function()
	while true do
		if Admin.showcrosshair then
			DrawTxt('+', 0.495, 0.484, 1.0, 0.3, MainColor)
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function() -- Teleport Gun
	while true do
	  Citizen.Wait(0)
  
	  if teleportGun then
		local x,y,z = table.unpack(bulletCoords())
		if x ~= 0 and y ~= 0 and z ~= 0 then
		  SetEntityCoords(GetPlayerPed(-1), x,y,z)
		end
	  end
	end
  end)

  RegisterNetEvent("sp_admin:teleportGun")
  AddEventHandler("sp_admin:teleportGun", function()
	teleportGun = not teleportGun
  end) 

  Citizen.CreateThread(function() -- Explosive Ammo
	while true do
	  Citizen.Wait(0)
  
	  if explossiveAmmo then
		SetExplosiveAmmoThisFrame(PlayerId())
		local x,y,z = table.unpack(bulletCoords())
		if x ~= 0 and y ~= 0 and z ~= 0 then
		  AddOwnedExplosion(GetPlayerPed(-1), x, y, z, explosionType, 20.0, true, false, 0.0)
		end
	  end
	end
  end)

  RegisterNetEvent("sp_admin:explossiveAmmo")
  AddEventHandler("sp_admin:explossiveAmmo", function()
	explossiveAmmo = not explossiveAmmo
  end) 

  Citizen.CreateThread(function() -- Vehicle Gun
	while true do
	  Citizen.Wait(0)
  
	  if vehicleGun then
		if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
		  if IsPedShooting(GetPlayerPed(-1)) then
			while not HasModelLoaded(GetHashKey(Config.vehicleGunVehicle)) do
						  Citizen.Wait(0)
						  RequestModel(GetHashKey(Config.vehicleGunVehicle))
			end
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			local veh =  CreateVehicle(GetHashKey(Config.vehicleGunVehicle), playerPos.x + (10 * GetEntityForwardX(GetPlayerPed(-1))), playerPos.y + (10 * GetEntityForwardY(GetPlayerPed(-1))), getGroundZ(playerPos.x + (10 * GetEntityForwardX(GetPlayerPed(-1))), playerPos.y + (10 * GetEntityForwardY(GetPlayerPed(-1))), playerPos.z + 5), GetEntityHeading(GetPlayerPed(-1)), true, true)
			SetEntityAsNoLongerNeeded(veh)
			SetVehicleForwardSpeed(veh, 150.0)
		  end
		end
	  end
	end
  end)  

  Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)    
		if (annonceState == true) then
			DrawRect(0.494, 0.227, 5.185, 0.118, 0, 0, 0, 150)
			DrawAdvancedTextCNN(0.588, 0.14, 0.005, 0.0028, 0.8, '~g~ '.."Annonce 5-dev"..' ~d~', 255, 255, 255, 255, 1, 0)
			DrawAdvancedTextCNN(0.586, 0.199, 0.005, 0.0028, 0.6, texteAnnonce, 255, 255, 255, 255, 7, 0)
			DrawAdvancedTextCNN(0.588, 0.246, 0.005, 0.0028, 0.4, "", 255, 255, 255, 255, 0, 0)
		end
	end
end)



  RegisterNetEvent("sp_admin:vehicleGun")
  AddEventHandler("sp_admin:vehicleGun", function()	
	vehicleGun = not vehicleGun
  end)


function tcheckmoisa()
    ESX.TriggerServerCallback('finalmenuadmin:getAllItems', function(allItems)
        allItemsServer = allItems
    end)
end
    
-- MAIN CODE --
function GetPlayers()
	local players = {}

	for _, i in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end


-- GIVE DE L'ARGENT
function GiveCash()
	local amount = KeyboardInput("Somme", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('vAdmin:GiveCash', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function GiveBanque()
	local amount = KeyboardInput("Somme", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('vAdmin:GiveBanque', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT EN BANQUE

-- GIVE DE L'ARGENT SALE
function GiveND()
	local amount = KeyboardInput("Somme", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('vAdmin:GiveND', amount)
		end
	end
end

----------test------------

CreateThread(function()
    while true do
        Wait(0)
        if delgun then
            if IsPlayerFreeAiming(PlayerId()) then
                local entity = getEntity(PlayerId())
                if IsPedShooting(GetPlayerPed(-1)) then
                    SetEntityAsMissionEntity(entity, true, true)
                    DeleteEntity(entity)
                end
            end
        end
    end
end)

function getEntity(player)
    local result, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

--------REPARER VEHICULE---------------
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand("repair", function(source, args, rawCommand)
	if InStaff then
    local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
	Config.notif = Config.TF
	if Config.notif then
		exports['okokNotify']:Alert("Administration", "Ton véhicule est réparé !", 5000, 'success')
	else
		ESX.ShowAdvancedNotification('Staff Citylife', '~b~Réparation Véhicule', 'Ton véhicule est réparé !', 'CHAR_JEFF', 8) 
	end
	

    SetVehicleFixed(playerVeh)
    SetVehicleDirtLevel(playerVeh, 0.0)
	end
end, false)

------------------------------------------------


RegisterNetEvent("wld:delallveh")
AddEventHandler("wld:delallveh", function ()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
                DeleteVehicle(vehicle) 
            end
        end
    end
end)

local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
  }
  
  local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
      local iter, id = initFunc()
      if not id or id == 0 then
        disposeFunc(iter)
        return
      end
      
      local enum = {handle = iter, destructor = disposeFunc}
      setmetatable(enum, entityEnumerator)
      
      local next = true
      repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
      until not next
      
      enum.destructor, enum.handle = nil, nil
      disposeFunc(iter)
    end)
  end
  
  function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
  end
  
  function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
  end
  
  function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
  end
  
  function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
  end
  
