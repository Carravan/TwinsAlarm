TwinsAlarm = {}

TwinsAlarm.player = UnitName("player")
TwinsAlarm.version = 12
TwinsAlarm.utime = 0

local function printhelp(...) if select('#',...)>0 then return tostring((select(1,...))), printhelp(select(2,...)) end end

local function debug(...)
	ChatFrame1:AddMessage('Debug: '..strjoin(',',printhelp(...)))
end

local function print(...)
	ChatFrame1:AddMessage(strjoin(',',printhelp(...)))
end

function TwinsAlarm:Init()
	SLASH_TWINSALARM1 = "/ta"
	SlashCmdList["TWINSALARM"] = function(msg)
		if (msg == "vc") then
			print("|cFFFFFF00TwinsAlarm: Requesting Version Check...|r")
			SendAddonMessage("TwinsAlarm", "version", "RAID")
		end
	end
end

function TwinsAlarm:UpdateZone()
	if (strfind(GetMinimapZoneText(),WLZONE) ~= nil) then
		TwinsAlarmTimer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	elseif (strfind(GetMinimapZoneText(),WLZONE) == nil) then
		TwinsAlarmTimer:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		TwinsAlarmTimer:UnregisterEvent("UNIT_TARGET")
	end
end

function TwinsAlarm:VersionCheck(...)
	if arg2=="version" then
		SendAddonMessage("TwinsAlarm", TwinsAlarm.player..": "..TwinsAlarm.version, "WHISPER", arg4)
	elseif arg2~="version" then	
		local VCReplyRNum = string.sub(arg2, -2)
		local rnumconv = tonumber(VCReplyRNum)
		if rnumconv < TwinsAlarm.version then
			print("|cFFFF0000"..arg2.."|r")
		elseif rnumconv == TwinsAlarm.version then
			print("|cFFFFFF00"..arg2.."|r")
		elseif rnumconv > TwinsAlarm.version then
			print("|cFF00FF00"..arg2.."|r")
		end
	end
end

function TwinsAlarm:CheckCast(_, _, _, TAkind, _, TAcaster, _, _, _, _, _, TAspellname, ...)
	if (strfind(TAcaster,WLNAME) ~= nil) and (strfind(TAspellname,WLCAST) ~= nil) then
		if (TwinsAlarm.player == UnitName('focustarget')) then
			TwinsAlarm:ShowAlarm()
		else
			TwinsAlarmTimer:RegisterEvent("UNIT_TARGET")
		end
	else
		TwinsAlarmTimer:UnregisterEvent("UNIT_TARGET")
	end
end

function TwinsAlarm:UpdateFocus()
	if (TwinsAlarm.player == UnitName('focustarget')) then
		TwinsAlarm:ShowAlarm()
	else
		TwinsAlarmTimer:UnregisterEvent("UNIT_TARGET")
	end
end

function TwinsAlarm:ShowAlarm()
	TwinsAlarm.utime = GetTime()
	PlaySoundFile("Interface\\AddOns\\TwinsAlarm\\howlinghusky.mp3")
	TwinsAlarmMain:Show()
	TwinsAlarmTimer:UnregisterEvent("UNIT_TARGET")
	TwinsAlarmTimer:SetScript("OnUpdate", TwinsAlarm.HideAlarm)
end
	
function TwinsAlarm:HideAlarm()
	if (GetTime() > (TwinsAlarm.utime + 6.5)) then
		TwinsAlarmMain:Hide()
		TwinsAlarmTimer:SetScript("OnUpdate", nil)
	end
end