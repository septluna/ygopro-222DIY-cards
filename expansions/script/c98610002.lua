--少女分形·仿徨之冥
 function c98610002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98610002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c98610002.sptg)
	e1:SetOperation(c98610002.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98610002,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98610002)
	e2:SetCondition(c98610002.tpcon)
	e2:SetTarget(c98610002.tptg)
	e2:SetOperation(c98610002.tpop)
	c:RegisterEffect(e2)
end
function c98610002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,1)
end
function c98610002.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()<=0 then return end
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    if e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_REMOVED) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98610002.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)and re and re:GetHandler():IsSetCard(0x870)
end
function c98610002.refilter(c)
	return c:IsSetCard(0x870) and c:IsAbleToDeck()
end
function c98610002.repfilter1(c)
	return c:IsSetCard(0x870) and c:IsAbleToHand()
end
function c98610002.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98610002.refilter,tp,LOCATION_GRAVE,0,1,nil)and 
	          Duel.IsExistingMatchingCard(c98610002.repfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,1)
end
function c98610002.tpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98610002.refilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then 
	    Duel.SendtoDeck(g,nil,0,REASON_EFFECT) 
	    local g1=Duel.GetOperatedGroup()
	    if g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then 
		    Duel.BreakEffect()
	        Duel.ShuffleDeck(tp)
		    if Duel.IsExistingMatchingCard(c98610002.repfilter1,tp,LOCATION_DECK,0,1,nil) then
		        local g2=Duel.SelectMatchingCard(tp,c98610002.repfilter1,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
		        Duel.ConfirmCards(1-tp,g2)
            end
	   end
	end
end