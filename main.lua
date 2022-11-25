--v1.0.0
local frame = CreateFrame("Frame")
local events = {}

function events:NAME_PLATE_UNIT_ADDED(plate)
	local nameplate = C_NamePlate.GetNamePlateForUnit(plate)
	local frame = nameplate.UnitFrame
	if not nameplate or frame:IsForbidden() then return end
	local text_name = frame.healthBar.unitName:GetText()
	print("Hello: ",text_name)
	-- if (text) then
    --     local  a ,b, c ,d ,e ,f =  strsplit(" ",text,5)   
	-- 	unitFrame.healthBar.unitName:SetText (f or e or d or c or b or a)  
    -- end 	
end

for e, u in pairs(events) do
	frame:RegisterEvent(e)
end

frame:SetScript("OnEvent", function(self, event, ...) events[event](self, ...) end)
