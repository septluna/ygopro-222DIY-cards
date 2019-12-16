function c82228544.initial_effect(c)  
	c:EnableCounterPermit(0x1)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228544,0))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82228544)
	e2:SetCondition(c82228544.thcon)  
	e2:SetTarget(c82228544.thtg)  
	e2:SetOperation(c82228544.thop)  
	c:RegisterEffect(e2) 
	--Add counter  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e3:SetCode(EVENT_CHAIN_SOLVING)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetOperation(c82228544.op)  
	c:RegisterEffect(e3)  
	--disable search  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_CANNOT_TO_HAND)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c82228544.dscon)
	e4:SetTargetRange(0,1)  
	e4:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))  
	c:RegisterEffect(e4)  
	--Destroy replace  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e5:SetCode(EFFECT_DESTROY_REPLACE)  
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e5:SetRange(LOCATION_SZONE)  
	e5:SetTarget(c82228544.desreptg)  
	e5:SetOperation(c82228544.desrepop)  
	c:RegisterEffect(e5) 
end
c82228544.card_code_list={82228540}
function c82228544.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=re:GetHandler()  
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and c~=e:GetHandler() then  
		e:GetHandler():AddCounter(0x1,1)  
	end  
end  
function c82228544.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and not e:GetHandler():IsReason(REASON_REPLACE) 
		and e:GetHandler():GetCounter(0x1)>0 end  
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)  
end  
function c82228544.desrepop(e,tp,eg,ep,ev,re,r,rp)  
	e:GetHandler():RemoveCounter(ep,0x1,1,REASON_EFFECT)  
end  
function c82228544.dscon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetCounter(0x1)>2
end  
function c82228544.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function c82228544.thfilter(c)  
	return aux.IsCodeListed(c,82228540) and not c:IsCode(82228544) and c:IsAbleToHand()  and c:IsType(TYPE_SPELL)
end  
function c82228544.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228544.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228544.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228544.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  