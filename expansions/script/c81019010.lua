--学院同桌·爱米莉
function c81019010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,81019010)
	e1:SetCost(c81019010.cost)
	e1:SetOperation(c81019010.operation)
	c:RegisterEffect(e1)
	--lvdown
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81019010,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,81019910)
	e4:SetCost(c81019010.lvcost)
	e4:SetTarget(c81019010.lvtg)
	e4:SetOperation(c81019010.lvop)
	c:RegisterEffect(e4)
end
function c81019010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c81019010.operation(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c81019010.sucop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(c81019010.cedop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
end
function c81019010.chainlm(e,rp,tp)
	return tp==rp
end
function c81019010.sucfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)
end
function c81019010.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c81019010.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c81019010.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c81019010.chainlm)
	end
end
function c81019010.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD)
end
function c81019010.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL) and not c:IsLevel(4)
end
function c81019010.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81019010.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function c81019010.afilter(c,code)
	return c:IsCode(code)
end
function c81019010.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c81019010.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local hg=Duel.GetMatchingGroup(c81019010.afilter,tp,LOCATION_HAND,0,nil,g:GetFirst():GetCode())
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end
