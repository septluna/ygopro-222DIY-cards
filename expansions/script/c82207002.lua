local m=82207002
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),11,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)  
	c:EnableReviveLimit() 
	--todeck  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetCountLimit(1)  
	e3:SetTarget(cm.tdtg)  
	e3:SetOperation(cm.tdop)  
	c:RegisterEffect(e3) 
end
function cm.cfilter(c)  
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemoveAsCost()  
end  
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsCode(82207000)  
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,82207002)==0 end  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,82207002,RESET_PHASE+PHASE_END,0,1)  
end  
function cm.tdfilter(c)  
	return c:IsFacedown() and c:IsAbleToDeck()  
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and cm.tdfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)  
	Duel.SetChainLimit(cm.chlimit)  
end  
function cm.chlimit(e,ep,tp)  
	return tp==ep 
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)  
	end  
end  