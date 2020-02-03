--最上静香的情人节礼物
local m=81018022
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(cm.eqlimit)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetCondition(cm.atkcon)
	e5:SetTarget(cm.atktg)
	e5:SetValue(-1000)
	c:RegisterEffect(e5)
end
function cm.eqlimit(e,c)
	return c:IsControler(1-e:GetHandlerPlayer())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function cm.atkval(e,c)
	return c:GetBaseAttack()
end
function cm.atkcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.atktg(e,c)
	return c:IsSetCard(0x81b)
end
