function c82221006.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221006,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(c82221006.target)  
	e1:SetOperation(c82221006.activate)  
	c:RegisterEffect(e1)
end  
function c82221006.filter1(c,e)  
	return not c:IsImmuneToEffect(e)  
end  
function c82221006.filter2(c,e,tp,m,f,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_WINDBEAST) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)  
end  
function c82221006.filter3(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsPosition(POS_FACEUP) and c:IsCanBeFusionMaterial()
end   
function c82221006.filter4(c,e)  
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end  
function c82221006.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c82221006.filter3,tp,LOCATION_EXTRA,0,nil)
		local mg3=Duel.GetMatchingGroup(c82221006.filter4,tp,LOCATION_PZONE,0,nil,e)
		mg1:Merge(mg2)
		mg1:Merge(mg3)
		local res=Duel.IsExistingMatchingCard(c82221006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg4=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(c82221006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,mf,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function c82221006.activate(e,tp,eg,ep,ev,re,r,rp)  
	local chkf=tp  
	local mg1=Duel.GetFusionMaterial(tp):Filter(c82221006.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c82221006.filter3,tp,LOCATION_EXTRA,0,nil)
	local mg3=Duel.GetMatchingGroup(c82221006.filter4,tp,LOCATION_PZONE,0,nil,e)
	mg1:Merge(mg2)
	mg1:Merge(mg3) 
	local sg1=Duel.GetMatchingGroup(c82221006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)  
	local mg4=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg4=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(c82221006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg4,mf,chkf)  
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg4,nil,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure()  
	end  
end  