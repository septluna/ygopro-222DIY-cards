--丰作之地
c11200039.card_code_list={11200029}
function c11200039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c11200039.drcon)
	e2:SetTarget(c11200039.drtg)
	e2:SetOperation(c11200039.drop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,11200039)
	e3:SetTarget(c11200039.sptg)
	e3:SetOperation(c11200039.spop)
	c:RegisterEffect(e3)
end
function c11200039.cfilter(c)
	return aux.IsCodeListed(c,11200029) and not c:IsCode(11200039) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c11200039.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11200039.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function c11200039.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local turnp=Duel.GetTurnPlayer()
	Duel.SetTargetPlayer(turnp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,turnp,1200)
end
function c11200039.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c11200039.spfilter(c,e,tp)
	return c:IsCode(11200029) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11200039.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c11200039.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11200039.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
