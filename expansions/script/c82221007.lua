function c82221007.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),false)
	--fusion  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82221007,0)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,82221007) 
	e1:SetTarget(c82221007.mftg)  
	e1:SetOperation(c82221007.mfop)  
	c:RegisterEffect(e1)  
	--actlimit  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetCondition(c82221007.actcon)  
	e2:SetOperation(c82221007.actop)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EVENT_BE_BATTLE_TARGET)  
	c:RegisterEffect(e3)  
	--search  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(82221007,1))  
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,82231007)
	e4:SetTarget(c82221007.thtg)  
	e4:SetOperation(c82221007.thop)  
	c:RegisterEffect(e4)  
end
function c82221007.mffilter1(c,e)  
	return c:IsOnField() and not c:IsImmuneToEffect(e)  
end  
function c82221007.mffilter2(c,e,tp,m,f,gc,chkf)  
	return c:IsType(TYPE_FUSION) and not c:IsCode(82221007) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)  
end  
function c82221007.mftg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)  
		local res=Duel.IsExistingMatchingCard(c82221007.mffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg2=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(c82221007.mffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function c82221007.mfop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local chkf=tp  
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end  
	local mg1=Duel.GetFusionMaterial(tp):Filter(c82221007.mffilter1,nil,e)  
	local sg1=Duel.GetMatchingGroup(c82221007.mffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)  
	local mg2=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg2=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(c82221007.mffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)  
	end  
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then  
		local sg=sg1:Clone()  
		if sg2 then sg:Merge(sg2) end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local tg=sg:Select(tp,1,1,nil)  
		local tc=tg:GetFirst()  
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then  
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)  
			tc:SetMaterial(mat1)  
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure()  
	end 
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	if c:IsLocation(LOCATION_EXTRA) and c:GetControler()==tp and c:IsPosition(POS_FACEUP) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(82221007,2)) then
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end  
function c82221007.actcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetAttacker()  
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end  
	return tc and tc:IsControler(tp)  
end  
function c82221007.actop(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetTargetRange(0,1)  
	e1:SetValue(c82221007.aclimit)  
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)  
	Duel.RegisterEffect(e1,tp)  
end  
function c82221007.aclimit(e,re,tp)  
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)  
end  
function c82221007.thfilter(c)  
	return c:IsSetCard(0x292) and c:IsAbleToHand()  
end  
function c82221007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221007.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221007.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221007.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  