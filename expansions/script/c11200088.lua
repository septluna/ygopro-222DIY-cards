--真实神话的篡夺者
function c11200088.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),3,false)
	--destroy monster
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11200088)
	e1:SetCondition(c11200088.rdcon)
	e1:SetTarget(c11200088.rdtg)
	e1:SetOperation(c11200088.rdop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11209088)
	e2:SetTarget(c11200088.sptg)
	e2:SetOperation(c11200088.spop)
	c:RegisterEffect(e2)
end
function c11200088.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsCode(11200088) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c11200088.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c11200088.rdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c11200088.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c11200088.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200088.rmfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c11200088.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11200088.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()==0 then return end
	local tc=g:RandomSelect(tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)
		and c:IsRelateToEffect(e) then
		if tc:IsType(TYPE_FUSION) then
			Duel.BreakEffect()
			Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
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
			Duel.SpecialSummonComplete()
		end
	end
end
function c11200088.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
