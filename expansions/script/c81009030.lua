--祝福的终点·二宫飞鸟
function c81009030.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81009030)
	e1:SetCondition(c81009030.spcon)
	c:RegisterEffect(e1)
end
function c81009030.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(1500)
end
function c81009030.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81009030.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
