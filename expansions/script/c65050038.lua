--花物语-花色无空-
function c65050038.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,65050038)
	e1:SetCondition(c65050038.con)
	e1:SetTarget(c65050038.target)
	e1:SetOperation(c65050038.activate)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6da7))
	e3:SetCondition(c65050038.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--tohand!
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c65050038.thcon)
	e4:SetCost(c65050038.thcost)
	e4:SetTarget(c65050038.thtg)
	e4:SetOperation(c65050038.thop)
	c:RegisterEffect(e4)
end
function c65050038.indcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c65050038.confil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x6da7) 
end
function c65050038.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050038.confil,1,nil,tp)
end
function c65050038.tgfilter(c)
	return c:IsSetCard(0x6da7) and c:IsAbleToHand()
end
function c65050038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050038.tgfilter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(c65050038.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65050038.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65050038.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c65050038.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsSetCard(0x6da7) 
end
function c65050038.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c65050038.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,Duel.GetAttacker(),1,0,0)
end
function c65050038.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end