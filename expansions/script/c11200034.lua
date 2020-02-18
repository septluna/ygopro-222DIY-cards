--赤口的土著神
function c11200034.initial_effect(c)
	aux.AddCodeList(c,11200029)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11200029,aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),3,true,true)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(11200029)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200034)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c11200034.ctcon)
	e1:SetTarget(c11200034.cttg)
	e1:SetOperation(c11200034.ctop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11200934)
	e3:SetCondition(c11200034.spcon)
	e3:SetTarget(c11200034.sptg)
	e3:SetOperation(c11200034.spop)
	c:RegisterEffect(e3)
end
function c11200034.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c11200034.ctfilter(c)
	return c:IsFaceup() and c:IsCode(11200029)
end
function c11200034.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200034.ctfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1620,1) end
end
function c11200034.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c11200034.ctfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1620,1)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1620,1)
		local e3_1_1=Effect.CreateEffect(c)
		e3_1_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_1_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3_1_1:SetCondition(c11200034.disable)
		e3_1_1:SetValue(1)
		e3_1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_1_1)
		local e3_1_2=e3_1_1:Clone()
		e3_1_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e3_1_2)
		local e3_1_3=e3_1_1:Clone()
		e3_1_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e3_1_3)
		local e3_1_4=e3_1_1:Clone()
		e3_1_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e3_1_4)
		local e3_1_5=e3_1_1:Clone()
		e3_1_5:SetCode(EFFECT_UNRELEASABLE_SUM)
		tc:RegisterEffect(e3_1_5)
		local e3_1_6=e3_1_1:Clone()
		e3_1_6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e3_1_6)
	end
	if Duel.GetCounter(0,1,1,0x1620)>=3 and Duel.SelectYesNo(tp,aux.Stringid(11200034,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c11200034.disable(e)
	return e:GetHandler():GetCounter(0x1620)>0
end
function c11200034.spfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1620)>0
end
function c11200034.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11200034.spfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c11200034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11200034.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
