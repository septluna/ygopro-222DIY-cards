--十二月短篇·杜野凛世
c26805015.card_code_list={81010004}
function c26805015.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26805015)
	e1:SetCondition(c26805015.spcon)
	e1:SetCost(c26805015.spcost)
	e1:SetTarget(c26805015.sptg)
	e1:SetOperation(c26805015.spop)
	c:RegisterEffect(e1)
end
function c26805015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(81010004)
end
function c26805015.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToGraveAsCost()
end
function c26805015.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26805015.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26805015.cfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c26805015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26805015.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsEnvironment(81010004) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
