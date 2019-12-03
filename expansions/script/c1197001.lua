--受托之愿·梅特蕾
function c1197001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1197001)
	e1:SetTarget(c1197001.tg1)
	e1:SetOperation(c1197001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1197001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1197001+500)
	e2:SetCondition(c1197001.con2)
	e2:SetCost(c1197001.cost2)
	e2:SetTarget(c1197001.tg2)
	e2:SetOperation(c1197001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1197001.tfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToHand()
		and c:IsRace(RACE_SEASERPENT) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c1197001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1197001.tfilter(chkc,tp) end
	if chk==0 then
		return Duel.GetMZoneCount(tp)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(c1197001.tfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c1197001.tfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1197001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		if Duel.GetMZoneCount(tp)<1 then return end
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
				c:RegisterFlagEffect(1197001,RESET_EVENT+0x1fe0000,0,1)
				Duel.SpecialSummonComplete()
			end
		end
	end
end
--
function c1197001.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1197001)>0
end
--
function c1197001.cfilter2(c,tc)
	return (c==tc and c:IsReleasable()) or (c:IsLocation(LOCATION_HAND) and c:IsDiscardable() and c:IsRace(RACE_SEASERPENT))
end
function c1197001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1197001.cfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c1197001.cfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,c)
	if c==g:GetFirst() then Duel.Release(g,REASON_COST)
	else Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST) end
end
--
function c1197001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1197001.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--
