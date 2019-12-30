--凛冽之冬·椎名咪玉
function c81019021.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c81019021.lcheck)
	c:EnableReviveLimit()
	--extra summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(81019021,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsLevel,4))
	c:RegisterEffect(e0)
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81019021)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c81019021.target)
	e1:SetOperation(c81019021.operation)
	c:RegisterEffect(e1)
end
function c81019021.lcheck(g)
	return g:IsExists(Card.IsLevel,1,nil,4)
end
function c81019021.filter(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81019021.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,2,ct)
end
function c81019021.fgoal(sg,exg)
	return aux.dncheck(sg) and exg:IsExists(Card.IsXyzSummonable,1,nil,sg,#sg,#sg)
end
function c81019021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c81019021.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local exg=Duel.GetMatchingGroup(c81019021.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>1 and mg:CheckSubGroup(c81019021.fgoal,2,ct,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:SelectSubGroup(tp,c81019021.fgoal,false,2,ct,exg)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function c81019021.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81019021.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,ct,ct)
end
function c81019021.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c81019021.filter2,nil,e,tp)
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local xyzg=Duel.GetMatchingGroup(c81019021.spfilter,tp,LOCATION_EXTRA,0,nil,g,ct)
	if ct>=2 and xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
