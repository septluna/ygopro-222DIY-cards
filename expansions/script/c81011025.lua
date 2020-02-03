--宫水静香·下午茶
function c81011025.initial_effect(c)
	--turn 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,81011025)
	e1:SetCost(c81011025.poscost)
	e1:SetTarget(c81011025.postg)
	e1:SetOperation(c81011025.posop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81011925)
	e2:SetTarget(c81011025.cttg)
	e2:SetOperation(c81011025.ctop)
	c:RegisterEffect(e2)
end
function c81011025.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c81011025.posfilter(c)
	return c:IsCanChangePosition()
end
function c81011025.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81011025.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81011025.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c81011025.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c81011025.filter2(c)
	return c:IsAbleToDeck()
end
function c81011025.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			if tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_DARK) then
			local dg=Duel.GetMatchingGroup(c81011025.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81011025,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
		end
	end
end
function c81011025.ctfilter1(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c81011025.ctfilter2(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsAttack(500) and c:IsDefense(1500) and c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c81011025.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c81011025.ctfilter1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c81011025.ctfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c81011025.ctfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c81011025.ctfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c81011025.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
		Duel.SwapControl(a,b)
	end
end
