--崩坏神格 海姆达尔
c75646260.dfc_front_side=75646260
c75646260.dfc_back_side=75646264
function c75646260.initial_effect(c)
	aux.AddCodeList(c,75646000,75646150,75646260,75646208)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75646260.target)
	e1:SetOperation(c75646260.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetCondition(c75646260.atkcon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c75646260.cost)
	e3:SetCondition(c75646260.con)
	e3:SetTarget(c75646260.tg)
	e3:SetOperation(c75646260.op)
	c:RegisterEffect(e3)	 
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c75646260.eqlimit)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(3,75646150)
	e5:SetCost(c75646260.thcost)
	e5:SetTarget(c75646260.thtg)
	e5:SetOperation(c75646260.thop)
	c:RegisterEffect(e5)
	--Change
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(75646260,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCost(c75646260.chcost)
	e7:SetTarget(c75646260.changetg)
	e7:SetOperation(c75646260.changeop)
	c:RegisterEffect(e7)
end
c75646260.card_code_list={75646000,75646150,75646260,75646208}
function c75646260.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646260.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
end
function c75646260.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75646260.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646260.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c75646260.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c75646260.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
		e:GetHandler():AddCounter(0x1b,2)
	end
end
function c75646260.atkcon(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646260.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1b,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1b,1,REASON_COST)
end
function c75646260.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return (Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc)
		and e:GetHandler():GetCounter(0x1b)>0
end
function c75646260.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c75646260.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	for i=e:GetHandler():GetFlagEffect(75646260),5 do
		Duel.Damage(1-tp,200,REASON_EFFECT)  
		e:GetHandler():RegisterFlagEffect(75646260,RESET_EVENT+RESET_CHAIN,0,0)
	end
end
function c75646260.cfilter(c)
	return aux.IsCodeListed(c,75646000) and c:IsAbleToRemoveAsCost()
end
function c75646260.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75646260.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646260.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75646260.thfilter(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToHand()
end
function c75646260.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646260.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646260.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646260.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646260.costfilter(c)
	return c:IsCode(75646266) and c:IsAbleToGraveAsCost()
end
function c75646260.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646260.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c75646260.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
end
function c75646260.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c75646260.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.Equip(tp,c,e:GetHandler():GetEquipTarget(),true)
	c:AddCounter(0x1b,2)
end
