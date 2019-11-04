--小小的谜团 茶芽子
function c33330095.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330095,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33330095)
	e1:SetCost(c33330095.cost)
	e1:SetTarget(c33330095.tg)
	e1:SetOperation(c33330095.op)
	c:RegisterEffect(e1)
	--Move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330095,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c33330095.mvtg)
	e2:SetOperation(c33330095.mvop)
	c:RegisterEffect(e2)
end
function c33330095.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c33330095.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end

function c33330095.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c33330095.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return lg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c33330095.spfil(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c33330095.op(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	if lg and Duel.Destroy(lg,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		if Duel.IsExistingMatchingCard(c33330095.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,g) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(33330095,2)) then
			local g=Duel.SelectMatchingCard(tp,c33330095.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,g)
			Duel.SpecialSummon(g,0,tp,false,false,POS_FACEUP)
		end
	end
end