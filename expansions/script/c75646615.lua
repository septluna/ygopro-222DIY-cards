--科学的原点 MUPPET
function c75646615.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646615+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c75646615.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2c5))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c75646615.thtg)
	e3:SetOperation(c75646615.thop)
	c:RegisterEffect(e3)
	--change damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c75646615.damcon1)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetTargetRange(0,1)
	e6:SetCondition(c75646615.damcon2)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e7)
	
end
function c75646615.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2c5) and c:IsAbleToHand()
end
function c75646615.deffilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2c5) and c:IsFaceup()
end
function c75646615.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c75646615.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75646615,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)	 
	end 
end
function c75646615.filter(c)
	return c:IsCode(75646600) and c:IsAbleToHand()
end
function c75646615.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646615.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75646615.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646615.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)>0 then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
function c75646615.damcon1(e)
	local tp=e:GetHandlerPlayer()
	local f=Duel.GetFlagEffect(tp,75646600)	
	return f and f>0 and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c75646615.damcon2(e)
	local tp=e:GetHandlerPlayer()
	local f=Duel.GetFlagEffect(tp,75646600)  
	return f and f>0 and Duel.GetLP(1-tp)<Duel.GetLP(tp)
end