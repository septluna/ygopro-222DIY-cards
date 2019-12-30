--似是似非的现实
function c81010049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,81010049+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81010049.condition)
	e1:SetTarget(c81010049.target)
	e1:SetOperation(c81010049.activate)
	c:RegisterEffect(e1)
	if not c81010049.global_check then
		c81010049.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c81010049.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c81010049.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (bit.band(r,REASON_EFFECT)~=0 and rp==1-ep) or bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(ep,81010049,RESET_PHASE+PHASE_END,0,1)
	end
end
function c81010049.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81010049)~=0
end
function c81010049.spfilter(c,e,tp)
	return c:IsAttack(1550) and c:IsDefense(1050) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81010049.ctfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c81010049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81010049.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c81010049.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c81010049.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c81010049.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetMatchingGroupCount(c81010049.ctfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,ct))
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c81010049.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c81010049.splimit(e,c)
	return not ((c:IsAttack(1550) and c:IsDefense(1050)) or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)))
end
