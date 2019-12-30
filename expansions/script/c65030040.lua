--祸摆启生者 玛丽
function c65030040.initial_effect(c)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c65030040.pdop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0)
   --deck sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c65030040.cost)
	e2:SetTarget(c65030040.target)
	e2:SetOperation(c65030040.activate)
	c:RegisterEffect(e2)
	--pandolum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,65030040)
	e4:SetRange(LOCATION_HAND)  
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c65030040.con)
	e4:SetTarget(c65030040.tg)
	e4:SetOperation(c65030040.op)
	c:RegisterEffect(e4)
end
function c65030040.confil(c)
	return c:IsSetCard(0x3da9) and c:IsPreviousLocation(LOCATION_MZONE) and (c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) or c:IsPreviousPosition(POS_FACEUP))
end
function c65030040.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65030040.confil,1,nil)
end
function c65030040.spf1(c)
	return c:IsSetCard(0x3da9) and c:IsType(TYPE_MONSTER)
end
function c65030040.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local spg=Duel.GetMatchingGroup(c65030040.spf1,tp,LOCATION_GRAVE,0,nil)
	local spg2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	spg:Merge(spg2)
	if chk==0 then return spg:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65030040.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local spg=Duel.GetMatchingGroup(c65030040.spf1,tp,LOCATION_GRAVE,0,nil)
	local spg2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	spg:Merge(spg2)
	local ft=Duel.GetMZoneCount(tp)
	local num=eg:FilterCount(c65030040.confil,nil)
	if num>ft then num=ft end
	local g=spg:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,num,nil,e,0,tp,false,false)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(65030040,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c65030040.pdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.GetControl(e:GetHandler(),1-tp)
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end

function c65030040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65030040.filter(c,e,tp)
	return c:IsSetCard(0x3da9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65030040.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65030040.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65030040.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end