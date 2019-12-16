function c82228547.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82228547+EFFECT_COUNT_CODE_OATH)   
	e1:SetOperation(c82228547.activate)  
	c:RegisterEffect(e1)
	--atk  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,82228540))  
	e2:SetValue(400)  
	c:RegisterEffect(e2) 
	--draw  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82228547,0))  
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetCountLimit(1,82208547)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c82228547.drtg)  
	e3:SetOperation(c82228547.drop)  
	c:RegisterEffect(e3)  
	--to hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(82228547,1))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_GRAVE) 
	e4:SetCountLimit(1,82218547) 
	e4:SetCondition(aux.exccon)  
	e4:SetCost(c82228547.thcost)  
	e4:SetTarget(c82228547.thtg)  
	e4:SetOperation(c82228547.thop)  
	c:RegisterEffect(e4)  
end   
c82228547.card_code_list={82228540}
function c82228547.thfilter1(c)  
	return c:IsCode(82228540) and c:IsAbleToHand()
end  
function c82228547.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(c82228547.thfilter1,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(82228547,2)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end 

function c82228547.drfilter(c,e)  
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)  
end  
function c82228547.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	local g=Duel.GetMatchingGroup(c82228547.drfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)  
	if chk==0 then return g:GetCount()>2 and Duel.IsPlayerCanDraw(tp,1) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local sg=g:Select(tp,3,3,nil) 
	Duel.SetTargetCard(sg)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function c82228547.drop(e,tp,eg,ep,ev,re,r,rp)  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end  
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)  
	local g=Duel.GetOperatedGroup()  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end  
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)  
	if ct==3 then  
		Duel.BreakEffect()  
		Duel.Draw(tp,1,REASON_EFFECT)  
	end  
end  
function c82228547.costfilter(c,e)  
	return c:IsType(TYPE_SPELL) and c:IsDiscardable(REASON_COST+REASON_DISCARD)  
end  
function c82228547.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228547.costfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,c82228547.costfilter,1,1,REASON_COST+REASON_DISCARD)  
end  
function c82228547.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToHand() end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
end  
function c82228547.thop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsRelateToEffect(e) then  
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)  
	end  
end  