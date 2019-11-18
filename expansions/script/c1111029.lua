--梦境的终焉
function c1111029.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111029+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c1111029.tg1)
	e1:SetOperation(c1111029.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c1111029.con2)
	e2:SetTarget(c1111029.tg2)
	e2:SetOperation(c1111029.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111029.tfilter1(c,e,tp)
	return c:IsCode(1110001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c1111029.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1111029.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c1111029.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1111029.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--
function c1111029.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
--
function c1111029.tfilter2(c)
	return c:IsCode(1110001) and c:IsFacedown()
end
function c1111029.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
--
function c1111029.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c1111029.tfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.ChangePosition(sg,POS_FACEUP)>0 then
		local tc=sg:GetFirst()
		while tc do
			local e2_0=Effect.CreateEffect(c)
			e2_0:SetDescription(aux.Stringid(1111029,0))
			e2_0:SetType(EFFECT_TYPE_SINGLE)
			e2_0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			tc:RegisterEffect(e2_0,true)
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e2_1:SetValue(1)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2_1,true)
			local e2_2=e2_1:Clone()
			e2_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e2_2,true)
			local e2_3=e2_1:Clone()
			e2_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e2_3,true)
			local e2_4=e2_1:Clone()
			e2_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e2_4,true)
			tc=sg:GetNext()
		end
	end
end
--
