local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_LOGIN")

Frame:SetScript("OnEvent", function(...)
	SetCVar("nameplateMaxDistance", 45)
	SetCVar("nameplateMaxScale", 1.0)
	SetCVar("nameplateMinScale", 1.0)
	SetCVar("nameplateLargerScale", 1.15)
	SetCVar("nameplateGlobalScale", 1.15)
	SetCVar("nameplateSelectedScale", 1.15)

	SetCVar("nameplateLargeBottomInset", -5) 
	SetCVar("nameplateLargeTopInset", -5) 
	SetCVar("nameplateOtherTopInset", -5)
	SetCVar("nameplateOtherBottomInset", -5)

	SetCVar('UnitNameGuildTitle', 0)
	SetCVar('UnitNamePlayerPVPTitle', 0)
	SetCVar("nameplateOverlapV", 0.6)
	SetCVar("nameplateOccludedAlphaMult", 0.4)
end)

--  Nametag font size
local function SetFont(obj,optSize)
	local fontName=obj:GetFont();
	obj:SetFont(fontName,optSize,"THINOUTLINE");
end

SetFont(SystemFont_LargeNamePlate, 8)
SetFont(SystemFont_NamePlate, 8)
SetFont(SystemFont_LargeNamePlateFixed, 8)
SetFont(SystemFont_NamePlateFixed, 8)


--  Move nametag
hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal",function(frame)
	frame.name:ClearAllPoints();--  Clear nametag anchors
	PixelUtil.SetPoint(frame.name,"BOTTOM",frame.healthBar,"TOP",0,2);--    Set new anchor
end);

--  Remove realm names
hooksecurefunc("CompactUnitFrame_UpdateName",function(frame)
	if ShouldShowName(frame) then
		frame.name:SetText(GetUnitName(frame.unit));
		if CompactUnitFrame_IsTapDenied(frame) then -- If unit has been tapped (opposite faction, or 5+ players of your faction.)
			frame.name:SetVertexColor(0.5, 0.5, 0.5, 1) -- Grey.
		elseif UnitAffectingCombat(frame.unit) and UnitCanAttack("player", frame.unit) and not UnitIsPlayer(frame.unit) then -- If unit is in combat, only for attackable NPCs.
			frame.name:SetVertexColor(1, 0, 0, 1) -- Red.
		else -- If unit not in combat.
			frame.name:SetVertexColor(1, 1, 1, 1) -- White.
		end		
		-- frame.name:Show()
	end
end);

-- move nameplates debuffs
hooksecurefunc(NameplateBuffContainerMixin,"UpdateAnchor",function(self)
    local parent=self:GetParent();
    local unit=parent.unit;

    if unit and ShouldShowName(parent) then
--      Replicate the calculation of the original function
        local offset=self:GetBaseYOffset()+((unit and UnitIsUnit(unit,"target")) and self:GetTargetYOffset() or 0);
        self:SetPoint("BOTTOM",parent,"TOP",0,-20);--    Apply offset here
    end--   We'll leave the false side of this alone to preserve the original anchor in that case
end);

-- nameplate buff size
hooksecurefunc(NameplateBuffContainerMixin,"OnLoad",function(self)
    self:SetScale(0.85);--   1 is default size.
end);

-- Colorize unit name when they are in combat.
local cleuFrame = CreateFrame("frame")
cleuFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
cleuFrame:SetScript("OnEvent", function(self, event)
	for _, frame in pairs(C_NamePlate.GetNamePlates()) do
		if CompactUnitFrame_IsTapDenied(frame.UnitFrame) then -- If unit has been tapped (opposite faction, or 5+ players of your faction.)
			frame.UnitFrame.name:SetVertexColor(0.5, 0.5, 0.5, 1) -- Grey.
		elseif UnitAffectingCombat(frame.UnitFrame.unit) and UnitCanAttack("player", frame.UnitFrame.unit) and not UnitIsPlayer(frame.UnitFrame.unit) then -- If unit is in combat, only for attackable NPCs.
			frame.UnitFrame.name:SetVertexColor(1, 0, 0, 1) -- Red.
		else -- If unit not in combat.
			frame.UnitFrame.name:SetVertexColor(1, 1, 1, 1) -- White.
		end
	end
end)

-- Threat display.
hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", function(frame)
	if not frame:IsForbidden() then
		-- Colorize unit frame depending on threat.
		local threat = UnitThreatSituation("player", frame.unit) -- Gets unit threat level, 3 = tanking, 2 = insecurely tanking/losing threat, 1/0 = not tanking.

		if C_NamePlate.GetNamePlateForUnit(frame.unit) ~= C_NamePlate.GetNamePlateForUnit("player") and frame.level then
			if threat == 3 then --3 = Securely tanking; make borders red.
				frame.healthBar.border:SetVertexColor(1, 0, 0, 1)
			elseif threat == 2 then -- 2 = Tanking, but somebody else has higher threat (losing threat); make borders orange.
				frame.healthBar.border:SetVertexColor(1, 0.5, 0, 1)
			elseif threat == 1 then -- 1 = Not tanking, but higher threat than tank; make borders yellow.
				frame.healthBar.border:SetVertexColor(1, 1, 0.4, 1)
						else -- 0 = Not tanking; make borders black.
				frame.healthBar.border:SetVertexColor(0, 0, 0, 1)
			end
		else
			frame.healthBar.border:SetVertexColor(frame.optionTable.defaultBorderColor:GetRGBA()) -- Thanks Blizzard...
		end
	end
end)
