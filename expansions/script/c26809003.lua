--五维介质·丛林法则
local m=26809003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e1:SetValue(26806009)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.sumcon)
	e2:SetCost(cm.sumcost)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)
	--summon proc
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(cm.extg)
	e4:SetCondition(cm.ssmcon)
	e4:SetOperation(cm.ssmop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(cm.extg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.extg(e,c)
	return c:IsAttack(2200) and c:IsDefense(600)
end
function cm.ssmcon(e,c,minc)
	if c==nil then return e:GetHandler():IsReleasable() and e:GetHandler():IsFaceup() end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.ssmop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Release(e:GetHandler(),REASON_COST)
end
