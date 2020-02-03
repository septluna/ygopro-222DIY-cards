--废墟之下的深思
function c81010046.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010046+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c81010046.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81010946)
	e2:SetCondition(c81010046.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81010046.negtg)
	e2:SetOperation(c81010046.negop)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c81010046.reptg)
	e3:SetValue(c81010046.repval)
	e3:SetOperation(c81010046.repop)
	c:RegisterEffect(e3)
end
function c81010046.filter(c,tp)
	return c:IsCode(81010011,81010016,81040035) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c81010046.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c81010046.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81010046,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81010046.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c81010046.repfilter(c,tp)
	return c:IsLocation(LOCATION_FZONE) and c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c81010046.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c81010046.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81010046.repval(e,c)
	return c81010046.repfilter(c,e:GetHandlerPlayer())
end
function c81010046.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c81010046.psfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c81010046.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c81010046.psfilter,tp,LOCATION_MZONE,0,1,nil)
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c81010046.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c81010046.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
