--Brick-Eyes Brick Dragon
local s,id=GetID()
function s.initial_effect(c)
    --link material
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,s.matfilter,1,1)
    --extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
end
-- Link material
function s.matfilter(c)
	return c:IsLinkRace(RACE_DRAGON) and c:IsLevelAbove(7) and not c:IsLinkType(TYPE_EFFECT)
end
function s.exmatcheck(c,lc,tp)
	if not c:IsLocation(LOCATION_HAND) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do	 
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(id) then return false end
	end
	return true	 
end