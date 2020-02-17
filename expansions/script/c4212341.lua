--罗罗娜的工作室-库蝶莉亚
function c4212341.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4212341,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c4212341.tftg)
	e1:SetOperation(c4212341.tfop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4212341,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,4212341)
	e2:SetCost(c4212341.cost)
	e2:SetTarget(c4212341.sptg)
	e2:SetOperation(c4212341.spop)
	c:RegisterEffect(e2)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(4212301)
	c:RegisterEffect(e3)
end
function c4212341.cfilter(c) 
	return (c:IsCode(4212301) or c:IsCode(4212306)) and c:IsAbleToHand()
end
function c4212341.tgfilter(c) 
	return c:IsFaceup() and c:IsSetCard(0xa25)
end
function c4212341.thfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xa25) and not c:IsForbidden() and not c:IsType(TYPE_FIELD) and c:CheckUniqueOnField(tp) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c4212341.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212341.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4212341.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4212341.cfilter,tp,LOCATION_DECK,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c4212341.cost(e,tp,eg,ep,ev,re,r,rp,chk)--return to hand as cost
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c4212341.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c4212341.tgfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c4212341.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c4212341.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		if Duel.Destroy(tg,REASON_EFFECT) and Duel.IsExistingMatchingCard(c4212341.thfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=0 then
		   if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212341,2)) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			   local g=Duel.SelectMatchingCard(tp,c4212341.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
			   if g:GetCount()>0 then
				   Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			   end
		   end
		end
	end
end