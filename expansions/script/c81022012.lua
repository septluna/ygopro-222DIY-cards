--深蓝之殇·天空桥朋花
function c81022012.initial_effect(c)
	aux.AddCodeList(c,81022000)
	c:EnableReviveLimit()
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e0:SetValue(81022000)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81022012)
	e1:SetCondition(c81022012.negcon)
	e1:SetCost(c81022012.negcost)
	e1:SetTarget(c81022012.negtg)
	e1:SetOperation(c81022012.negop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,81022912)
	e2:SetCondition(c81022012.thcon)
	e2:SetTarget(c81022012.thtg)
	e2:SetOperation(c81022012.thop)
	c:RegisterEffect(e2)
end
function c81022012.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsCode(81022000)
end
function c81022012.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c81022012.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c81022012.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c81022012.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c81022012.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
	end
end
function c81022012.thfilter(c)
	return aux.IsCodeListed(c,81022000) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(81022012)
end
function c81022012.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
end
function c81022012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c81022012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81022012.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81022012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end