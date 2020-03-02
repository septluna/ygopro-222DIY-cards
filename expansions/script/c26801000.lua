--Love Emotion
local m=26801000
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e0:SetValue(LINK_MARKER_TOP_RIGHT+LINK_MARKER_TOP)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.atkcon)
	e2:SetTarget(cm.atktg)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--lv
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.lvtg)
	e4:SetOperation(cm.lvop)
	c:RegisterEffect(e4)
	--splimit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ea:SetRange(LOCATION_SZONE)
	ea:SetTargetRange(1,0)
	ea:SetTarget(cm.splimit)
	c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(eb)
	--cannot act
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_FIELD)
	ec:SetCode(EFFECT_CANNOT_ACTIVATE)
	ec:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ec:SetRange(LOCATION_SZONE)
	ec:SetTargetRange(1,0)
	ec:SetValue(cm.aclimit)
	c:RegisterEffect(ec)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function cm.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsAttribute(ATTRIBUTE_WIND) and ((c:IsType(TYPE_NORMAL) and c:IsLevel(8)) or (c:IsType(TYPE_FUSION) and not c:IsType(TYPE_EFFECT)) or c:IsCode(81011009))
end
function cm.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if c:GetFlagEffect(m)~=0 then return 2500 end
	if d:IsType(TYPE_EFFECT) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
		return 2500
	else return 0 end
end
function cm.afilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_NORMAL) and c:IsLevel(8)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_HAND,0,1,nil) end
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(cm.afilter,tp,LOCATION_HAND,0,nil)
	local tc=hg:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_LEVEL)
		e0:SetValue(4)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		tc=hg:GetNext()
	end
	if Duel.GetFlagEffect(tp,m+900)~=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(cm.extg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m+900,RESET_PHASE+PHASE_END,0,1)
end
function cm.extg(e,c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_NORMAL)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_EFFECT)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
