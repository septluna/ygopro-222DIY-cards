--水晶之光
c26809029.card_code_list={81010004}
function c26809029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26809029+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26809029.target)
	e1:SetOperation(c26809029.activate)
	c:RegisterEffect(e1)
end
function c26809029.cfilter(c)
	return c:IsCode(81010005)
end
function c26809029.dfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c26809029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c26809029.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26809029.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c26809029.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c26809029.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,c26809029.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	if Duel.IsEnvironment(81010004) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c26809029.chainlm)
	end
end
function c26809029.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c26809029.chainlm(e,rp,tp)
	return tp==rp
end
