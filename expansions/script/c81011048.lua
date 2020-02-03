--夏物语·雨宫文绪
function c81011048.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c81011048.sstg)
	e2:SetOperation(c81011048.ssop)
	c:RegisterEffect(e2)
end
function c81011048.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81011049,0,0x4011,1700,2000,7,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c81011048.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,81011049,0,0x4011,1700,2000,7,RACE_FAIRY,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,81011049)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
		if not c:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		c:ReverseInDeck()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(81011048,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCondition(c81011048.spcon)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
		e1:SetTarget(c81011048.sptg)
		e1:SetOperation(c81011048.spop)
		e1:SetReset(RESET_EVENT+0x1de0000)
		c:RegisterEffect(e1)
	end
end
function c81011048.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c81011048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81011048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.Destroy(c,REASON_EFFECT)==0 then return end
			local lp=Duel.GetFieldGroupCount(1-tp,0,LOCATION_ONFIELD)
			Duel.SetLP(tp,Duel.GetLP(tp)-lp*500)
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		else
			Duel.Destroy(c,REASON_RULE)
		end
	end
end
