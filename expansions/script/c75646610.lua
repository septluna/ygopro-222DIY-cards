--得力助手
function c75646610.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,75646610+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c75646610.cost)
	e1:SetTarget(c75646610.target)
	e1:SetOperation(c75646610.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SUMMON_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75646610+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c75646610.con)
	e2:SetTarget(c75646610.tg)
	e2:SetOperation(c75646610.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_NEGATED)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetCondition(c75646610.ngcon)
	c:RegisterEffect(e4)
end
function c75646610.cfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsDiscardable() end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp)
end
function c75646610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646610.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c75646610.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,e:GetHandler()):GetFirst()
	local te=tc:IsHasEffect(75646628,tp)
	if te then
		e:SetLabel(1)
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		if tc:IsCode(75646600) then e:SetLabel(1) end
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c75646610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	if (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)>0) then
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function c75646610.activate(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)>0 and (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)>0) then
			Duel.NegateActivation(ev)
		end
	end
end
function c75646610.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x2c5)
end
function c75646610.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return aux.IsCodeListed(rc,75646600)
end
function c75646610.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c75646610.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

