--黯之群狼 布蕾克
function c11200302.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_FIRE),2)
	c:EnableReviveLimit()
	--actlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(0,1)
	e0:SetCondition(c11200302.actcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,11200302)
	e4:SetCost(c11200302.spcost)
	e4:SetTarget(c11200302.sptg)
	e4:SetOperation(c11200302.spop)
	c:RegisterEffect(e4)
end
function c11200302.cfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsControler(tp) and (bit.band(c:GetType(),0x81)==0x81 or c:IsType(TYPE_FUSION))
end
function c11200302.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c11200302.cfilter(a,tp)) or (d and c11200302.cfilter(d,tp))
end
function c11200302.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost()
end
function c11200302.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200302.dfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11200302.dfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11200302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81009019,0,0x4011,2400,2400,8,RACE_ROCK,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11200302.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,81009019,0,0x4011,2400,2400,8,RACE_ROCK,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,81009019)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
