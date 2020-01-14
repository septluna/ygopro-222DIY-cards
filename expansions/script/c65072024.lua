--渺奏迷景曲-歌独予汝
function c65072024.initial_effect(c)
	aux.AddCodeList(c,65072016)
	--activate
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072024+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65072024.target)
	e1:SetOperation(c65072024.activate)
	c:RegisterEffect(e1)
end
function c65072024.filter(c)
	return aux.IsCodeListed(c,65072016) and c:IsAbleToDeck()
end
function c65072024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local num=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,65071999)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c65072024.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c65072024.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65072024.filter,tp,LOCATION_REMOVED,0,1,num,nil)
	e:SetLabel(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65072024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local num=e:GetLabel()
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=num then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==num then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end