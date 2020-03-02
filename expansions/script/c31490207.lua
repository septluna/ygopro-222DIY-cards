local m=31490207
local cm=_G["c"..m]
cm.name="苍燧烽猛犸 灼牙"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCost(cm.cost)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.actcon)
	e1:SetOperation(cm.actop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.actfilter(c,e,tp)
	return c:IsLevel(3) and c:IsSetCard(0x5310) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	tc:RegisterEffect(e2)
	tc:AddCounter(0x5310,1)
	Duel.BreakEffect()
	local ffcount=Duel.GetCounter(tp,LOCATION_SZONE,0,0x5310)
	local field=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if field then
		ffcount=ffcount-field:GetCounter(0x5310)
	end
	if ffcount>=4 and Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(31490207,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Activate(e:GetLabelObject())
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_PYRO)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsSetCard(0x5310) and tc:IsAbleToGrave()
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.tffilter(c)
	return c:IsSetCard(0x5310) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			g:GetFirst():AddCounter(0x5310,1)
		end		
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local mc=g:GetFirst()
			Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
			mc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
			mc:RegisterEffect(e2)
			mc:AddCounter(0x5310,1)
		end
	end
end