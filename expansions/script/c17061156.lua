--
local m=17061156
local cm=_G["c"..m]
function cm.initial_effect(c)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.reccon)
	e5:SetTarget(cm.rectg)
	e5:SetOperation(cm.recop)
	c:RegisterEffect(e5)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,5000)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
		Duel.Recover(tp,5000,REASON_EFFECT)
	end
end