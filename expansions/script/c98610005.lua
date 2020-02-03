--少女分形·心之假面
 function c98610005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98610005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c98610005.sptg)
	e1:SetOperation(c98610005.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98610005,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98610005)
	e2:SetCondition(c98610005.tpcon)
	e2:SetTarget(c98610005.tptg)
	e2:SetOperation(c98610005.tpop)
	c:RegisterEffect(e2)
end
function c98610005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,1)
end
function c98610005.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()<=0 then return end
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    if e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_REMOVED) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98610005.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)and re and re:GetHandler():IsSetCard(0x980)
end
function c98610005.tfilter(c)
	return c:IsSetCard(0x980) and c:IsLocation(LOCATION_REMOVED)  
end
function c98610005.tptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_REMOVED,1,3,nil,REASON_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c98610005.tpop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local g1=Duel.GetOperatedGroup()
	local ct=g1:FilterCount(c98610005.tfilter,nil)
	if ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,REASON_EFFECT)
	    and Duel.SelectYesNo(tp,aux.Stringid(98610005,2)) then
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ct*2,nil,REASON_EFFECT)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	end
end