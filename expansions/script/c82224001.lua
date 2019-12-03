function c82224001.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_EQUIP)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c82224001.target)  
	e1:SetOperation(c82224001.activate)  
	c:RegisterEffect(e1)  
	--equip limit  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_EQUIP_LIMIT)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetValue(1)  
	c:RegisterEffect(e2)
	--destroy 
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c82224001.descon)  
	e3:SetOperation(c82224001.desop)	
	c:RegisterEffect(e3)   
	--to grave  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e4:SetCode(EVENT_TO_GRAVE)   
	e4:SetOperation(c82224001.regop)  
	c:RegisterEffect(e4)  
end 
function c82224001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)  
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)  
end  
function c82224001.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		Duel.Equip(tp,e:GetHandler(),tc)  
	end  
end  
function c82224001.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()  
	local tc=ec:GetBattleTarget()  
	return tc and tc:IsRelateToBattle()  
end  
function c82224001.desop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget() 
	local tc=ec:GetBattleTarget()
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(82224001,0))
	Duel.Destroy(tc,REASON_EFFECT)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(82224001,0))
end  
function c82224001.regop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetRange(LOCATION_GRAVE)  
	e1:SetCountLimit(1,82224001)
	e1:SetCondition(c82224001.thcon)  
	e1:SetTarget(c82224001.thtg)  
	e1:SetOperation(c82224001.thop)  
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
	c:RegisterEffect(e1)  
end  
function c82224001.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)  
end 
function c82224001.filter(c)  
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()  
end  
function c82224001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82224001.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  

function c82224001.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82224001.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  