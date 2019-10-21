--新人登场·二宫飞鸟
function c81009032.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,81009032)
	e1:SetCondition(c81009032.spcon)
	e1:SetCost(c81009032.spcost)
	e1:SetTarget(c81009032.sptg)
	e1:SetOperation(c81009032.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(81009032,ACTIVITY_SPSUMMON,c81009032.counterfilter)
end
function c81009032.counterfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c81009032.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81009032,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81009032.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c81009032.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_DRAGON
end
function c81009032.spfilter(c,tp)
	return c:IsControler(tp) and c:IsRace(RACE_DRAGON) and c:IsLevel(7) and c:IsFaceup()
end
function c81009032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81009032.spfilter,1,nil,tp)
end
function c81009032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81009032.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
