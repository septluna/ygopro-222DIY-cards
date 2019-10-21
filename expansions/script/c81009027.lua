--沁人花香·相叶夕美
function c81009027.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81009027,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81009027)
	e1:SetTarget(c81009027.target)
	e1:SetOperation(c81009027.operation)
	c:RegisterEffect(e1)
end
function c81009027.filter(c)
	return c:IsFaceup() and not (c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) and c:IsHasEffect(EFFECT_NO_BATTLE_DAMAGE) and c:IsHasEffect(EFFECT_AVOID_BATTLE_DAMAGE))
end
function c81009027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c81009027.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81009027.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81009027.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		tc:RegisterEffect(e4)
	end
end
