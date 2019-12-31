--晴朗海滨的高远天空
function c65030013.initial_effect(c)
	aux.AddCodeList(c,65030020)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,65030013)
	e1:SetCondition(c65030013.condition)
	e1:SetTarget(c65030013.target)
	e1:SetOperation(c65030013.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c65030013.atkcon)
	e2:SetCost(c65030013.atkcost)
	e2:SetOperation(c65030013.atkop)
	c:RegisterEffect(e2)
end
function c65030013.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetAttacker()
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE and b and b:IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and not Duel.IsDamageCalculated()
end
function c65030013.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(65030013)==0 end
	e:GetHandler():RegisterFlagEffect(65030013,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c65030013.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if tc and not tc:IsImmuneToEffect(e) then
		local preatk=tc:GetAttack()
		if preatk<=1400 then
			local dam=1400-preatk
			Duel.SendtoGrave(tc,REASON_EFFECT)
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c65030013.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 
end
function c65030013.tffilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and aux.IsCodeListed(c,65030020) and c:IsFaceup()
end
function c65030013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030013.tffilter,tp,LOCATION_SZONE,0,1,nil,tp) end
end
function c65030013.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65030013.tffilter,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		--indes
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetValue(c65030013.valcon)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c65030013.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 
end
