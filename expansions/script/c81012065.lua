--记忆的微笑·爱米莉
function c81012065.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c81012065.sprcon)
	e0:SetOperation(c81012065.sprop)
	c:RegisterEffect(e0)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PYRO))
	e2:SetValue(c81012065.indesval)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,81012065)
	e3:SetCondition(c81012065.thcon)
	e3:SetTarget(c81012065.thtg)
	e3:SetOperation(c81012065.thop)
	c:RegisterEffect(e3)
end
function c81012065.sprfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function c81012065.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81012065.sprfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c81012065.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81012065.sprfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c81012065.indesval(e,re,r,rp)
	return bit.band(r,REASON_RULE+REASON_BATTLE)==0
end
function c81012065.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c81012065.thfilter(c)
	return c:IsCode(81012065) and c:IsAbleToHand()
end
function c81012065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81012065.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81012065.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81012065.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
