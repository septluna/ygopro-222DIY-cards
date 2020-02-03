--ReflectionS
function c26807003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26807003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26807003.condition)
	e1:SetTarget(c26807003.target)
	e1:SetOperation(c26807003.activate)
	c:RegisterEffect(e1)
end
function c26807003.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg:GetCount()<=0 and Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c26807003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c26807003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c26807003.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c26807003.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
