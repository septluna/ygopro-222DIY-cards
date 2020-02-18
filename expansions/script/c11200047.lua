--土著神的顶点
function c11200047.initial_effect(c)
	aux.AddCodeList(c,11200029)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,c11200047.ovfilter,aux.Stringid(11200047,0),2,c11200047.xyzop)
	c:EnableReviveLimit()
	--atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c11200047.atkval)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11200047.cost)
	e1:SetOperation(c11200047.operation)
	c:RegisterEffect(e1)
end
function c11200047.ovfilter(c)
	return c:IsFaceup() and c:IsCode(11200029)
end
function c11200047.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11200047)==0 end
	Duel.RegisterFlagEffect(tp,11200047,RESET_PHASE+PHASE_END,0,1)
end
function c11200047.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c11200047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c11200047.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end
function c11200047.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11200047.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(c11200047.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if e:GetLabelObject():IsType(TYPE_XYZ) and e:GetLabelObject():IsRace(RACE_AQUA) then
		local code=e:GetLabelObject():GetCode()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetValue(code)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end
function c11200047.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
