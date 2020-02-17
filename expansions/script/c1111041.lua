---花开幻想-
local m=1111041
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1111041.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111041+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1111041.tg1)
	e1:SetOperation(c1111041.op1)
	c:RegisterEffect(e1)
--
end
--
function c1111041.tfilter1(c)
	return muxu.check_set_Urban(c)
end
function c1111041.tfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function c1111041.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local el={}
		local mg=Duel.GetMatchingGroup(c1111041.tfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		for tc in aux.Next(mg) do
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_FUSION_SUBSTITUTE)
			tc:RegisterEffect(e1_1)
			table.insert(el,e1_1)
		end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c1111041.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c1111041.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		for _,e in ipairs(el) do
			e:Reset()
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c1111041.ofilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c1111041.op1(e,tp,eg,ep,ev,re,r,rp)
	local el={}
	local mg=Duel.GetMatchingGroup(c1111041.tfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	for tc in aux.Next(mg) do
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_FUSION_SUBSTITUTE)
		tc:RegisterEffect(e1_1)
		table.insert(el,e1_1)
	end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c1111041.ofilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c1111041.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c1111041.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
	end
	for _,e in ipairs(el) do
		e:Reset()
	end
end
--
