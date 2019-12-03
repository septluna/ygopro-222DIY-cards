--甜美之花·大崎甜花
function c81000003.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c81000003.lcheck)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81000003)
	e1:SetCondition(c81000003.thcon)
	e1:SetTarget(c81000003.thtg)
	e1:SetOperation(c81000003.thop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81000003.splimit)
	c:RegisterEffect(e2)
	--ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCountLimit(1,81000903)
	e3:SetCondition(c81000003.spcondition)
	e3:SetCost(c81000003.spcost)
	e3:SetTarget(c81000003.sptg)
	e3:SetOperation(c81000003.spop)
	c:RegisterEffect(e3)
end
function c81000003.lcheck(g,lc)
	return g:IsExists(c81000003.mzfilter,1,nil)
end
function c81000003.mzfilter(c)
	return c:IsLinkType(TYPE_RITUAL) and c:IsLinkType(TYPE_PENDULUM)
end
function c81000003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c81000003.thfilter(c)
	return c:GetType()==0x82 and c:IsAbleToHand()
end
function c81000003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81000003.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81000003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81000003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81000003.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_PENDULUM) and bit.band(sumtype,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c81000003.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (bit.band(r,REASON_BATTLE)~=0 or (bit.band(r,REASON_EFFECT)~=0 and rp==1-tp))
end
function c81000003.cfilter(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c81000003.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>0
end
function c81000003.spfilter(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsType(TYPE_PENDULUM) and c:IsLevel(4,8) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c81000003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c81000003.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c81000003.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c81000003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81000003.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81000003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81000003.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) then
		tc:CompleteProcedure()
	end
end
