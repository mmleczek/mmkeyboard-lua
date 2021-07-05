local allowmove = false
local CanWalk = false
local IsVisible = false
local CurrentRequestId = 0
local IsMainTaskWorking = false

local PendingRequests = {}

exports("Show", function(title_, can_walk, max_length, cb, type)
	if not IsVisible then
		Show(title_, can_walk, max_length, cb, type)
	end
end)

exports("ShowSync", function(title_, can_walk, max_length, type)
	if not IsVisible then
		local __done = false
		local __return = nil
		
		Show(title_, can_walk, max_length, function(data)
			__return = data
			__done = true
		end, type)

		while not __done do
			Citizen.Wait(0)
		end

		return __return
	else
		return nil
	end
end)

exports("IsVisible", function()
	return IsVisible
end)

exports("Hide", function()
	Hide()
end)

RegisterNUICallback("allowmove", function(data, cb)
	allowmove = data.allowmove
end)

RegisterNUICallback("response", function(data, cb)
	local req = data.request
	if req ~= -1 then
		local text = data.value
		if PendingRequests[req] ~= nil then
			PendingRequests[req](text)
			PendingRequests[req] = nil
		end
	end
	Hide()
end)

function Show(title_, can_walk, max_length, cb, type_)
	if cb ~= nil then
		local req = GetRequestId()

		if type_ ~= "text" and type_ ~= "small_text" and type_ ~= "number" then
			type_ = "text"
		end

		IsVisible = true
		CanWalk = can_walk

		SendNUIMessage({
			show = true,
			request = req,
			maxlength = max_length,
			title = title_,
			type = type_
		})

		PendingRequests[req] = cb

		if not IsMainTaskWorking then
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			SpawnMainTask()
		end

		TriggerEvent("mmkeyboard:status", IsVisible)
	end
end

function GetRequestId()
	if CurrentRequestId < 65535 then
		CurrentRequestId = CurrentRequestId + 1
		return CurrentRequestId
	else
		CurrentRequestId = 0
		return CurrentRequestId
	end
end

function SpawnMainTask()
	if not IsMainTaskWorking then
		IsMainTaskWorking = true
		Citizen.CreateThread(function()
			while IsMainTaskWorking do
				DisableAllControlActions(0)
				EnableControlAction(0, 249, true)
				EnableControlAction(0, 166, true)
				EnableControlAction(0, 167, true)
				EnableControlAction(0, 168, true)
				DisableControlAction(0, 138, true)
				DisableControlAction(0, 52, true)

				if allowmove and CanWalk then
					EnableControlAction(0, 30, true)
					EnableControlAction(0, 31, true)
					EnableControlAction(0, 32, true)
					EnableControlAction(0, 33, true)
					EnableControlAction(0, 34, true)
					EnableControlAction(0, 35, true)
				end
				Citizen.Wait(0)
			end
		end)
	end
end

function Hide()
	SendNUIMessage({ hide = true })
	IsVisible = false

	TriggerEvent("mmkeyboard:status", IsVisible)

	SetTimeout(200, function()
		SetNuiFocusKeepInput(false)
		SetNuiFocus(false, false)
		IsMainTaskWorking = false
	end)
end