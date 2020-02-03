--Abyss
function c81012057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81012057+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81012057.condition)
	e1:SetCost(c81012057.cost)
	e1:SetTarget(c81012057.target)
	e1:SetOperation(c81012057.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(81012057,ACTIVITY_SUMMON,c81012057.counterfilter)
	Duel.AddCustomActivityCounter(81012057,ACTIVITY_SPSUMMON,c81012057.counterfilter)
	Duel.AddCustomActivityCounter(81012057,ACTIVITY_FLIPSUMMON,c81012057.counterfilter)
end
function c81012057.counterfilter(c)
	return c:IsRace(RACE_PYRO)
end
function c81012057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81012057,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(81012057,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(81012057,tp,ACTIVITY_FLIPSUMMON)==0 end
	if chk==0 then return  end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81012057.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c81012057.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PYRO)
end
function c81012057.cfilter(c)
	return c:IsRace(RACE_PYRO)
end
function c81012057.cfilter2(c)
	return c:IsFacedown() or not c:IsRace(RACE_PYRO)
end
function c81012057.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81012057.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c81012057.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c81012057.thfilter(c)
	return (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_SPELL))
end
function c81012057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81012057.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c81012057.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81012057.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
