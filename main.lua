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
		frame.name:SetVertexColor(1,1,1);-- Fixes tapped mobs permanently setting the nametag gray
		frame.name:SetText(GetUnitName(frame.unit));
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