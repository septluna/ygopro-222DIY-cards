--土著神的顶点
c11200034.card_code_list={11200029}
function c11200034.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,11200029,3,false,false)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(11200029)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11200034)
	e1:SetTarget(c11200034.eqtg)
	e1:SetOperation(c11200034.eqop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200934)
	e2:SetCondition(c11200034.setcon1)
	e2:SetTarget(c11200034.sptg)
	e2:SetOperation(c11200034.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c11200034.setcon2)
	c:RegisterEffect(e3)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c11200034.splimit)
	c:RegisterEffect(e4)
end
function c11200034.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end
function c11200034.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200034.ctfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1620,1) end
end
function c11200034.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c11200034.ctfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(c11200034.sfilter,tp,0,LOCATION_MZONE,nil)
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
end
function c11200034.disable(e)
	return e:GetHandler():GetCounter(0x1620)>0
end
function c11200034.cfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1620)>0
end
function c11200034.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsExistingMatchingCard(c11200034.cfilter,tp,0,LOCATION_MZONE,1,nil) and not Duel.IsExistingMatchingCard(c11200034.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c11200034.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11200034.cfilter,tp,0,LOCATION_MZONE,1,nil) and not Duel.IsExistingMatchingCard(c11200034.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11200034.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c11200034.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c11200034.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_AQUA) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c11200034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c11200034.filter0,tp,LOCATION_GRAVE,0,nil)
		local res=Duel.GetLocationCountFromEx(tp)>0
			and Duel.IsExistingMatchingCard(c11200034.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11200034.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,LOCATION_GRAVE)
end
function c11200034.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c11200034.filter1,tp,LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c11200034.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11200034.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if (Duel.GetLocationCountFromEx(tp)>0 and sg1:GetCount()>0) or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c11200034.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
