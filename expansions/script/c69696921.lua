--冰寒寡妇蛛
function c69696921.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--disable and reduce ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69696921,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,0x21e0)
	e1:SetCountLimit(1)
	e1:SetCost(c69696921.cost)
	e1:SetTarget(c69696921.tg)
	e1:SetOperation(c69696921.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69696921,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.bdogcon)
	e2:SetTarget(c69696921.sptg)
	e2:SetOperation(c69696921.spop)
	c:RegisterEffect(e2)
end
function c69696921.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttack(0) and c:IsFaceup()
end
function c69696921.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
	local b2=Duel.CheckReleaseGroup(tp,c69696921.cfilter,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(69696921,1),aux.Stringid(69696921,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(69696921,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(69696921,2))+1
	else return end
	if op==0 then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		local g=Duel.SelectReleaseGroup(tp,c69696921.cfilter,1,1,nil)
		Duel.Release(g,REASON_COST)
	end
end
function c69696921.filter(c)
	return c:IsFaceup() and (c:IsAttackAbove(1) or aux.disfilter1(c))
end
function c69696921.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c69696921.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69696921.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c69696921.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c69696921.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
	end
end
function c69696921.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69696922,0,0x4011,0,0,5,RACE_INSECT,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c69696921.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,69696922,0,0x4011,0,0,5,RACE_INSECT,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,69696922)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
