-- RPFSTUDIO BODYGUARD 1.0 WIP

-- blips on the map
-- blip sur la carte

local blips = {
   {title="valentine", id=1560611276, x=-360.20, 740.00, 116.00},
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = Citizen.InvokeNative(0x554d9d53f696d002, info.id, info.x, info.y, info.z)
    end      
end)

-- Clothe shop
-- magasin de vetement

Citizen.CreateThread(function()
    WarMenu.CreateMenu('guard', "Garde du corp")
    WarMenu.SetSubTitle('guard', 'Louer son service')
    WarMenu.CreateSubMenu('ped', 'guard', 'Garde du corp')


    while true do

        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(PlayerPedId())

        if WarMenu.IsMenuOpened('guard') then

            if WarMenu.MenuButton('Sont disponible', 'ped') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('ped') then
            if WarMenu.Button('Appeler pour 2 $') then
                TriggerServerEvent("buy:guard", 2) 
            end

            WarMenu.Display()
        elseif (Vdist(coords.x, coords.y, coords.z, -360.20, 740.00, 116.00) < 2.0) then
               TriggerEvent("enter:guard")
               if IsControlJustReleased(0, 0xC7B5340A) then
                WarMenu.OpenMenu('guard')
               end
        end
        Citizen.Wait(0)
    end
end)

-- callback or?

RegisterNetEvent('cancel')
  AddEventHandler('cancel', function()
    SetTextScale(0.5, 0.5)
    --SetTextFontForCurrentCommand(1)
    local msg = "Tu as pas de cash !!!"
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", msg, Citizen.ResultAsLong())

    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
  end)

RegisterNetEvent('enter:guard')
  AddEventHandler('enter:guard', function()
    SetTextScale(0.5, 0.5)
    --SetTextFontForCurrentCommand(1)
    local msg = "Touche Entrée pour ouvrir le Menu"
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", msg, Citizen.ResultAsLong())

    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
  end)

-- save guard

RegisterNetEvent('loadguard')
AddEventHandler('loadguard', function(kek) 
   TriggerEvent("bart", true)
end)

---- spawn npc

local function PerformRequest(hash)
    print("requesting model " .. hash)

    RequestModel(hash, 0) -- RequestModel

    local times = 1

    print("requested " .. times .. " times")

    while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, hash) do -- HasModelLoaded
        Citizen.InvokeNative(0xFA28FE3A6246FC30, hash, 0) -- RequestModel

        times = times + 1

        print("requested " .. times .. " times")

        Citizen.Wait(0)
        
        if times >= 100 then break end
    end
end
        
function lePlayerModel(name)
    local model = GetHashKey(name)
    local player = PlayerId()
    
    if not IsModelValid(model) then return end
    PerformRequest(model)
    
    if HasModelLoaded(model) then
        -- SetPlayerModel(player, model, false)
        Citizen.InvokeNative(0xED40380076A31506, player, model, false)
        Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), true)
        SetModelAsNoLongerNeeded(model)
    end
end

RegisterNetEvent('bart')
AddEventHandler('bart', function(source, args) 
    CreateThread(function()
        local model = `mp_male`
        PerformRequest(model)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 0))
        bart = CreatePed(model, x+2, y+2, z, 0.0, true, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, bart, true)
        
        SetPedOutfitPreset(bart, 38)
        Citizen.Wait(500)
        SetPedAsCharacter(bart, "bart")
        Citizen.Wait(500)
        
        PerformRequest("w_shotgun_doublebarrel01")
        GiveWeapon(bart, "WEAPON_SHOTGUN_DOUBLEBARREL", 500, false, 1, false, 0.0)
        SetModelAsNoLongerNeeded("w_shotgun_doublebarrel01")
        
        Citizen.Wait(500)
        
        SetPedAsGroupMember(bart, GetPedGroupIndex(PlayerPedId()))
    end)
end)
