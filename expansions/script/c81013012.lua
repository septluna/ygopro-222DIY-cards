--梦前菜菜·睡衣
local m=81013012
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsLevel,2),1,1)
	c:EnableReviveLimit()
	--double tuner check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.eqcon)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+900)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not se)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,2,nil,TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(21142671)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.adfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.adfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and aux.exccon(e)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsAbleToExtra()) then return end
	if Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
