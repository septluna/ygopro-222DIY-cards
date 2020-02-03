--Defiance
function c26807037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c26807037.condition)
	e1:SetTarget(c26807037.target)
	e1:SetOperation(c26807037.operation)
	c:RegisterEffect(e1)
end
function c26807037.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c26807037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c26807037.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c26807037.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c26807037.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
