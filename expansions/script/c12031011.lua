--小黑
function c12031011.initial_effect(c)
	c:SetSPSummonOnce(12031011)
	--xyz summon
	aux.AddXyzProcedure(c,c12031011.ovfilter1,4,4,c12031011.ovfilter,aux.Stringid(12031011,0))
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12031011.discon)
	e1:SetOperation(c12031011.disop)
	c:RegisterEffect(e1)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12031011,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c12031011.thcost)
	e4:SetTarget(c12031011.thtg)
	e4:SetOperation(c12031011.thop)
	c:RegisterEffect(e4)
end
function c12031011.ovfilter(c)
	return c:IsFaceup() and c:IsCode(12031000)
end
function c12031011.ovfilter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12031011.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c12031011.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tt=c:GetOverlayCount()
	if Duel.GetFlagEffect(tp,12031011)==0 then 
	if not ( ( re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsType(TYPE_CONTINUOUS) ) or not e:GetHandler():IsType(TYPE_XYZ) ) then
	   Duel.Overlay(c,Group.FromCards(re:GetHandler()))
	   Duel.BreakEffect()
	   local ff=c:GetOverlayCount()
	   if ff>tt then
		Duel.RegisterFlagEffect(tp,12031011,RESET_PHASE+PHASE_END,0,1)
		c:RegisterFlagEffect(12031011,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(12031011,4))
	   else
		  Duel.NegateEffect(ev)
	   end
	else
		Duel.NegateEffect(ev)
	end
	end
end
function c12031011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12031011.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c12031011.thfilter1(c)
	return c:GetAttack()==3000 and c:IsAbleToHand()
end
function c12031011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c12031011.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c12031011.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ct=Duel.SelectMatchingCard(tp,c12031011.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	Duel.SendtoHand(ct,tp,REASON_EFFECT)
	if c:IsCode(12031000) and Duel.IsExistingMatchingCard(c12031011.thfilter1,tp,LOCATION_DECK,0,1,nil) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local ct=Duel.SelectMatchingCard(tp,c12031011.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	   Duel.SendtoHand(ct,tp,REASON_EFFECT)
	end
end
