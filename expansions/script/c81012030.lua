--Cristierra
function c81012030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81012030+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81012030.condition)
	e1:SetCost(c81012030.cost)
	e1:SetTarget(c81012030.target)
	e1:SetOperation(c81012030.activate)
	c:RegisterEffect(e1)
end
function c81012030.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c81012030.costfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and (c:IsControler(tp) or c:IsFaceup())
end
function c81012030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c81012030.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c81012030.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c81012030.thfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c81012030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81012030.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c81012030.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local sg=Duel.GetMatchingGroup(c81012030.thfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
