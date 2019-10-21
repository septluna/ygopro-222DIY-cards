--贤者之翼·橘爱丽丝
function c81008031.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c81008031.lcheck)
	c:EnableReviveLimit()
	--cannot link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetCondition(c81008031.linkcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81008031,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81008031)
	e2:SetCost(c81008031.spcost)
	e2:SetTarget(c81008031.sptg1)
	e2:SetOperation(c81008031.spop1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81008031,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81008931)
	e3:SetCost(c81008031.spcost)
	e3:SetTarget(c81008031.sptg2)
	e3:SetOperation(c81008031.spop2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(81008031,ACTIVITY_ATTACK,c81008031.counterfilter)
end
function c81008031.counterfilter(c)
	return c:IsType(TYPE_FUSION)
end
function c81008031.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81008031,tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c81008031.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81008031.atktg(e,c)
	return not c:IsType(TYPE_FUSION)
end
function c81008031.linkcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c81008031.lcheck(g,lc)
	return g:GetClassCount(Card.GetOriginalCode)==g:GetCount()
end
function c81008031.spfilter1(c,e,tp,zone)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c81008031.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81008031.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81008031.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or zone<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81008031.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		c:SetCardTarget(tc)
	end
	Duel.SpecialSummonComplete()
end
function c81008031.spfilter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c81008031.spfilter3(c,e,tp,m,g,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and g:IsExists(c81008031.spfilter4,1,nil,m,c,chkf)
end
function c81008031.spfilter4(c,m,fusc,chkf)
	return fusc:CheckFusionMaterial(m,c,chkf)
end
function c81008031.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=e:GetHandler():GetCardTarget():Filter(Card.IsControler,nil,tp)
		if g:GetCount()==0 then return false end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c81008031.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,g,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c81008031.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,g,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c81008031.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=c:GetCardTarget():Filter(Card.IsControler,nil,tp)
	g:Remove(Card.IsImmuneToEffect,nil,e)
	if g:GetCount()==0 then return false end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c81008031.spfilter2,nil,e)
	local sg1=Duel.GetMatchingGroup(c81008031.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,g,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c81008031.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,g,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local ec=g:FilterSelect(tp,c81008031.spfilter4,1,1,nil,mg1,tc,chkf):GetFirst()
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,ec,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local ec=g:FilterSelect(tp,c81008031.spfilter4,1,1,nil,mg2,tc,chkf):GetFirst()
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,ec,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
