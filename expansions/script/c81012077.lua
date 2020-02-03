--碎花纷飞·爱米莉
function c81012077.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,81012077)
	e2:SetCondition(c81012077.tncon)
	e2:SetOperation(c81012077.tnop)
	c:RegisterEffect(e2)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c81012077.descost)
	e5:SetTarget(c81012077.destg)
	e5:SetOperation(c81012077.desop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(81012077,ACTIVITY_SPSUMMON,c81012077.counterfilter)
end
function c81012077.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c81012077.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c81012077.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c81012077.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81012077,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c81012077.splimit)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c81012077.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c81012077.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c81012077.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c81012077.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81012077.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81012077.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81012077.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
