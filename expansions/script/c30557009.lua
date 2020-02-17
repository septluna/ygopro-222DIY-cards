--连言推理合成式
function c30557009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c30557009.target)
	e1:SetOperation(c30557009.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,30557009)
	e2:SetCost(c30557009.tdcost)
	e2:SetTarget(c30557009.tdtg)
	e2:SetOperation(c30557009.tdop)
	c:RegisterEffect(e2)
end
function c30557009.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c30557009.tdfil(c)
	return c:IsSetCard(0x306) and c:IsAbleToHand()
end
function c30557009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30557009.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c30557009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c30557009.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c30557009.spfilter(c,e,tp,tid)
	return c:GetTurnID()==tid and 
		bit.band(c:GetReason(),REASON_DESTROY)~=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30557009.fspfilter(c,e,tp,tid,mg,chkf)
	mg:AddCard(c)
	local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
			end
	return (c30557009.spfilter(c,e,tp,tid) and Duel.IsExistingMatchingCard(c30557009.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)) or (ce~=nil and Duel.IsExistingMatchingCard(c30557009.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf))
end
function c30557009.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c30557009.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c:IsSetCard(0x306)
end
function c30557009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mmg1=Duel.GetMatchingGroup(c30557009.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,tid)
		local mgg=mg1
		mgg:Merge(mmg1)
		local res=Duel.IsExistingMatchingCard(c30557009.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mgg,nil,chkf) 
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c30557009.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c30557009.fspfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,tid,mg1,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c30557009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tid=Duel.GetTurnCount()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c30557009.filter1,nil,e)
	local g=Duel.SelectMatchingCard(tp,c30557009.fspfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,tid,mg1,chkf)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	Duel.BreakEffect()
	mg1=Duel.GetFusionMaterial(tp):Filter(c30557009.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c30557009.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c30557009.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	end
end
