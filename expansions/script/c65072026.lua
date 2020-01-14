--渺奏迷景曲-飘碎如沫
function c65072026.initial_effect(c)
	aux.AddCodeList(c,65072016)
	 --activate
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65072026+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65072026.condition)
	e1:SetCost(c65072026.cost)
	e1:SetTarget(c65072026.target)
	e1:SetOperation(c65072026.operation)
	c:RegisterEffect(e1)
end
function c65072026.confil(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0xcda7)
end
function c65072026.costfil(c)
	return aux.IsCodeListed(c,65072016) and c:IsAbleToGraveAsCost()
end
function c65072026.tgfil(c,e)
	return c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c65072026.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65072026.confil,1,nil)
end
function c65072026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c65072026.confil,nil)
	local gn=g:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c65072026.costfil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil,e) end
	local num=Duel.GetMatchingGroup(c65072026.tgfil,tp,0,LOCATION_ONFIELD,nil)
	if gn>num then gn=num end
	local tgg=Duel.SelectMatchingCard(tp,c65072026.costfil,tp,LOCATION_DECK,0,1,gn,nil)
	Duel.SendtoGrave(tgg,REASON_COST)
	e:SetLabel(tgg:GetCount())
end
function c65072026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=e:GetLabel()
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,num,num,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,num,0,0)
end
function c65072026.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end