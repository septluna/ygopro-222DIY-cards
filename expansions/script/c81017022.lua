--阳光海滩·高山纱代子
function c81017022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),6,4)
	c:EnableReviveLimit()
	--disable spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,1)
	e0:SetTarget(c81017022.sumlimit)
	e0:SetCondition(c81017022.dscon)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81017022,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,81017022)
	e1:SetCost(c81017022.tgcost)
	e1:SetTarget(c81017022.tgtg)
	e1:SetOperation(c81017022.tgop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81017022,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81017922)
	e2:SetCondition(c81017022.spcon)
	e2:SetTarget(c81017022.sptg)
	e2:SetOperation(c81017022.spop)
	c:RegisterEffect(e2)
end
function c81017022.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c81017022.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsRace(RACE_FAIRY)
end
function c81017022.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81017022.tgfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function c81017022.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81017022.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c81017022.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c81017022.tgop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c81017022.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c81017022.cfilter(c,tp)
	return c:GetPreviousRaceOnField()==RACE_FAIRY and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c81017022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81017022.cfilter,1,nil,1-tp)
end
function c81017022.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsSetCard(0x819) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81017022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81017022.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c81017022.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FAIRY) and c:IsAbleToRemove()
end
function c81017022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81017022.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ng=Duel.GetMatchingGroup(aux.NecroValleyFilter(c81017022.rmfilter),tp,0,LOCATION_GRAVE,nil)
		if ng:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81017022,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=ng:Select(tp,1,3,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
