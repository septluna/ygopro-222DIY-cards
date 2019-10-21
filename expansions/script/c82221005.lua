function c82221005.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--Special Summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221005,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,82221005)
	e1:SetCondition(c82221005.spcon)  
	e1:SetTarget(c82221005.sptg)  
	e1:SetOperation(c82221005.spop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c82221005.spcon2)
	c:RegisterEffect(e2) 
	--to hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221005,1))  
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_FUSION_SUMMON) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,82231005) 
	e3:SetCondition(c82221005.fucon)  
	e3:SetTarget(c82221005.futg)  
	e3:SetOperation(c82221005.fuop)  
	c:RegisterEffect(e3)  
end  
function c82221005.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0  
end  
function c82221005.spcon2(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA)
end  
function c82221005.spfilter(c,e,tp)  
	return c:IsSetCard(0x292) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82221005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c82221005.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(c82221005.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,c82221005.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function c82221005.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
function c82221005.fucon(e,tp,eg,ep,ev,re,r,rp)  
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,TYPE_FUSION)
end  
function c82221005.filter1(c,e)  
	return not c:IsImmuneToEffect(e)  
end  
function c82221005.filter2(c,e,tp,m,f,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1292) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)  
end  
function c82221005.futg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetFusionMaterial(tp)  
		local res=Duel.IsExistingMatchingCard(c82221005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg2=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(c82221005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function c82221005.fuop(e,tp,eg,ep,ev,re,r,rp)  
	local chkf=tp  
	local mg1=Duel.GetFusionMaterial(tp):Filter(c82221005.filter1,nil,e)  
	local sg1=Duel.GetMatchingGroup(c82221005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)  
	local mg2=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg2=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(c82221005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)  
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
end  