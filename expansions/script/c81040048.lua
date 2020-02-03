--天涯旅人·周子
function c81040048.initial_effect(c)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81040048)
	e1:SetCondition(c81040048.drcon)
	e1:SetTarget(c81040048.drtg)
	e1:SetOperation(c81040048.drop)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81040948)
	e2:SetCondition(c81040048.tgcon)
	e2:SetTarget(c81040048.tgtg)
	e2:SetOperation(c81040048.tgop)
	c:RegisterEffect(e2)
end
function c81040048.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c81040048.tgfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToGrave()
end
function c81040048.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040048.tgfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function c81040048.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		local sg=Duel.GetMatchingGroup(c81040048.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
function c81040048.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81040048.tgfilter1(c,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and (c:IsSetCard(0x81c) and c:IsType(TYPE_MONSTER) and not c:IsCode(81040048))
		and Duel.IsExistingMatchingCard(c81040048.tgfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c81040048.tgfilter2(c,cd)
	return c:IsCode(cd) and c:IsAbleToGrave()
end
function c81040048.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsCode(e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c81040048.tgfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81040048.tgfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81040048.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c81040048.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
