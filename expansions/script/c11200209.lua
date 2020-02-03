--混沌归还 斯卡雷特
function c11200209.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11200209)
	e1:SetTarget(c11200209.rmtg)
	e1:SetOperation(c11200209.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,11209209)
	e3:SetTarget(c11200209.sptg)
	e3:SetOperation(c11200209.spop)
	c:RegisterEffect(e3)
end
function c11200209.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c11200209.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c11200209.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c11200209.cfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c11200209.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c11200209.thfilter(c)
	return c:IsCode(11200209) and c:IsAbleToHand()
end
function c11200209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c11200209.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11200209.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11200209.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
