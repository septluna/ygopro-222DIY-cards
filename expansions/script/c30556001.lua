--空中都市-[艾拉01]-
function c30556001.initial_effect(c)
	  --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c30556001.condition)
	e1:SetTarget(c30556001.target)
	e1:SetOperation(c30556001.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c30556001.con)
	e2:SetTarget(c30556001.tg)
	e2:SetOperation(c30556001.op)
	c:RegisterEffect(e2)
end
function c30556001.confil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:GetPreviousRaceOnField()==RACE_MACHINE and c:IsType(TYPE_SYNCHRO) and c:IsReason(REASON_EFFECT)
end
function c30556001.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30556001.confil,1,nil,tp)
end
function c30556001.spfil(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30556001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c30556001.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,30556001)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,200)
end
function c30556001.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,30556001,RESET_PHASE+PHASE_END,0,1)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c30556001.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end
function c30556001.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK))
end
function c30556001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c30556001.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and re:IsActiveType(TYPE_MONSTER) and (re:GetActivateLocation()==LOCATION_HAND or re:GetActivateLocation()==LOCATION_GRAVE) and rp~=tp and Duel.IsChainNegatable(ev)
end
function c30556001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c30556001.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) then
			local g=Duel.GetMatchingGroup(c30556001.cfilter,tp,LOCATION_MZONE,0,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
	end
end