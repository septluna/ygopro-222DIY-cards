--混沌螺旋
local m=11200210
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m+9000)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,3,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x11,1550,1050,8,RACE_ROCK,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x11,1550,1050,8,RACE_ROCK,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		--Activate
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
		e1:SetCondition(cm.subcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function cm.nfilter(c)
	return c:IsFaceup() and (bit.band(c:GetType(),0x81)==0x81 or c:IsType(TYPE_FUSION)) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.actcon(e)
	return Duel.IsExistingMatchingCard(cm.nfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil)
end
