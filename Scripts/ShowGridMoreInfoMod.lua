local ShowGridMoreInfoMod = GameMain:GetMod("ShowGridMoreInfo")

function ShowGridMoreInfoMod:OnInit()

	ShowGridMoreInfoMod.tbFertilityColor = {}
	ShowGridMoreInfoMod.tbFertilityColor[XT("土壤肥沃")] = "#008F00"
	ShowGridMoreInfoMod.tbFertilityColor[XT("土壤丰饶")] = "#B7FC7E"
	ShowGridMoreInfoMod.tbFertilityColor[XT("土壤良质")] = "#AEFF00"
	ShowGridMoreInfoMod.tbFertilityColor[XT("土壤贫瘠")] = "#8F4F4F"

	local tbEventMod = GameMain:GetMod("_Event")
	tbEventMod:RegisterEvent(g_emEvent.WindowEvent, self.OnWindowEvent, self)
end

function ShowGridMoreInfoMod:OnRender(_)
	self:ShowGridInfo()
end

function ShowGridMoreInfoMod:ShowGridInfo()
	if CS.UI_WorldLayer.Instance == nil then
		return
	end

	if GridMgr == nil then
		return
	end

	if CS.Wnd_GameMain.Instance.UIInfo == nil then
		return
	end
	
	if self.bHasResizeTextArea ~= true then
		CS.Wnd_GameMain.Instance.UIInfo.m_n32.UBBEnabled = true
		CS.Wnd_GameMain.Instance.UIInfo.m_n32:SetSize(200, 175)
		self.bHasResizeTextArea = true
	end
	
	xlua.private_accessible(CS.Wnd_GameMain)
	local curKey = CS.Wnd_GameMain.Instance.lastkey
	
	if curKey == self.lastKey and self.gatheringLing ~= true then
		return
	end
	self.lastKey = curKey
	self.gatheringLing = false
	
	local textfield = CS.Wnd_GameMain.Instance.UIInfo.m_n32
	
	if not GridMgr:KeyVaild(curKey) then
		textfield.text = XT("未探索")
		return
	end

	local fLing = Map:GetLing(curKey)
	local fLingAddion = Map.Effect:GetEffect(curKey, CS.XiaWorld.g_emMapEffectKind.LingAddion)
	local fLingAddionInFact = Map.Effect:GetEffect(curKey, CS.XiaWorld.g_emMapEffectKind.LingAddion, 0, true)
	local fToMaxLingAddionTime = 0
	if fLingAddion ~= fLingAddionInFact then
		local MapEffectData = Map.Effect:GetEffectData(curKey, CS.XiaWorld.g_emMapEffectKind.LingAddion)
		fToMaxLingAddionTime = MapEffectData.creattime + 3000 - TolSecond
		self.gatheringLing = true
	end

	local strLingAddion = self:formatLingAddionStr(fLingAddion, fToMaxLingAddionTime)

	if CS.Wnd_GameMain.Instance.openFengshui then
		local EArray = Map:GetElement(curKey)
		local EPArray = Map:GetElementProportion(curKey)
		textfield.text = string.format(
			XT("灵气：%.2f") .. "\r\n" ..
			XT("聚灵：%s") .. "\r\n" ..
			"[color=#FFEB68]" .. XT("金：") .. "%05.2f  %02.0f%%[/color]\r\n" ..
			"[color=#81C1F5]" .. XT("水：") .. "%05.2f  %02.0f%%[/color]\r\n" ..
			"[color=#78C84E]" .. XT("木：") .. "%05.2f  %02.0f%%[/color]\r\n" ..
			"[color=#DA494E]" .. XT("火：") .. "%05.2f  %02.0f%%[/color]\r\n" ..
			"[color=#986B39]" .. XT("土：") .. "%05.2f  %02.0f%%[/color]",
				fLing,
				strLingAddion,
				EArray[1], EPArray[1] * 100,
				EArray[3], EPArray[3] * 100,
				EArray[2], EPArray[2] * 100,
				EArray[4], EPArray[4] * 100,
				EArray[5], EPArray[5] * 100
		)
		return
	end

	local fTemperature = Map:GetTemperature(curKey)
	local fFertility = Map:GetFertility(curKey)
	local fBeauty = Map:GetBeauty(curKey, true)
	local fLight = Map:GetLight(curKey)
	local strTerrainName = Map.Terrain:GetTerrainName(curKey, true)
	local TerrainDef = Map.Terrain:GetTerrain(curKey)

	local nX = (curKey - curKey % Map.Size) / Map.Size + 1
	local nY = curKey % Map.Size + 1
	local strTerrainDesc = Map.Terrain:GetTerrainName(curKey, false)
	local strFertilityDesc = self:GetValueByMap(GameDefine.FertilityDesc, fFertility)
	local strTemperatureDesc = self:GetValueByMap(GameDefine.TemperatureDesc, fTemperature)
	local strBeautyDesc = self:GetValueByMap(GameDefine.BeautyDesc, fBeauty)
	local strLightDesc = self:GetValueByMap(GameDefine.LightDesc, fLight)
	local strRoom = ""
	local strTerrainDesc2 = ""
	local strTemperature = tostring(fTemperature)
	local strIce = ""

	if AreaMgr:CheckArea(curKey, "Room") ~= nil then
		strRoom = XT("(室)")
	end

	if TerrainDef.IsWater and Map.Snow:GetSnow(curKey) >= 200 then
		strIce = XT("(冰)")
	end

	if strTerrainName ~= nil and strTerrainName ~= "" then
		strTerrainDesc2 = string.format("(%s)", strTerrainName)
	end

	-- {0}{8}{6}\n{1}\n{2}\n{4}\n{3}{5}({7:f1}℃)
	textfield.text = string.format(
		XT("灵气：%.2f") .. "\r\n" ..
		XT("聚灵：%s") .. "\r\n" ..
		"%s %s %s(%d, %d)\r\n" ..
		"[color=%s]%s (%.2f)[/color]\r\n" ..
		"%s (%.2f)\r\n" ..
		"[color=%s]%s (%.2f)[/color]\r\n" ..
		"[color=%s]%s %s (%.1f℃)[/color]",
			fLing,
			strLingAddion,
			strTerrainDesc, strIce, strTerrainDesc2, nX, nY,
			self:getFertilityColor(strFertilityDesc), strFertilityDesc, fFertility,
			strBeautyDesc, fBeauty,
			self:getLightColor(), strLight, fLight,
			self:getTemperatureColor(), strTemperatureDesc, strRoom, strTemperature
	)
end

function ShowGridMoreInfoMod:GetValueByMap(tbMap, key)
	local value
	for k, v in pairs(tbMap) do
		if key >= k then
			return v
		end
		value = v
	end
	return value
end

-- 游戏的时间转成便于现实阅读的时间格式
function ShowGridMoreInfoMod:GameTime2Str(fGameTime)
	if fGameTime > 600 then
		return string.format("%.2f" .. XT("天"), fGameTime / 600)
	end
	local fReallyTime = fGameTime / 600 * 24 * 3600
	local nHour = math.modf(fReallyTime / 3600)
	local nMin = math.modf(fReallyTime % 3600 / 60)
	return string.format("%02d:%02d", nHour, nMin)
end

function ShowGridMoreInfoMod:formatLingAddionStr(fLingAddion, fToMaxLingAddionTime)
	if fLingAddion == 0 then
		return XT("无")
	elseif fToMaxLingAddionTime == 0 then
		return string.format("%.2f[color=#00FF00]" .. XT("(最高值)") .. "[/color]", fLingAddionInFact)
	else
		return string.format("%.2f[color=#FF0000](%s后到%.2f)[/color]", fLingAddionInFact, self:GameTime2Str(fToMaxLingAddionTime), fLingAddion)
	end
end

function ShowGridMoreInfoMod:getLightColor(fLight)
	if fLight <= 50 then
		return "#000000"
	else
		return "#ffffff"
	end
end

function ShowGridMoreInfoMod:getTemperatureColor(fTemperature)
	if fTemperature <= 150 then
		return "#0e58cf"
	elseif fTemperature < 0 then
		return "#68ace3"
	elseif fTemperature < 100 then
		return "#222222"
	elseif fTemperature < 500 then
		return "#e0662d"
	else
		return "#ff0000"
	end
end
