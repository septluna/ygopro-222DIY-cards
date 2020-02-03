--刻刻帝-喰时之城
local m=33400100
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableCounterPermit(0x34f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(cm.counter)
	c:RegisterEffect(e2)
	 --atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
   local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
--damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetOperation(cm.ctp)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetOperation(cm.ctop)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
end
function cm.atkval(e)
	return Duel.GetMatchingGroupCount(cm.PD,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*-100
end
function cm.PD(c)
	return c:IsSetCard(0x3340) or c:IsSetCard(0x3341)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x34f,ct,true)
	end
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.filter(c)
	return c:IsCode(33400113) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function cm.ctp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x34f)
	e:SetLabel(ct)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x34f,1)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 and Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local tc=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		tc:AddCounter(0x34f,ct)
	end
end