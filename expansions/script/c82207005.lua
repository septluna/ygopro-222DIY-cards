local m=82207005
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
	--atk&def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e2:SetTarget(aux.TargetBoolFunction(cm.filter))  
	e2:SetValue(500)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)  
end
 
function cm.thfilter(c)  
	return c:IsCode(82207000) and c:IsAbleToHand()  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end  
function cm.filter(c)  
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0  
end
