--不为人知的少女
function c81014020.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(c81014020.tnval)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81014020)
	e2:SetTarget(c81014020.nstg)
	e2:SetOperation(c81014020.nsop)
	c:RegisterEffect(e2)
end
function c81014020.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsLevel(11)
end
function c81014020.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(81014020,0),aux.Stringid(81014020,1))
	e:SetLabel(op)
end
function c81014020.nsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if e:GetLabel()==0 then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_CHANGE_LEVEL)
		  e1:SetValue(5)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		  c:RegisterEffect(e1)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_CHANGE_CODE)
		  e2:SetValue(81014010)
		  c:RegisterEffect(e2)
		else
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_CHANGE_LEVEL)
		  e1:SetValue(6)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		  c:RegisterEffect(e1)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_CHANGE_CODE)
		  e2:SetValue(81014009)
		  c:RegisterEffect(e2)
		end
	end
end
