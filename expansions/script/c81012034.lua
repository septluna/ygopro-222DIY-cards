--中华风味·理子
function c81012034.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81012034)
	e1:SetTarget(c81012034.sptg)
	e1:SetOperation(c81012034.spop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81012934)
	e2:SetCost(c81012034.pencost)
	e2:SetTarget(c81012034.pentg)
	e2:SetOperation(c81012034.penop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(81012034,ACTIVITY_SPSUMMON,c81012034.counterfilter)
end
function c81012034.counterfilter(c)
	return c:IsRace(RACE_PYRO)
end
function c81012034.filter(c,e,tp)
	return c:IsRace(RACE_PYRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81012034.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81012034.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c81012034.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81012034.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81012034.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81012034.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81012034.splimit(e,c)
	return not c:IsRace(RACE_PYRO)
end
function c81012034.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81012034,tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81012034.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c81012034.penfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c81012034.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81012034.penfilter,tp,LOCATION_DECK,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c81012034.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81012034.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
