--真实神话的篡夺者
function c11200088.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),3,false)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c11200088.target)
	e1:SetOperation(c11200088.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11200088)
	e2:SetTarget(c11200088.sptg)
	e2:SetOperation(c11200088.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11200088.bctcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(c11200088.actcon)
	c:RegisterEffect(e4)
end
function c11200088.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c11200088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200088.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(c11200088.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c11200088.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11200088.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(ct*300)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c11200088.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11200088.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		c:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e6,true)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e7:SetValue(c11200088.fuslimit)
		c:RegisterEffect(e7,true)
		local e8=e1:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		c:RegisterEffect(e8,true)
		local e9=e1:Clone()
		e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e9,true)
	end
	Duel.SpecialSummonComplete()
end
function c11200088.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c11200088.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() and e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function c11200088.bctcon(e)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
