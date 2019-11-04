--甜美之花·大崎甘奈
function c26800008.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c26800008.lcheck)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26800008)
	e1:SetTarget(c26800008.remtg)
	e1:SetOperation(c26800008.remop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26800908)
	e2:SetCost(c26800008.spcost)
	e2:SetTarget(c26800008.sptg)
	e2:SetOperation(c26800008.spop)
	c:RegisterEffect(e2)
end
function c26800008.lcheck(g,lc)
	return g:IsExists(c26800008.mzfilter,1,nil)
end
function c26800008.mzfilter(c)
	return (bit.band(c:GetLinkType(),0x81)==0x81 or c:IsLinkType(TYPE_FUSION)) and c:IsLevelBelow(6)
end
function c26800008.remfilter(c)
	return (bit.band(c:GetType(),0x81)==0x81 or c:IsType(TYPE_FUSION)) and c:IsLevelBelow(6) and c:IsAbleToGrave()
end
function c26800008.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26800008.remfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c26800008.remfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK+LOCATION_EXTRA)
end
function c26800008.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26800008.remfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c26800008.remfilter,tp,LOCATION_EXTRA,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end
function c26800008.cfilter(c,tp)
	return (bit.band(c:GetType(),0x81)==0x81 or c:IsType(TYPE_FUSION)) and c:IsLevelBelow(6) and Duel.GetMZoneCount(tp,c)>0
end
function c26800008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c26800008.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c26800008.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c26800008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26800008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
