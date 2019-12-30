--砂冢明音·回溯
function c81013003.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c81013003.spcon)
	e0:SetOperation(c81013003.spop)
	c:RegisterEffect(e0)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(81011027)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81013003)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c81013003.thtg)
	e2:SetOperation(c81013003.thop)
	c:RegisterEffect(e2)
end
function c81013003.spfilter(c)
	return (bit.band(c:GetOriginalType(),TYPE_SPELL)~=0 or bit.band(c:GetOriginalType(),TYPE_TRAP)~=0) and c:IsAbleToGraveAsCost()
end
function c81013003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	if ft<=0 then
		local ct=-ft+1
		return Duel.IsExistingMatchingCard(c81013003.spfilter,tp,LOCATION_MZONE,0,ct,nil)
			and Duel.IsExistingMatchingCard(c81013003.spfilter,tp,LOCATION_ONFIELD,0,2,nil)
	else
		return Duel.IsExistingMatchingCard(c81013003.spfilter,tp,LOCATION_ONFIELD,0,2,nil)
	end
end
function c81013003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.GetMatchingGroup(c81013003.spfilter,tp,LOCATION_ONFIELD,0,nil)
		local ct=-ft+1
		local g1=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<2 then
			sg:Sub(g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=sg:Select(tp,2-ct,2-ct,nil)
			g1:Merge(g2)
		end
		Duel.SendtoGrave(g1,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c81013003.spfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c81013003.thfilter(c)
	return (bit.band(c:GetOriginalType(),TYPE_SPELL)~=0 or bit.band(c:GetOriginalType(),TYPE_TRAP)~=0) and c:IsAbleToHand()
end
function c81013003.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c81013003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c81013003.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81013003.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c81013003.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81013003.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81013003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local sg=Duel.GetMatchingGroup(c81013003.tgfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
