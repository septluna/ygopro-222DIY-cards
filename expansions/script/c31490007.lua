local m=31490007
local cm=_G["c"..m]
cm.name="苍燧烽后 古蒂妮"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	local ep=Effect.CreateEffect(c)
	ep:SetDescription(1160)
	ep:SetType(EFFECT_TYPE_ACTIVATE)
	ep:SetCode(EVENT_FREE_CHAIN)
	ep:SetRange(LOCATION_HAND)
	ep:SetOperation(cm.pactop)
	ep:SetCountLimit(1,31490007)
	c:RegisterEffect(ep)
end
function cm.actfilter(c)
	return c:GetLeftScale()==7 and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function cm.pactop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	tc:AddCounter(0x5310,2)
	Duel.BreakEffect()
	local ffcount=Duel.GetCounter(tp,LOCATION_SZONE,0,0x5310)
	local field=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if field then
		ffcount=ffcount-field:GetCounter(0x5310)
	end
	if ffcount>=4 and Duel.IsExistingMatchingCard(cm.actfilter,tp,0,LOCATION_DECK,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(31490007,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,0,LOCATION_DECK,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end