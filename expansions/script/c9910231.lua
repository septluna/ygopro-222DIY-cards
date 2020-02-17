--逆袭之斗兽 鸢泽美咲
function c9910231.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c9910231.lfilter,2,99,c9910231.lcheck)
	c:EnableReviveLimit()
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c9910231.effcon)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c9910231.drcost)
	e3:SetTarget(c9910231.drtg)
	e3:SetOperation(c9910231.drop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(c9910231.spcon)
	e4:SetTarget(c9910231.sptg)
	e4:SetOperation(c9910231.spop)
	c:RegisterEffect(e4)
end
function c9910231.lfilter(c)
	return c:IsLinkAttribute(ATTRIBUTE_WIND) and c:IsLinkType(TYPE_LINK)
end
function c9910231.lcheck(g)
	return g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP_LEFT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP_RIGHT)
		and g:IsExists(Card.IsLinkSetCard,1,nil,0x955)
end
function c9910231.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910231.costfilter(c,mc)
	local lg=mc:GetLinkedGroup()
	return lg:IsContains(c) and c:IsAbleToRemoveAsCost()
end
function c9910231.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910231.costfilter,tp,0,LOCATION_MZONE,1,c,c)
		and c:IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910231.costfilter,tp,0,LOCATION_MZONE,1,1,c,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910231.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c9910231.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c9910231.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c9910231.spfilter(c,e,tp)
	return c:IsSetCard(0x955) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910231.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910231.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c9910231.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910231.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
