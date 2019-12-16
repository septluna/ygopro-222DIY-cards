function c82228548.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_EQUIP)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c82228548.target)  
	e1:SetOperation(c82228548.operation)  
	c:RegisterEffect(e1) 
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228548,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82228548)
	e2:SetCondition(c82228548.thcon)  
	e2:SetTarget(c82228548.thtg)  
	e2:SetOperation(c82228548.thop)  
	c:RegisterEffect(e2) 
	--Equip limit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_EQUIP_LIMIT)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e3:SetValue(c82228548.eqlimit)  
	c:RegisterEffect(e3) 
	--Pierce  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_EQUIP)  
	e4:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e4) 
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCountLimit(1,82218548)
	e5:SetCost(c82228548.cost)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c82228548.atkcon)  
	e5:SetOperation(c82228548.atkop) 
	c:RegisterEffect(e5) 
end  
c82228548.card_code_list={82228540}
function c82228548.eqlimit(e,c)  
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(7)
end  
function c82228548.filter(c)  
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(7) 
end  
function c82228548.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c82228548.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82228548.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)  
	Duel.SelectTarget(tp,c82228548.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)  
end  
function c82228548.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		Duel.Equip(tp,c,tc)  
	end  
end  
function c82228548.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function c82228548.thfilter(c)  
	return aux.IsCodeListed(c,82228540) and not c:IsCode(82228548) and c:IsAbleToHand()  and c:IsType(TYPE_SPELL)
end  
function c82228548.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228548.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228548.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228548.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82228548.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end  
	Duel.DiscardDeck(tp,1,REASON_COST)  
end  
function c82228548.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local ec=e:GetHandler():GetEquipTarget()  
	local tc=ec:GetBattleTarget()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()  
	return ec and tc and tc:IsFaceup() and tc:IsControler(1-tp) and not (atk==0 and def==0) 
end  
function c82228548.atkop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local ec=e:GetHandler():GetEquipTarget()  
	local tc=ec:GetBattleTarget() 
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	if ec and tc and ec:IsFaceup() and tc:IsFaceup() and tc:IsControler(1-tp) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetValue(atk/2)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)  
		local e2=e1:Clone()  
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)  
		e2:SetValue(def/2)
		tc:RegisterEffect(e2)  
	end  
end  