--神楽七奈
function c10907006.initial_effect(c)	
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10907006.FusFilter1,c10907006.FusFilter2,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10907006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10907006)
	e1:SetTarget(c10907006.hsptg)
	e1:SetOperation(c10907006.hspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(10907006,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10907006.con)
	e2:SetTarget(c10907006.target1)
	e2:SetOperation(c10907006.operation1)
	c:RegisterEffect(e2)
end
function c10907006.FusFilter1(c)
	return c:IsSetCard(0x32c4) and c:IsType(TYPE_TUNER)
end
function c10907006.FusFilter2(c)
	return c:IsRace(RACE_FAIRY)
end
function c10907006.filter(c,e,sp)
	return c:GetCode()==10907002 and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c10907006.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10907006.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10907006.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10907006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10907006.cfilter(c)
	return c:IsFaceup() and c:GetCode()==10907002
end
function c10907006.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10907006.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10907006.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10907006.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end