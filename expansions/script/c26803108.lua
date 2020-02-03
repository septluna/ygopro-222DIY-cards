--甜甜圈物语·能代
function c26803108.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c26803108.ffilter,3,true)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c26803108.condition)
	e1:SetCost(c26803108.cost)
	e1:SetOperation(c26803108.operation)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,26803108)
	e3:SetCondition(c26803108.spcon)
	e3:SetTarget(c26803108.sptg)
	e3:SetOperation(c26803108.spop)
	c:RegisterEffect(e3)
end
function c26803108.ffilter(c)
	return c:IsAttack(2200) and c:IsDefense(600)
end
function c26803108.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c26803108.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c26803108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26803108.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c26803108.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c26803108.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c26803108.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c26803108.spfilter(c,e,tp)
	return c:IsAttack(2200) and c:IsDefense(600) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCanBeEffectTarget(e)
end
function c26803108.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26803108.spfilter(chkc,e,tp) end
	local g=Duel.GetMatchingGroup(c26803108.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and g:GetClassCount(Card.GetCode)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,3,0,0)
end
function c26803108.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
