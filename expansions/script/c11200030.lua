--两栖类的神明
function c11200030.initial_effect(c)
	aux.AddCodeList(c,11200029)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--attack up
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_ATKCHANGE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCountLimit(1,11200030)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCost(c11200030.cost)
	e0:SetTarget(c11200030.adtg)
	e0:SetOperation(c11200030.adop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11200930)
	e1:SetCondition(c11200030.thcon)
	e1:SetTarget(c11200030.thtg)
	e1:SetOperation(c11200030.thop)
	c:RegisterEffect(e1)
end
function c11200030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11200030.adfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end
function c11200030.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200030.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c11200030.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11200030.adfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c11200030.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c11200030.thfilter(c)
	return aux.IsCodeListed(c,11200029) and not c:IsCode(11200030) and c:IsAbleToHand()
end
function c11200030.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11200030.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200030.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11200030.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11200030.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
