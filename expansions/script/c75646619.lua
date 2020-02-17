--极光矩阵 菲米莉丝
function c75646619.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c75646619.immcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646619,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,75646619)
	e3:SetCost(c75646619.recost)
	e3:SetTarget(c75646619.retg)
	e3:SetOperation(c75646619.reop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75646619,2))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,5646619)
	e4:SetCondition(c75646619.actcon)
	e4:SetTarget(c75646619.acttg)
	e4:SetOperation(c75646619.actop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c75646619.immcon(e)
	return e:GetHandler():GetColumnGroupCount()==0
end
function c75646619.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsDiscardable() end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp)
end
function c75646619.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646619.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c75646619.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,e:GetHandler()):GetFirst()
	local te=tc:IsHasEffect(75646628,tp)
	if te then
		e:SetValue(1)
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		if tc:IsCode(75646600) then e:SetValue(1) end
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c75646619.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if (e:GetValue()==1 or Duel.GetFlagEffect(tp,75646600)>0) then
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end
end
function c75646619.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and (e:GetValue()==1 or Duel.GetFlagEffect(tp,75646600)>0) then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c75646619.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x2c5) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x2c5) and c:IsPreviousPosition(POS_FACEUP)
			and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c75646619.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646619.cfilter,1,nil,e:GetHandler())
end
function c75646619.actfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c75646619.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646619.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c75646619.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11881272,2))
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,75646619,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,c75646619.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,75646619)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,75646619,RESET_CHAIN,0,1) end
		local b=te:IsActivatable(tp,true,true)
		if b then
			Duel.ResetFlagEffect(tp,75646619)
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end