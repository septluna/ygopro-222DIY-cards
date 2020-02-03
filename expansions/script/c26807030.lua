--Words of GRACE
function c26807030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26807030+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c26807030.target)
	e1:SetOperation(c26807030.activate)
	c:RegisterEffect(e1)
end
function c26807030.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function c26807030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26807030.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3)
		and g:GetClassCount(Card.GetCode)>=9 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,9,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c26807030.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26807030.filter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetCode)<9 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,9,9)
	aux.GCheckAdditional=nil
	local cg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==9 then
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
