--霓色独珠 花染千金
function c65050108.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),8,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,65050108)
	e1:SetCondition(c65050108.con)
	e1:SetCost(c65050108.cost)
	e1:SetTarget(c65050108.tg)
	e1:SetOperation(c65050108.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCountLimit(1,65050109)
	e2:SetCondition(c65050108.spcon)
	e2:SetTarget(c65050108.sptg)
	e2:SetOperation(c65050108.spop)
	c:RegisterEffect(e2)
end
function c65050108.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c65050108.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3da8) and c:IsSSetable()
end
function c65050108.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65050108.spfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c65050108.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65050108.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c65050108.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c65050108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65050108.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x3da8) and c:IsType(TYPE_MONSTER)
end
function c65050108.refil(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(65050115)
end
function c65050108.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetHandler():GetOverlayCount()>1 or Duel.IsExistingMatchingCard(c65050108.refil,tp,LOCATION_GRAVE,0,1,nil)) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c65050108.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050108.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():GetOverlayCount()<=0 then return end
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler():GetOverlayCount(),nil) 
	if tg then
		local num=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		if num>0 and Duel.IsExistingMatchingCard(c65050108.thfil,tp,LOCATION_DECK,0,1,nil) then
			local g=Duel.GetMatchingGroup(c65050108.thfil,tp,LOCATION_DECK,0,nil)
			local thg=g:SelectSubGroup(tp,aux.dncheck,false,1,num)
			Duel.SendtoHand(thg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
end