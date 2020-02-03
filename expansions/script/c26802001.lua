--童话故事会
function c26802001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26802001+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26802001.condition)
	e1:SetTarget(c26802001.target)
	e1:SetOperation(c26802001.operation)
	c:RegisterEffect(e1)
end
function c26802001.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return ct<3
end
function c26802001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=7-Duel.GetMatchingGroupCount(nil,1-tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(1-tp,ct) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct)
end
function c26802001.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=7-Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
