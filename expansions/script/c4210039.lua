--リ猫耳天堂-快乐摸鱼
function c4210039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c4210039.condition)
	e1:SetTarget(c4210039.target)
	e1:SetOperation(c4210039.activate)
	c:RegisterEffect(e1)
end
function c4210039.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c4210039.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa2f)
end
function c4210039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210039.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c4210039.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0xa2f) and not c:IsImmuneToEffect(e)
end
function c4210039.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c4210039.filter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(4210039,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		tc=sg:GetNext()
	end
end