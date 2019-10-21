--霓色独珠的私人邀约
function c65050119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050119+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65050119.condition)
	e1:SetTarget(c65050119.target)
	e1:SetOperation(c65050119.activate)
	c:RegisterEffect(e1)
end
function c65050119.confil(c)
	return c:IsFaceup() and c:IsSetCard(0x3da8) and c:IsType(TYPE_XYZ)
end
function c65050119.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65050119.confil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050119.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050119.tgfil(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050119.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050119.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c65050119.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c65050119.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c65050119.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end