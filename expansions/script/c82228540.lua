function c82228540.initial_effect(c)   
	--special summon 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228540,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,82228540) 
	e1:SetCost(c82228540.cost)  
	e1:SetTarget(c82228540.sptg)  
	e1:SetOperation(c82228540.spop)  
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--destroy replace  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_DESTROY_REPLACE)  
	e3:SetTarget(c82228540.reptg1)  
	c:RegisterEffect(e3)  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCode(EFFECT_DESTROY_REPLACE)  
	e4:SetTarget(c82228540.reptg2)  
	c:RegisterEffect(e4)
	--search  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(82228540,3))  
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e5:SetCountLimit(1,82218540)  
	e5:SetTarget(c82228540.shtg)  
	e5:SetOperation(c82228540.shop)  
	c:RegisterEffect(e5)	
end
c82228540.card_code_list={82228540}
function c82228540.cfilter(c)  
	return c:IsDiscardable()  
end  
function c82228540.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228540.cfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,c82228540.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)  
end  
function c82228540.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function c82228540.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
end   
function c82228540.repfilter1(c)  
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()  
end  
function c82228540.reptg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
		and Duel.IsExistingMatchingCard(c82228540.repfilter1,tp,LOCATION_HAND,0,1,nil) end  
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(82228540,1)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)  
		local g=Duel.SelectMatchingCard(tp,c82228540.repfilter1,tp,LOCATION_HAND,0,1,1,nil)  
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)  
		return true  
	else return false end  
end  
function c82228540.repfilter2(c)  
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()  
end  
function c82228540.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
		and Duel.IsExistingMatchingCard(c82228540.repfilter2,tp,LOCATION_GRAVE,0,1,nil) end  
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(82228540,2)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)  
		local g=Duel.SelectMatchingCard(tp,c82228540.repfilter2,tp,LOCATION_GRAVE,0,1,1,nil)  
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REPLACE)  
		return true  
	else return false end  
end  
function c82228540.filter(c)  
	return aux.IsCodeListed(c,82228540) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end  
function c82228540.shtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228540.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228540.shop(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.IsExistingMatchingCard(c82228540.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228540.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  