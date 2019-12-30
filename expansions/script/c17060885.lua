--圣夜型多莫维依
local m=17060885
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--extra link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTarget(cm.mattg)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetTargetRange(0,LOCATION_PZONE)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060885,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.cttg)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060885,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,17060885)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
end
cm.is_named_with_domovo_i=1
cm.is_named_with_Ma_Elf=1
function cm.matval(e,c,mg)
    return c:IsCode(17060885)
end
function cm.mattg(e,c)
    return c:IsType(TYPE_PENDULUM)
end
function cm.ctfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsControlerCanBeChanged()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
function cm.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local off=1
	local ops={aux.Stringid(17060885,2),aux.Stringid(17060885,3)}
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(op)
	e:SetCategory(CATEGORY_TOHAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		--negate
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.negcon)
		e1:SetOperation(cm.negop)
		Duel.RegisterEffect(e1,tp)
	elseif sel==1 and Duel.GetFlagEffect(tp,17060885)==0 then
		--damage reduce
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetValue(cm.val)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetCondition(cm.damcon)
		Duel.RegisterEffect(e4,tp)
		Duel.RegisterFlagEffect(tp,17060885,0,0,0)
		Duel.RegisterFlagEffect(tp,17060886,0,0,0)
	else
		Duel.RegisterFlagEffect(tp,17060886,0,0,0)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,17060885)
	Duel.NegateEffect(ev)
end
function cm.val(e,re,dam,r,rp,rc)
	local ct=Duel.GetFlagEffect(1-rp,17060886)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and ct>0 then
		Duel.Hint(HINT_CARD,0,17060885)
		if ct-1==0 then 
			Duel.ResetFlagEffect(1-rp,17060886)
		else Duel.ResetFlagEffect(1-rp,17060886)
			Duel.RegisterFlagEffect(1-rp,17060886,0,0,ct-1)
		end
		return 0
	else return dam end
end
function cm.damcon(e)
	return Duel.GetFlagEffect(1-rp,17060886)>0
end
