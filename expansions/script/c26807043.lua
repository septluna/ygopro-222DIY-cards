--燃烬的现实
function c26807043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c26807043.condition)
	e1:SetTarget(c26807043.target)
	e1:SetOperation(c26807043.activate)
	c:RegisterEffect(e1)
end
function c26807043.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c26807043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToChangeControler() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function c26807043.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and re:GetHandler():IsRelateToEffect(re) then
	   local tc=eg:GetFirst()
	   Duel.GetControl(tc,tp)
	end
end
