--狂气的狼人
local m=17030023
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST+EVENT_PAY_LPCOST+EVENT_DAMAGE_STEP_END+EVENT_BATTLED+EVENT_BATTLE_DAMAGE+EVENT_DAMAGE)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon1)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.rccfilter(c)
	return c:IsFaceup() and c:IsCode(17030001)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.rccfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>1
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Recover(1-tp,114514,REASON_EFFECT)
end