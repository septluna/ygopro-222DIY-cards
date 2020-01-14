--水歌 零奏龙卡拉
function c12003008.initial_effect(c)
   --special summon
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12003008.spcon)
	e1:SetOperation(c12003008.spop)
	c:RegisterEffect(e1)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003008,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12003008.cost)
	e1:SetTarget(c12003008.distg)
	e1:SetOperation(c12003008.disop)
	c:RegisterEffect(e1)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003008,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12003008)
	e1:SetCost(c12003008.rmcost)
	e1:SetTarget(c12003008.rmtg)
	e1:SetOperation(c12003008.rmop)
	c:RegisterEffect(e1)
end
function c12003008.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function c12003008.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c12003008.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c12003008.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c12003008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_HAND)
end
function c12003008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c12003008.spfilter(c,ft)
	return c:IsFaceup() and c:IsRace(RACE_SEASERPENT) and c:IsLevelAbove(8) and not c:IsCode(12003008) and c:IsAbleToHandAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c12003008.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c12003008.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c12003008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c12003008.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c12003008.costfilter(c)
	return  c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,c,c:GetCode())
end
function c12003008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12003008.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c12003008.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	g:Merge(Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED,0):Filter(Card.IsCode,nil,g:GetFirst():GetCode()):Select(tp,2,2,g:GetFirst()))
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c12003008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12003008.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end