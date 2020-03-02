--惧 轮  界 外 人
function c53701022.initial_effect(c)
	--advance self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53701022,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetRange(LOCATION_HAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCondition(c53701022.sumcon)
	e2:SetCost(c53701022.cost)
	e2:SetTarget(c53701022.sumtg)
	e2:SetOperation(c53701022.sumop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c53701022.value)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53701022,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c53701022.descon)
	e4:SetOperation(c53701022.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c53701022.sumfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x530)
end
function c53701022.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53701022.sumfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c53701022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRIBUTE_LIMIT)
	e1:SetReset(RESET_CHAIN)  
	e1:SetValue(c53701022.tlimit)
	e:GetHandler():RegisterEffect(e1)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c53701022.tlimit(e,c)
	return not c:IsSetCard(0x530)
end
function c53701022.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c53701022.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonable(true,nil,1) and c:IsRelateToEffect(e) then
		Duel.Summon(tp,c,true,nil,1)
	end
end
function c53701022.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*200
end
function c53701022.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x530) and c:IsControler(tp) and c:IsAttackPos()
end
function c53701022.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c53701022.cfilter,1,nil,tp)
end
function c53701022.desfilter1(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsCode(53701009) and c:GetLinkedGroup():IsContains(mc)
end
function c53701022.spfilter(c,e,tp,rc)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_SUMMON) and c:GetReasonCard()==rc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53701022.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.DisableShuffleCheck()
	Duel.Destroy(tc,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(53701022,RESET_EVENT+RESETS_STANDARD,0,1)
	local g3=e:GetHandler():GetMaterial():Filter(c53701022.spfilter,nil,e,tp,e:GetHandler())
	local ter=e:GetHandler():GetFlagEffect(53701022)
	local nm=2
	local g2=Duel.GetMatchingGroup(c53701022.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	if g2:GetCount()>0 then nm=1 end
	local ct=g3:GetCount()
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if ter%nm==0 and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct-1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
	end
end