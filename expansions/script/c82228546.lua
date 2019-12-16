function c82228546.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(82228546,0))   
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(c82228546.cost)  
	e1:SetTarget(c82228546.target)  
	e1:SetOperation(c82228546.activate)  
	c:RegisterEffect(e1)  
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228546,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82228546)
	e2:SetCondition(c82228546.thcon)  
	e2:SetTarget(c82228546.thtg)  
	e2:SetOperation(c82228546.thop)  
	c:RegisterEffect(e2)  
end  
c82228546.card_code_list={82228540}
function c82228546.filter(c)  
	return aux.IsCodeListed(c,82228540) and c:IsType(TYPE_SPELL) and c:IsDiscardable()  
end  
function c82228546.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228546.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.DiscardHand(tp,c82228546.filter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())  
end  
function c82228546.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(2)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)  
end  
function c82228546.activate(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
function c82228546.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function c82228546.thfilter(c)  
	return aux.IsCodeListed(c,82228540) and not c:IsCode(82228546) and c:IsAbleToHand()  and c:IsType(TYPE_SPELL)
end  
function c82228546.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228546.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228546.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228546.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  