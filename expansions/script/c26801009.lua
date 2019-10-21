--樱木真乃的小礼物
function c26801009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26801009)
	e1:SetCost(c26801009.cost)
	e1:SetTarget(c26801009.target)
	e1:SetOperation(c26801009.activate)
	c:RegisterEffect(e1)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,26801909)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c26801009.tdtg)
	e3:SetOperation(c26801009.tdop)
	c:RegisterEffect(e3)
end
function c26801009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c26801009.tgfilter(c)
	return c:IsLevelBelow(6) and (c:IsType(TYPE_FUSION) or bit.band(c:GetType(),0x81)==0x81) and c:IsAbleToGrave()
end
function c26801009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26801009.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c26801009.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26801009.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,3,3,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c26801009.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x602) and c:IsAbleToDeck() and not c:IsCode(26801009)
end
function c26801009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c26801009.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c26801009.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler())
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26801009.tdfilter,tp,LOCATION_REMOVED,0,1,5,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c26801009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
