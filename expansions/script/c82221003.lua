function c82221003.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--Special Summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221003,0))  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,82221003)
	e1:SetCondition(c82221003.thcon)  
	e1:SetTarget(c82221003.thtg)  
	e1:SetOperation(c82221003.thop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c82221003.thcon2)
	c:RegisterEffect(e2) 
	--to hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221003,1))  
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND)	
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,82231003)  
	e3:SetTarget(c82221003.addtg)  
	e3:SetOperation(c82221003.addop)  
	c:RegisterEffect(e3)  
end  
function c82221003.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0  
end  
function c82221003.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA)
end  
function c82221003.thfilter(c)  
	return c:IsPosition(POS_FACEUP) and c:IsAbleToHand()
end  
function c82221003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end  
	if chk==0 then return Duel.IsExistingTarget(c82221003.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)  
	local g=Duel.SelectTarget(tp,c82221003.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function c82221003.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
function c82221003.addfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x292) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()  
end  
function c82221003.addtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221003.addfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)  
end  
function c82221003.addop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221003.addfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  