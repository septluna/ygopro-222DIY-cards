--水歌 永奏的希亚丝
function c12003012.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c12003012.lcheck)
	c:EnableReviveLimit()
	--sps
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003012,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12003112)
	e1:SetCost(c12003012.discost)
	e1:SetOperation(c12003012.operation1)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12003012,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,12003112)
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c12003012.cfilter1,tp,LOCATION_HAND,0,1,nil,tp) end
		local g1=Duel.SelectMatchingCard(tp,c12003012.cfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.Release(g1,REASON_COST)
	end)
	e4:SetTarget(c12003012.target)
	e4:SetOperation(c12003012.operation)
	c:RegisterEffect(e4)
end
function c12003012.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==1 and g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c12003012.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.DiscardDeck(tp,3,REASON_COST)
end
function c12003012.operation1(e,tp,eg,ep,ev,re,r,rp)
	local oc=Duel.GetOperatedGroup()
	local sg=oc:Filter(Card.IsRace,nil,RACE_SEASERPENT)
	if sg:GetCount()>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(12003012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12003212)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckReleaseGroup(tp,c12003012.cfilter1,1,nil,tp) end
		local g1=Duel.SelectReleaseGroup(tp,c12003012.cfilter1,1,1,nil,tp)
		Duel.Release(g1,REASON_COST)
	end) 
	e2:SetTarget(c12003012.sptg)
	e2:SetOperation(c12003012.spop)
	e:GetHandler():RegisterEffect(e2)
	end
end
function c12003012.cfilter1(c,e,tp)
	return c:IsRace(RACE_SEASERPENT) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c),c)>0
end
function c12003012.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCode(12003010,12003003) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c12003012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c12003012.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12003012.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12003012.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c12003012.filter(c)
	return c:IsSetCard(0xfb8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12003012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12003012.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12003012.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12003012.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end
