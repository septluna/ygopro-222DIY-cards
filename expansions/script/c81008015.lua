--一瞬回眸·大石泉
function c81008015.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81008015)
	e1:SetCondition(c81008015.spcon)
	e1:SetTarget(c81008015.sptg)
	e1:SetOperation(c81008015.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81008015)
	e2:SetCost(c81008015.tpcost)
	e2:SetTarget(c81008015.tptg)
	e2:SetOperation(c81008015.tpop)
	c:RegisterEffect(e2)
end
function c81008015.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function c81008015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81008015.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c81008015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81008015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c81008015.dfilter(c,tp)
	return c:IsRace(RACE_CYBERSE) and c:GetSummonLocation()==LOCATION_EXTRA and Duel.GetMZoneCount(tp,c)>0
end
function c81008015.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c81008015.dfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c81008015.dfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c81008015.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81008015.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
