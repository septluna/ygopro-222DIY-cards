--北上丽花的跨年夜
require("expansions/script/c81000000")
function c81015052.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,81015052)
	e0:SetTarget(c81015052.target)
	e0:SetOperation(c81015052.activate)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,81015952)
	e1:SetCondition(c81015052.tdcon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c81015052.destg)
	e1:SetOperation(c81015052.desop)
	c:RegisterEffect(e1)
end
function c81015052.filter(c)
	return c:IsSetCard(0x81a) and c:IsAbleToHand() and c:IsFaceup()
end
function c81015052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81015052.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c81015052.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81015052.filter),tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81015052.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Tenka.ReikaCon(e) and aux.exccon(e)
end
function c81015052.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81015052.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
