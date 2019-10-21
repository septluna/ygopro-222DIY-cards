--イグニッションP  
function c82221011.initial_effect(c)  
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--atk & def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e2:SetValue(300)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x292))  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)  
	--destroy  
	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_FZONE)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetCountLimit(1,82221011)  
	e4:SetTarget(c82221011.destg)  
	e4:SetOperation(c82221011.desop)  
	c:RegisterEffect(e4)  
	--indes  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e5:SetRange(LOCATION_FZONE)  
	e5:SetTargetRange(LOCATION_MZONE,0)  
	e5:SetTarget(c82221011.indtg)  
	e5:SetValue(aux.indoval)  
	c:RegisterEffect(e5) 
end  
function c82221011.indtg(e,c)  
	return c:IsRace(RACE_WINDBEAST) and c:IsType(TYPE_FUSION)
end  
function c82221011.desfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x292)  
end  
function c82221011.thfilter(c)  
	return c:IsSetCard(0x292) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function c82221011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c82221011.desfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82221011.desfilter,tp,LOCATION_ONFIELD,0,1,nil)  
		and Duel.IsExistingMatchingCard(c82221011.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,c82221011.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221011.desop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local g=Duel.SelectMatchingCard(tp,c82221011.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
		if g:GetCount()>0 then  
			Duel.SendtoHand(g,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,g)  
		end  
	end  
end  