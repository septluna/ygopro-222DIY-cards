 --少女分形·隐思之瞳
function c98610008.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c98610008.ffilter,6,2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98610008,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCost(c98610008.tgcost)
	e1:SetTarget(c98610008.tgtg)
	e1:SetOperation(c98610008.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(98610008,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98610008)
	e2:SetCondition(c98610008.tpcon)
	e2:SetTarget(c98610008.tptg)
	e2:SetOperation(c98610008.tpop)
	c:RegisterEffect(e2)
end
function c98610008.ffilter(c)
	return c:IsSetCard(0x870)and c:IsType(TYPE_MONSTER) 
end
function c98610008.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98610008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil,REASON_EFFECT)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,nil,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil,REASON_EFFECT)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c98610008.tgfilter(c,e)
	return  c:IsRelateToEffect(e)
end
function c98610008.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(c98610008.tgfilter,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c98610008.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)and re and re:GetHandler():IsSetCard(0x870)
end
function c98610008.tfilter(c)
	return c:IsSetCard(0x870)and  c:IsFaceup()
end
function c98610008.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c98610008.tfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98610008.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c98610008.tfilter,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	    local g=Duel.SelectMatchingCard(tp,c98610008.tfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		   Duel.Overlay(c,Group.FromCards(g:GetFirst()))
		end
	end
end