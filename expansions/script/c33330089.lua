--水宫残照
function c33330089.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33330089)
	e1:SetCost(c33330089.cost)
	e1:SetOperation(c33330089.operation)
	c:RegisterEffect(e1)
end
function c33330089.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33330089.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   --G
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c33330089.drcon1)
	e1:SetOperation(c33330089.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DISCARD)
	e2:SetCondition(c33330089.drcon2)
	Duel.RegisterEffect(e2,tp)
	--limit
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c33330089.splimit)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c33330089.splimit)
	Duel.RegisterEffect(e4,tp)
end
function c33330089.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsLocation(LOCATION_HAND)
end
function c33330089.filter(c,re,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_COST) and re:GetHandler()==c and not c:IsReason(REASON_DISCARD)
end
function c33330089.filter2(c,re,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_COST) and re:GetHandler()==c
end
function c33330089.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33330089.filter,1,nil,re,tp)
end
function c33330089.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33330089.filter2,1,nil,re,tp)
end
function c33330089.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end