--死魂收割者
function c33330087.initial_effect(c)
	 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33330087)
	e1:SetCost(c33330087.cost)
	e1:SetOperation(c33330087.operation)
	c:RegisterEffect(e1)
end
function c33330087.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33330087.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   --force mzone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c33330087.frcval)
	Duel.RegisterEffect(e1,tp)
end
function c33330087.frcval(e,c,fp,rp,r)
	return 0x60
end