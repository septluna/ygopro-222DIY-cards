--When the rain
local m=81006011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.desfilter1(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
end
function cm.desfilter2(c,mc)
	return c:IsFaceup() and c:IsCode(mc:GetCode())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cm.desfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,cm.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	local g2=Duel.GetMatchingGroup(cm.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g1,g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc,tc)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)==0 then
				local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
					if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:Select(tp,1,1,nil)
					Duel.HintSelection(sg)
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
		end
	end
end
