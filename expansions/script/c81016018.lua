--望月杏奈的圣诞号
function c81016018.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81016018,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81016018+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81016018.actcon)
	e1:SetTarget(c81016018.tgtg)
	e1:SetOperation(c81016018.tgop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81016018,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,81016018+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c81016018.actcon)
	e2:SetTarget(c81016018.thtg)
	e2:SetOperation(c81016018.thop)
	c:RegisterEffect(e2)
end
function c81016018.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c81016018.lmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81d)
end
function c81016018.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c81016018.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81016018.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c81016018.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	if Duel.IsExistingMatchingCard(c81016018.lmfilter,tp,LOCATION_MZONE,0,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c81016018.chainlm)
	end
end
function c81016018.chainlm(e,rp,tp)
	return tp==rp
end
function c81016018.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81016018.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c81016018.thfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c81016018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81016018.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	if Duel.IsExistingMatchingCard(c81016018.lmfilter,tp,LOCATION_MZONE,0,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c81016018.chainlm)
	end
end
function c81016018.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c81016018.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
