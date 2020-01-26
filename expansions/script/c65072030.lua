--渺奏迷景曲-空灵之声
function c65072030.initial_effect(c)
	aux.AddCodeList(c,65072016)
	--negate
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,65072030+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65072030.condition)
	e1:SetTarget(c65072030.target)
	e1:SetOperation(c65072030.operation)
	c:RegisterEffect(e1)
end
function c65072030.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_FIELD) and Duel.IsChainNegatable(ev) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsLocation(LOCATION_FZONE)
end
function c65072030.thfil(c)
	return aux.IsCodeListed(c,65072016) and c:IsAbleToHand()
end
function c65072030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072030.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65072030,0))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65072030.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetCode(EFFECT_CANNOT_TRIGGER)
		e0:SetRange(LOCATION_FZONE)
		e0:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		if Duel.IsExistingMatchingCard(c65072030.thfil,tp,LOCATION_DECK,0,1,nil) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c65072030.thfil,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end