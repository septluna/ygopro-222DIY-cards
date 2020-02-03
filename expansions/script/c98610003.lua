--少女分形·轮回之爱
 function c98610003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98610003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c98610003.sptg)
	e1:SetOperation(c98610003.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98610003,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98610003)
	e2:SetCondition(c98610003.tpcon)
	e2:SetTarget(c98610003.tptg)
	e2:SetOperation(c98610003.tpop)
	c:RegisterEffect(e2)
end
function c98610003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,1)
end
function c98610003.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()<=0 then return end
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    if e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_REMOVED) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98610003.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)and re and re:GetHandler():IsSetCard(0x980)
end
function c98610003.tfilter(c,tp)
	return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(tp))) and c:IsAbleToRemove()
end
function c98610003.tptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c98610003.tfilter(chkc,tp,ft) end
	if chk==0 then return Duel.IsExistingTarget(c98610003.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c98610003.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98610003.tpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		    Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end