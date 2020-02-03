--少女分形·世纪之梦
 function c98610004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98610004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c98610004.sptg)
	e1:SetOperation(c98610004.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98610004,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98610004)
	e2:SetCondition(c98610004.tpcon)
	e2:SetTarget(c98610004.tptg)
	e2:SetOperation(c98610004.tpop)
	c:RegisterEffect(e2)
end
function c98610004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,1)
end
function c98610004.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()<=0 then return end
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    if e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_REMOVED) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98610004.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)and re and re:GetHandler():IsSetCard(0x980)
end
function c98610004.tfilter(c,e,tp)
	return c:IsSetCard(0x980)and c:IsType(TYPE_MONSTER)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98610004.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98610004.tfilter,tp,LOCATION_DECK,0,1,nil,e,tp)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98610004.tpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98610004.tfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
    	e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_REMOVE)
	    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	    tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end