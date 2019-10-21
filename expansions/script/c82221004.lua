function c82221004.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--Draw 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221004,0))  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,82221004)
	e1:SetCondition(c82221004.thcon)  
	e1:SetTarget(c82221004.drtg)  
	e1:SetOperation(c82221004.drop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c82221004.thcon2)
	c:RegisterEffect(e2) 
	--to grave
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221004,1))  
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOGRAVE) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,82231004)  
	e3:SetTarget(c82221004.tgtg)  
	e3:SetOperation(c82221004.tgop)  
	c:RegisterEffect(e3)  
end  
function c82221004.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0  
end  
function c82221004.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA)
end  
function c82221004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function c82221004.drop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
function c82221004.tgfilter(c)  
	return c:IsAbleToGrave()  
end  
function c82221004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221004.tgfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)  
end  
function c82221004.tgop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c82221004.tgfilter,tp,LOCATION_HAND,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end  