--蛙狩『蛙以口鸣，方致蛇祸』
c11200048.card_code_list={11200029}
function c11200048.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c11200048.target)
	e1:SetOperation(c11200048.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200948)
	e2:SetCost(c11200048.spcost)
	e2:SetTarget(c11200048.destg)
	e2:SetOperation(c11200048.desop)
	c:RegisterEffect(e2)
end
function c11200048.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1620,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1620,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1620,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x1620,1)
end
function c11200048.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		tc:AddCounter(0x1620,1)
		local e3_1_1=Effect.CreateEffect(c)
		e3_1_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_1_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3_1_1:SetCondition(c11200048.disable)
		e3_1_1:SetValue(1)
		e3_1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_1_1)
		local e3_1_2=e3_1_1:Clone()
		e3_1_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e3_1_2)
		local e3_1_3=e3_1_1:Clone()
		e3_1_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e3_1_3)
		local e3_1_4=e3_1_1:Clone()
		e3_1_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e3_1_4)
		local e3_1_5=e3_1_1:Clone()
		e3_1_5:SetCode(EFFECT_UNRELEASABLE_SUM)
		tc:RegisterEffect(e3_1_5)
		local e3_1_6=e3_1_1:Clone()
		e3_1_6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e3_1_6)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c11200048.disable(e)
	return e:GetHandler():GetCounter(0x1620)>0
end
function c11200048.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c11200048.desfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,11200029)
end
function c11200048.dfsfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1620)>0
end
function c11200048.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c11200048.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c11200048.dfsfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c11200048.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c11200048.dfsfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c11200048.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
