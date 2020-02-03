--ZENITHALIZE
function c26807002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26807002+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26807002.condition)
	e1:SetTarget(c26807002.target)
	e1:SetOperation(c26807002.activate)
	c:RegisterEffect(e1)
end
function c26807002.bfilter(c,tp)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c26807002.cfilter,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end
function c26807002.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c26807002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26807002.bfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c26807002.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c26807002.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetCode())
end
function c26807002.filter2(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToHand()
end
function c26807002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26807002.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26807002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c26807002.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g1:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c26807002.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,g1,g1:GetFirst():GetCode())
	g1:Merge(g2)
	if Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g1)
	end
end
