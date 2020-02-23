--休闲时光 伊瑟琳
function c75646612.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,75646612)
	e1:SetCost(c75646612.spcost)
	e1:SetTarget(c75646612.sptg)
	e1:SetOperation(c75646612.spop)
	c:RegisterEffect(e1)
	--special summon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646612,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,5646612)
	e2:SetCondition(c75646612.con)
	e2:SetTarget(c75646612.tg)
	e2:SetOperation(c75646612.op)
	c:RegisterEffect(e2) 
end
function c75646612.cfilter(c,tp)
	if c:IsLocation(LOCATION_GRAVE) then return c:IsHasEffect(75646628,tp) and c:IsAbleToRemoveAsCost() end
	return aux.IsCodeListed(c,75646600) and c:IsAbleToGraveAsCost() 
end
function c75646612.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c75646612.cfilter,tp,loc,0,1,e:GetHandler(),tp) end
	local g=Duel.GetMatchingGroup(c75646612.cfilter,tp,loc,0,e:GetHandler(),tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,e:GetHandler()):GetFirst()
	local te=tc:IsHasEffect(75646628,tp)
	if te then
		e:SetLabel(1)
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		if tc:IsCode(75646600) then e:SetLabel(1) end
		Duel.SendtoGrave(tc,REASON_COST)
	end
end
function c75646612.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75646612.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)>0) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75646612,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function c75646612.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c75646612.spfilter(c,e,tp)
	return c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646612.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c75646612.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75646612.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75646612.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if Duel.GetFlagEffect(tp,75646600)>0 and sg:GetCount()>0 then 
		local tg=sg:RandomSelect(1-tp,1)
		Duel.SendtoGrave(tg,REASON_DISCARD+REASON_EFFECT)
	end
end