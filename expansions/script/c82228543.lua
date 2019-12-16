function c82228543.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228543,0))  
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMING_DRAW+TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE)	
	e1:SetTarget(c82228543.target)  
	e1:SetOperation(c82228543.activate)  
	c:RegisterEffect(e1) 
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228543,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82228543)
	e2:SetCondition(c82228543.thcon)  
	e2:SetTarget(c82228543.thtg)  
	e2:SetOperation(c82228543.thop)  
	c:RegisterEffect(e2)  
end  
c82228543.card_code_list={82228540}
function c82228543.filter(c)  
	return c:IsCode(82228540) and c:IsFaceup()  
end  
function c82228543.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82228543.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82228543.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c82228543.filter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c82228543.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_IMMUNE_EFFECT)  
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
		e3:SetRange(LOCATION_MZONE)  
		e3:SetValue(c82228543.efilter)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		e3:SetOwnerPlayer(tp)  
		tc:RegisterEffect(e3)  
	end  
end  
function c82228543.efilter(e,re)  
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()  
end  
function c82228543.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function c82228543.thfilter(c)  
	return aux.IsCodeListed(c,82228540) and not c:IsCode(82228543) and c:IsAbleToHand() and c:IsType(TYPE_SPELL) 
end  
function c82228543.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228543.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228543.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228543.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  