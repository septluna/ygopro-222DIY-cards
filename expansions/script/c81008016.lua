--青空之夏·多田李衣菜
function c81008016.initial_effect(c)
	--lv up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,81008016)
	e1:SetTarget(c81008016.target)
	e1:SetOperation(c81008016.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c81008016.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsRace(RACE_MACHINE)
end
function c81008016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81008016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81008016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81008016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local ln=0
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetFirst():IsLevel(10) then
		ln=Duel.SelectOption(tp,aux.Stringid(81008016,1))
		op=0
	else if g:GetFirst():IsLevel(4) then
			ln=Duel.SelectOption(tp,aux.Stringid(81008016,2))
			op=1
		else
			ln=Duel.SelectOption(tp,aux.Stringid(81008016,1),aux.Stringid(81008016,2))
			op=ln
		end
	end
	e:SetLabel(op)
end
function c81008016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(4)
		else
			e1:SetValue(10)
		end
		tc:RegisterEffect(e1)
	end
end
