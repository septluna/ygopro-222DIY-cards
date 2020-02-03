--VESTIGE
function c81012078.initial_effect(c)
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c81012078.filter,nil,nil,c81012078.matfilter)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,81012078)
	e1:SetCondition(aux.exccon)
	e1:SetCost(aux.bfgcost)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c81012078.reptg)
	e2:SetValue(c81012078.repval)
	e2:SetOperation(c81012078.repop)
	c:RegisterEffect(e2)
end
function c81012078.filter(c,e,tp,chk)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and (not chk or c~=e:GetHandler())
end
function c81012078.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c81012078.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c81012078.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c81012078.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81012078.repval(e,c)
	return c81012078.repfilter(c,e:GetHandlerPlayer())
end
function c81012078.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD+REASON_REPLACE)
end
