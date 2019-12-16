function c82228545.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetDescription(aux.Stringid(82228545,0))  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetTarget(c82228545.target)  
	e1:SetOperation(c82228545.activate)  
	c:RegisterEffect(e1)  
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228545,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82228545)
	e2:SetCondition(c82228545.thcon)  
	e2:SetTarget(c82228545.thtg)  
	e2:SetOperation(c82228545.thop)  
	c:RegisterEffect(e2)  
end  
c82228545.card_code_list={82228540}
function c82228545.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)   
end  
function c82228545.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CANNOT_TRIGGER)  
		e1:SetValue(RESET_TURN_SET)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE)  
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e2)  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_DISABLE_EFFECT)  
		e3:SetValue(RESET_TURN_SET)  
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e3)   
	end  
end  
function c82228545.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function c82228545.thfilter(c)  
	return aux.IsCodeListed(c,82228540) and not c:IsCode(82228545) and c:IsAbleToHand() and c:IsType(TYPE_SPELL) 
end  
function c82228545.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228545.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228545.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228545.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  