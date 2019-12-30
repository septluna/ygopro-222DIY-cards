--两栖类的神明
function c11200030.initial_effect(c)
	aux.AddCodeList(c,11200029)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11200029,aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),1,true,true)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(11200029)
	c:RegisterEffect(e0)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c11200030.atktg)
	e1:SetValue(c11200030.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11200030+EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c11200030.descon1)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c11200030.destg)
	e3:SetOperation(c11200030.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetCountLimit(1,11200030+EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c11200030.descon2)
	c:RegisterEffect(e4)
end
function c11200030.atktg(e,c)
	return c:IsRace(RACE_AQUA)
end
function c11200030.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1620)*400
end
function c11200030.tgfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_AQUA) and c:IsControler(tp)
end
function c11200030.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200030.tgfilter,1,nil,tp)
end
function c11200030.descon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c11200030.tgfilter,1,nil,tp)
end
function c11200030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11200030.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
