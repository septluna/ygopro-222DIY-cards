--万圣狂欢·爱米莉
function c81012076.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c81012076.matfilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PYRO))
	c:RegisterEffect(e1)
	--ritual summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_BATTLE_END)
	e2:SetCountLimit(1,81012076)
	e2:SetCondition(c81012076.rscon)
	e2:SetTarget(c81012076.rstg)
	e2:SetOperation(c81012076.rsop)
	c:RegisterEffect(e2)
end
function c81012076.matfilter(c)
	return c:IsRace(RACE_PYRO) and not c:IsFusionType(TYPE_TOKEN)
end
function c81012076.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c81012076.rcheck(gc)
	return  function(tp,g,c)
				return g:IsContains(gc)
			end
end
function c81012076.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)
end
function c81012076.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		aux.RCheckAdditional=c81012076.rcheck(c)
		local res=mg:IsContains(c) and Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c81012076.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81012076.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or not mg:IsContains(c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c81012076.rcheck(c)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c81012076.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
		mg:RemoveCard(tc)
		end
		if not mg:IsContains(c) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		Duel.SetSelectedCard(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
end
