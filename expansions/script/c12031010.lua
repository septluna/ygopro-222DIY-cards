--小黑
function c12031010.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12031010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,12031010)
	e1:SetCondition(c12031010.thcon)
	e1:SetTarget(c12031010.thtg)
	e1:SetOperation(c12031010.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(12031010,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12031010+100)
	e2:SetCost(c12031010.descost)
	e2:SetTarget(c12031010.destg)
	e2:SetOperation(c12031010.desop)
	c:RegisterEffect(e2)
end
function c12031010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c12031010.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfa0) and c:IsAbleToHand()
end
function c12031010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12031010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12031010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12031010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12031010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12031010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c12031010.bafilter(c)
	return c:IsCode(12031000) and c:IsFaceup()
end
function c12031010.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		local gg=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,1,nil)
		if gg:GetCount()>0 then
			tc=gg:GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			local code=tc:GetOriginalCode()
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetCode(EFFECT_CHANGE_CODE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(code)
			tg:RegisterEffect(e2)
			Duel.BreakEffect()
			local cc=Duel.GetMatchingGroupCount(c12031010.bafilter,tp,LOCATION_MZONE,0,nil)
			if cc>0 then
				Duel.Draw(tp,cc,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.DiscardHand(tp,nil,cc,cc,REASON_EFFECT+REASON_DISCARD,nil)
			end
		end
	end
end