--甜花无惧
function c81000008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81000008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81000008.cost)
	e1:SetTarget(c81000008.target)
	e1:SetOperation(c81000008.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(81000008,ACTIVITY_SUMMON,c81000008.counterfilter)
	Duel.AddCustomActivityCounter(81000008,ACTIVITY_SPSUMMON,c81000008.counterfilter)
	Duel.AddCustomActivityCounter(81000008,ACTIVITY_FLIPSUMMON,c81000008.counterfilter)
	Duel.AddCustomActivityCounter(81000008,ACTIVITY_CHAIN,c81000008.chainfilter)
end
function c81000008.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function c81000008.counterfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function c81000008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81000008,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(81000008,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(81000008,tp,ACTIVITY_FLIPSUMMON)==0 and Duel.GetCustomActivityCount(81000008,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81000008.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c81000008.aclimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c81000008.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end
function c81000008.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c81000008.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c81000008.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c81000008.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and not c:IsType(TYPE_EFFECT) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c81000008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c81000008.filter0,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		local res=Duel.IsExistingMatchingCard(c81000008.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c81000008.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81000008.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c81000008.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c81000008.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c81000008.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local c=e:GetHandler()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_CODE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetValue(81000000)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c81000008.sactlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e4:SetRange(LOCATION_MZONE)
		e4:SetAbsoluteRange(tp,1,0)
		e4:SetTarget(c81000008.ssplimit)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4,true)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_SUMMON)
		tc:RegisterEffect(e5,true)
	end
end
function c81000008.ssplimit(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c81000008.sactlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER)
end
