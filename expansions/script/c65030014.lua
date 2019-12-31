--残雪与尽头的落日
function c65030014.initial_effect(c)
	aux.AddCodeList(c,65030020)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,65030014)
	e1:SetCondition(c65030014.condition)
	e1:SetTarget(c65030014.target)
	e1:SetOperation(c65030014.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c65030014.atkcon)
	e2:SetCost(c65030014.atkcost)
	e2:SetOperation(c65030014.atkop)
	c:RegisterEffect(e2)
end
function c65030014.atkcon(e,tp,eg,ep,ev,re,r,rp)
	  local b=Duel.GetAttacker()
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE and b and b:IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and not Duel.IsDamageCalculated()
end
function c65030014.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(65030014)==0 end
	e:GetHandler():RegisterFlagEffect(65030014,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c65030014.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if tc and not tc:IsImmuneToEffect(e) then
		local preatk=tc:GetAttack()
		if preatk<=1200 then
			local dam=1200-preatk
			Duel.SendtoGrave(tc,REASON_EFFECT)
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c65030014.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 
end
function c65030014.tffilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and aux.IsCodeListed(c,65030020) 
end
function c65030014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030014.tffilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65030014.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65030014.tffilter,tp,LOCATION_DECK,0,1,1,nil) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

