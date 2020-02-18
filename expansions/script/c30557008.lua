--连言推理分解式
function c30557008.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c30557008.condition)
	e1:SetCost(c30557008.cost)
	e1:SetTarget(c30557008.target)
	e1:SetOperation(c30557008.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c30557008.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c30557008.thtg)
	e2:SetOperation(c30557008.thop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c30557008.actcon)
	c:RegisterEffect(e3)
end
function c30557008.actcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
end
function c30557008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c30557008.thtgfil(c,tp)
	return c:IsAbleToExtra() and Duel.IsExistingMatchingCard(c30557008.thfil,tp,LOCATION_GRAVE,0,1,c) and c:IsSetCard(0x306) and c:IsType(TYPE_FUSION)
end
function c30557008.thfil(c)
	return c:IsSetCard(0x306) and c:IsAbleToHand()
end
function c30557008.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c30557008.thtgfil(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c30557008.thtgfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c30557008.thtgfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c30557008.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	local num=lv/3
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c30557008.thfil,tp,LOCATION_GRAVE,0,1,num,tc)
		if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end

function c30557008.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9e)
end
function c30557008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
		and (re:GetActivateLocation()==LOCATION_HAND or re:GetActivateLocation()==LOCATION_GRAVE) and Duel.IsChainNegatable(ev) and re:GetHandlerPlayer()~=tp and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c30557008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c30557008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c30557008.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9e)
end
function c30557008.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) and ec:IsDestructable() and Duel.Destroy(ec,REASON_EFFECT)~=0 and ec:IsControler(1-tp) and not ec:IsLocation(LOCATION_HAND+LOCATION_DECK)
		and not ec:IsHasEffect(EFFECT_NECRO_VALLEY) and g:GetFirst():IsSetCard(0x306) then
		if ec:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not ec:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,nil,ec)>0)
			and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(30557008,0)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(ec,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,ec)
		elseif (ec:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and ec:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(30557008,0)) then
			Duel.BreakEffect()
			Duel.SSet(tp,ec)
		end
	end
end
