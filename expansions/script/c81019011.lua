--Sentimental Sequence
function c81019011.initial_effect(c)
	aux.AddRitualProcGreater(c,c81019011.ritual_filter,nil,nil,c81019011.mfilter)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81019011)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81019011.thtg)
	e2:SetOperation(c81019011.thop)
	c:RegisterEffect(e2)
end
function c81019011.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81019011.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c81019011.thfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c81019011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81019011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81019011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81019011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
