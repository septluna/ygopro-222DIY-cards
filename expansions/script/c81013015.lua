--停不下来的妄想症
function c81013015.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81013015+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81013015.spcon)
	e1:SetTarget(c81013015.sptg)
	e1:SetOperation(c81013015.spop)
	c:RegisterEffect(e1)
end
function c81013015.cfilter(c)
	return c:IsFacedown() or c:IsType(TYPE_EFFECT)
end
function c81013015.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and not g:IsExists(c81013015.cfilter,1,nil)
end
function c81013015.tfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0x8,tp,false,false)
		and not Duel.IsExistingMatchingCard(c81013015.bfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function c81013015.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsFaceup()
end
function c81013015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81013015.tfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81013015.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c81013015.tfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0x8,tp,tp,false,false,POS_FACEUP)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81013015.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c81013015.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c81013015.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end
function c81013015.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
