function c82221000.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--Special Summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221000,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,82221000)
	e1:SetCondition(c82221000.thcon)  
	e1:SetTarget(c82221000.thtg)  
	e1:SetOperation(c82221000.thop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c82221000.thcon2)
	c:RegisterEffect(e2) 
	--disable attack  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221000,1))  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,82231000)  
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e3:SetCondition(c82221000.atkcon)
	e3:SetOperation(c82221000.atkop)  
	c:RegisterEffect(e3)  
end  
function c82221000.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0  
end  
function c82221000.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA)
end  
function c82221000.thfilter(c)  
	return c:IsSetCard(0x292) and c:IsType(TYPE_MONSTER) and not c:IsCode(82221000) and c:IsAbleToHand()
end  
function c82221000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221000.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221000.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221000.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82221000.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local at=Duel.GetAttacker()  
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil  
end  
function c82221000.atkop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateAttack()  
end  