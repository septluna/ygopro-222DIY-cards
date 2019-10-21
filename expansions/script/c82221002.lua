function c82221002.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--Special Summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221002,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,82221002)
	e1:SetCondition(c82221002.thcon)  
	e1:SetTarget(c82221002.thtg)  
	e1:SetOperation(c82221002.thop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c82221002.thcon2)
	c:RegisterEffect(e2) 
	--pierce  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221002,2))  
	e3:SetType(EFFECT_TYPE_IGNITION)   
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,82231002)  
	e3:SetTarget(c82221002.ptg)  
	e3:SetOperation(c82221002.pop)  
	c:RegisterEffect(e3)  
end  
function c82221002.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0  
end  
function c82221002.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA)
end  
function c82221002.thfilter(c)  
	return c:IsSetCard(0x292) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end  
function c82221002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221002.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221002.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221002.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82221002.pfilter(c)  
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_PIERCE) 
end  
function c82221002.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end  
	if chk==0 then return Duel.IsExistingTarget(c82221002.pfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c82221002.pfilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c82221002.pop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_PIERCE)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end  