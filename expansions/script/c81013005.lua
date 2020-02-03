--日出·樱庭小梅
function c81013005.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,81013005)
	e1:SetCondition(c81013005.atkcon)
	e1:SetCost(c81013005.atkcost)
	e1:SetOperation(c81013005.atkop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,81013006)
	e2:SetTarget(c81013005.sptg)
	e2:SetOperation(c81013005.spop)
	c:RegisterEffect(e2)
end
function c81013005.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c81013005.cfilter(c)
	return c:IsAttack(1750) and c:IsDefense(1350)
end
function c81013005.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c81013005.cfilter,1,nil,nil) end
	local g=Duel.SelectReleaseGroup(tp,c81013005.cfilter,1,1,nil,nil)
	Duel.Release(g,REASON_COST)
end
function c81013005.atkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		if Duel.SelectYesNo(tp,aux.Stringid(81013005,0)) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c81013005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81013006,0,0x4011,1750,1350,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81013005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,81013006,0,0x4011,1750,1350,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,81013006)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
