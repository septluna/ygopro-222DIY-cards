--谨贺新年·爱米莉
function c81012064.initial_effect(c)
	--reflect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c81012064.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81012064)
	e2:SetCondition(c81012064.spcon)
	e2:SetTarget(c81012064.sptg)
	e2:SetOperation(c81012064.spop)
	c:RegisterEffect(e2)
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c81012064.actcon)
	c:RegisterEffect(e3)
end
function c81012064.nfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_PYRO)
end
function c81012064.actcon(e)
	return Duel.IsExistingMatchingCard(c81012064.nfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81012064.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c81012064.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c81012064.sucop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(c81012064.cedop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
end
function c81012064.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_RITUAL) and ep==tp then
		Duel.SetChainLimit(c81012064.chainlm)
	end
end
function c81012064.chainlm(e,rp,tp)
	return tp==rp
end
function c81012064.sucfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:GetSummonPlayer()==tp
end
function c81012064.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c81012064.sucfilter,1,nil,tp) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c81012064.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c81012064.chainlm)
	end
end
function c81012064.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_RITUAL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c81012064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81012064,0,0x11,1550,1050,8,RACE_PYRO,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81012064.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,81012064,0,0x11,1550,1050,8,RACE_PYRO,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c81012064.splimit)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		c:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c81012064.splimit(e,c)
	return not c:IsRace(RACE_PYRO)
end
