--花寄女子寮
function c10907000.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(c10907000.defilter))
	e2:SetValue(1000)
	c:RegisterEffect(e2)   
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10907000,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,10907000)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c10907000.thtg)
	e3:SetOperation(c10907000.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10907000,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10907000.con)
	e4:SetTarget(c10907000.target)
	e4:SetOperation(c10907000.operation)
	c:RegisterEffect(e4)
end
function c10907000.defilter(c)
	return c:IsSetCard(0x23a) or c:IsSetCard(0x32c4) 
end
function c10907000.filter(c)
	return c:IsSetCard(0x23a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10907000.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c10907000.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10907000.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10907000.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10907000.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c10907000.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23a)
end
function c10907000.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10907000.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c10907000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c10907000.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end