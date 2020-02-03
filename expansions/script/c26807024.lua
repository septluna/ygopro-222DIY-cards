--新年伊始·海伊
function c26807024.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26807024,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26807024)
	e1:SetCost(c26807024.spcost)
	e1:SetTarget(c26807024.sptg)
	e1:SetOperation(c26807024.spop)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c26807024.cfilter(c)
	return c:IsAttack(2200) and c:IsDefense(600) and not c:IsPublic()
end
function c26807024.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26807024.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c26807024.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c26807024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26807024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
