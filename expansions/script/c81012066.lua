--深红目光·爱米莉
function c81012066.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--destroy & search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,81012066)
	e1:SetCost(c81012066.thcost)
	e1:SetTarget(c81012066.thtg)
	e1:SetOperation(c81012066.thop)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c81012066.recon)
	e2:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,81012966)
	e3:SetTarget(c81012066.damtg)
	e3:SetOperation(c81012066.damop)
	c:RegisterEffect(e3)
end
function c81012066.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c81012066.thfilter(c)
	return c:IsAttack(1550) and not c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c81012066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(c81012066.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81012066.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81012066.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c81012066.damfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER)
end
function c81012066.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81012066.damfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local val=Duel.GetMatchingGroupCount(c81012066.damfilter,tp,LOCATION_EXTRA,0,nil)*300
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c81012066.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val=Duel.GetMatchingGroupCount(c81012066.damfilter,tp,LOCATION_EXTRA,0,nil)*300
	Duel.Damage(p,val,REASON_EFFECT)
end
function c81012066.recon(e)
	return e:GetHandler():IsFaceup()
end
