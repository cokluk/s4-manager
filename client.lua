S4 = {}
S4.DrawText3DData = {}


S4.DrawText3D = function(x,y,z,text,trigger,side,data,key,color,distance)
   S4.DrawText3DData[#S4.DrawText3DData+1] = { coords = vector3(x,y,z), text = text, trigger = trigger, side = side, data = data, key = key, color = color, distance = distance  } 
   RefreshDrawText3D()
end

-- Citizen.CreateThread(function()
    -- S4.DrawText3D(65.64396, -1058.097, 29.33044, "Selam", "s4:level:up")
	-- S4.DrawText3D(70.36484, -1045.793, 29.43152, "Selam 2", "s4:level:up")
-- end)
 

RefreshDrawText3D = function() 

Citizen.CreateThread(function()
	   while true do
	     sleepthread = 2000
	     local pPed = PlayerPedId()
	     local pCoords = GetEntityCoords(pPed)
		 for k, v in pairs(S4.DrawText3DData) do
		   local distance = #(pCoords - v.coords)
		   if not v.distance then 
		     v.distance = 5.0
		   end
		   if distance <= v.distance then
					sleepthread = 1
					if distance <= 3.5 then
					    if not v.color then 
						   v.color = "#fff"
						end
						DrawText3D(v.coords.x , v.coords.y, v.coords.z, v.text, v.color)
						if not v.key then 
						   v.key = 38
						end
						if IsControlJustPressed(1, v.key) then
						  if not v.side then
						    v.side = "client"
						  end
						  if v.side == "server" then 
						    if v.data then 
							  TriggerServerEvent(v.trigger, v.data)
							else 
							  TriggerServerEvent(v.trigger)
							end
						  else 
						    if v.data then 
						      TriggerEvent(v.trigger, v.data)
							else 
							  TriggerEvent(v.trigger)
							end
						  end
						  Wait(1000)
						end
					end
				end
		 end
		 Citizen.Wait(sleepthread)
	   end 
end)

end

function DrawText3D(x,y,z,text,color)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
 
    SetTextColour(255,255,255,255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

AddEventHandler('s4:getManager', function(cb)
	cb(S4)
end)

function getManager()
	return S4
end