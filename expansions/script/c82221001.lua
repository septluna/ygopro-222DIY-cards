function c82221001.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--Special Summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221001,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,82221001)
	e1:SetCondition(c82221001.thcon)  
	e1:SetTarget(c82221001.thtg)  
	e1:SetOperation(c82221001.thop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c82221001.thcon2)
	c:RegisterEffect(e2)
	--atk down 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221001,1))  
	e3:SetCategory(CATEGORY_ATKFCHANGE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,82231001)  
	e3:SetTarget(c82221001.deftg)  
	e3:SetOperation(c82221001.defop)  
	c:RegisterEffect(e3)  
end  
function c82221001.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0  
end  
function c82221001.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA)
end  
function c82221001.thfilter(c)  
	return c:IsCode(82221001) and c:IsAbleToHand()
end  
function c82221001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221001.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_DECK)  
end  
function c82221001.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221001.thfilter,tp,LOCATION_DECK,0,1,2,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82221001.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.nzatk(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)  
end  
function c82221001.defop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(-500)   
		tc:RegisterEffect(e1)  
	end  
end  