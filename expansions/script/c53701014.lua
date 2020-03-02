--惧轮午后小憩
function c53701014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c53701014.target)
	e1:SetOperation(c53701014.activate)
	c:RegisterEffect(e1)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53701014,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,53701014)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c53701014.tdtg)
	e4:SetOperation(c53701014.tdop)
	c:RegisterEffect(e4)
end
function c53701014.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x530) and c:IsAbleToHand()
end
function c53701014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53701014.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c53701014.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c53701014.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   e1:SetCode(EVENT_CHAIN_SOLVING)
	   e1:SetReset(RESET_CHAIN)
	   e1:SetOperation(c53701014.disop1)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c53701014.disop1(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetLocation()==LOCATION_GRAVE 
	 then
		Duel.NegateEffect(ev)
	end
end
function c53701014.tdfilter(c)
	return c:IsSetCard(0x530) and c:IsAbleToDeck()
end
function c53701014.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c53701014.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53701014.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c53701014.tdfilter,tp,LOCATION_GRAVE,0,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c53701014.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
