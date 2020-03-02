--绀海之灵 希儿
function c75646956.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646956,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75646956.target)
	e1:SetOperation(c75646956.operation)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646956,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+75646956)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCountLimit(1,75646956)
	e3:SetTarget(c75646956.thtg)
	e3:SetOperation(c75646956.thop)
	c:RegisterEffect(e3)
	if not c75646956.global_check then
		c75646956.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_NEGATED)
		ge1:SetCondition(c75646956.checkcon)
		ge1:SetOperation(c75646956.checkop) 
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetCondition(c75646956.ngcon)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetOperation(c75646956.tdop1)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetOperation(c75646956.tdop2)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge1:Clone()
		ge5:SetCode(EVENT_TO_DECK)
		ge5:SetCondition(c75646956.tdcon)
		Duel.RegisterEffect(ge5,0)
	end
end
function c75646956.sfilter(c,e)
	return c==e:GetHandler()
end
function c75646956.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646956.sfilter,1,nil,e)
end
function c75646956.ngcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function c75646956.tdop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(5646956)
end
function c75646956.tdop2(e,tp,eg,ep,ev,re,r,rp)  
	e:GetHandler():RegisterFlagEffect(5646956,0,0,1)
end
function c75646956.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(5646956)==0 and eg:IsExists(c75646956.sfilter,1,nil,e)
end
function c75646956.checkop(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandlerPlayer()
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+75646956,e,0,0,tp,0)
end
function c75646956.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c75646956.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c75646956.filter(c)
	return c:IsSetCard(0xa2c2) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
		and c:IsAbleToHand()
end
function c75646956.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646956.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646956.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646956.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end