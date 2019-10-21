--爆风降临
function c40008736.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e1)  
	e1:SetDescription(aux.Stringid(40008736,0))
	e1:SetCountLimit(1,40008736)
	e1:SetTarget(c40008736.target)
	e1:SetOperation(c40008736.operation)
end
function c40008736.filter1(c)
	return (c:IsCode(40008729) or c:IsCode(40008749)) and c:IsFaceup()
end
function c40008736.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	if Duel.IsExistingMatchingCard(c40008736.filter1,tp,LOCATION_ONFIELD,0,1,nil) then
	Duel.SetChainLimit(c40008736.chlimit)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40008736.chlimit(e,ep,tp)
	return tp==ep
end
function c40008736.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(40008736,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end