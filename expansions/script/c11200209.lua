--混沌归还 斯卡雷特
function c11200209.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_ONFIELD+LOCATION_REMOVED)
	e0:SetValue(11200103)
	c:RegisterEffect(e0)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11200209)
	e1:SetCondition(c11200209.damcon)
	e1:SetTarget(c11200209.damtg)
	e1:SetOperation(c11200209.damop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,11209209)
	e3:SetTarget(c11200209.sptg)
	e3:SetOperation(c11200209.spop)
	c:RegisterEffect(e3)
end
function c11200209.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c11200209.damfilter(c)
	return ((c:IsSetCard(0x46) and c:IsType(TYPE_SPELL)) or c:GetType()==0x82) and c:IsAbleToRemove()
end
function c11200209.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200209.damfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c11200209.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11200209.damfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
function c11200209.thfilter(c)
	return c:IsAbleToDeck() and not c:IsCode(11200209)
end
function c11200209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200209.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler())
		and e:GetHandler():IsAbleToHand() end
	local g=Duel.GetMatchingGroup(c11200209.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11200209.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11200209.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
