--永辉真理 普遍概念
function c30557007.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c30557007.fusfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x306),2,true)
	 --change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,30557007)
	e1:SetCondition(c30557007.con)
	e1:SetTarget(c30557007.tg)
	e1:SetOperation(c30557007.op)
	c:RegisterEffect(e1)
	 --disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0xff)
	e2:SetTarget(c30557007.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetOperation(c30557007.desop)
	c:RegisterEffect(e3)
end
function c30557007.fusfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown()
end
function c30557007.desfil(c,atk)
	return c:IsAttackAbove(atk)
end
function c30557007.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=99999
	if c:IsPreviousLocation(LOCATION_MZONE) then
		atk=c:GetPreviousAttackOnField()
	else
		atk=c:GetAttack()
	end
	local g=Duel.GetMatchingGroup(c30557007.desfil,tp,0,LOCATION_MZONE,nil,atk)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c30557007.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>=e:GetHandler():GetBaseAttack()
end
function c30557007.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c30557007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c30557007.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end