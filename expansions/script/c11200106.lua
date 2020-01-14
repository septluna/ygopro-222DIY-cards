--虚构之炎
function c11200106.initial_effect(c)
	aux.AddRitualProcGreater2Code2(c,11200104,11200209,LOCATION_HAND+LOCATION_REMOVED,c11200106.mfilter)
	--ritual summon
	local e1=aux.AddRitualProcGreater2Code2(c,11200104,11200209,LOCATION_HAND+LOCATION_REMOVED,c11200106.mfilter)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,11200106)
	e1:SetCost(c11200106.rscost)
end
function c11200106.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c11200106.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
