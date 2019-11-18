--晴光妖精
function c65040042.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3)
	c:EnableReviveLimit()
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65040042,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65040042)
	e3:SetCost(c65040042.drcost)
	e3:SetTarget(c65040042.drtg)
	e3:SetOperation(c65040042.drop)
	c:RegisterEffect(e3)
end
function c65040042.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65040042.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	local xnum=e:GetHandler():GetOverlayCount()
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,xnum)
end
function c65040042.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		local xnum=e:GetHandler():GetOverlayCount()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,xnum,xnum,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end
end