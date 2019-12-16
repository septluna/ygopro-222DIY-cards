function c82228542.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(82228542,0)) 
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_TOGRAVE+TIMING_END_PHASE)
	e1:SetCondition(c82228542.condition)
	e1:SetCost(c82228542.cost)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c82228542.target)  
	e1:SetOperation(c82228542.activate)  
	c:RegisterEffect(e1)
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228542,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82228542)
	e2:SetCondition(c82228542.thcon)  
	e2:SetTarget(c82228542.thtg)  
	e2:SetOperation(c82228542.thop)  
	c:RegisterEffect(e2)  
end  
c82228542.card_code_list={82228540}
function c82228542.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,82228540) 
end  
function c82228542.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end  
	Duel.DiscardDeck(tp,1,REASON_COST)  
end  
function c82228542.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function c82228542.activate(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)  
	end  
end  
function c82228542.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function c82228542.thfilter(c)  
	return aux.IsCodeListed(c,82228540) and not c:IsCode(82228542) and c:IsAbleToHand() and c:IsType(TYPE_SPELL) 
end  
function c82228542.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228542.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228542.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228542.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  