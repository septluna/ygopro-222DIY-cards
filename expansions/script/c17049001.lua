--神撃竜アルティメットバハムート
local m=17049001
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.psplimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.value)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17049001,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17049001,1))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(cm.discon)
	e6:SetTarget(cm.distg)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
	--spsummon bgm
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetOperation(cm.sumsuc)
	c:RegisterEffect(e7)
end
cm.spchecks=aux.CreateChecks(Card.IsAttribute,{ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK})
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.spcostfilter(c)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH+ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:CheckSubGroupEach(cm.spchecks,aux.mzctcheck,tp) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroupEach(tp,cm.spchecks,false,aux.mzctcheck,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function cm.value(e,c)
	local tp=e:GetHandlerPlayer()
	local att=0
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=g:GetNext()
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	return ct*500
end
function cm.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(17049001,3))
end	