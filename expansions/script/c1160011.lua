--夏日舞曲·辛德瑞拉      
function c1160011.initial_effect(c)
-- 
--  if not c1160011.gchk then
--	c1160011.gchk=true
--	local e3=Effect.GlobalEffect()
--	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
--	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
--	e3:SetCondition(c1160011.con3)
--	e3:SetOperation(c1160011.op3)
--	Duel.RegisterEffect(e3,0)
--  end
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
--  e1:SetCondition(c1160011.con1)
	e1:SetCost(c1160011.cost1)
	e1:SetTarget(c1160011.tg1)
	e1:SetOperation(c1160011.op1)
	c:RegisterEffect(e1) 
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,1160011)
	e2:SetTarget(c1160011.tg2)
	e2:SetOperation(c1160011.op2)
	c:RegisterEffect(e2)
--
end
--
--function c1160011.ofilter3(c)
--  return c:IsPreviousLocation(LOCATION_EXTRA)
--end
--function c1160011.con3(e,tp,eg,ep,ev,re,r,rp)
--  return eg:FilterCount(c1160011.ofilter3,nil)>0
--end
--function c1160011.op3(e,tp,eg,ep,ev,re,r,rp)
--  Duel.RegisterFlagEffect(rp,1160011,RESET_PHASE+PHASE_END,0,1)
--end
--
--function c1160011.con1(e,tp,eg,ep,ev,re,r,rp)
--  return Duel.GetFlagEffect(1-tp,1160011)>0
--end
--
function c1160011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_PUBLIC)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1_1)
	c:RegisterFlagEffect(1160011,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
end
--
function c1160011.tfilter1_1(c)
	return c:IsAbleToRemove() and c:GetLevel()==1
end
function c1160011.tfilter1_2(c)
	return c:IsAbleToRemove() and c:GetType()==TYPE_SPELL 
end
function c1160011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp==1-tp and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c1160011.tfilter1_1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1160011.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_GRAVE)
end
--
function c1160011.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsChainDisablable(0) then
		local sel=1
		local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_SPELL)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(1160011,2))
		if g:GetCount()>0 then
			sel=Duel.SelectOption(1-tp,1213,1214)
		else
			sel=Duel.SelectOption(1-tp,1214)+1
		end
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.NegateEffect(0)
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
			return
		end
	end
	if not (Duel.IsExistingMatchingCard(c1160011.tfilter1_1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1160011.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c1160011.tfilter1_1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c1160011.tfilter1_2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		Duel.NegateActivation(ev)
	end
end
--
function c1160011.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_MONSTER)
end
--
function c1160011.tfilter2(c,attribute,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(attribute) and c:GetAttack()>399 and c:GetLevel()==1
end
function c1160011.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c1160011.tfilter2,tp,LOCATION_DECK,0,1,nil,re,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	e:SetLabel(re:GetHandler():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
--
function c1160011.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1160011.tfilter2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
--
--	local e2_2=Effect.CreateEffect(e:GetHandler())
--	e2_2:SetType(EFFECT_TYPE_SINGLE)
--	e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--	e2_2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
--	e2_2:SetValue(1)
--	e2_2:SetReset(RESET_EVENT+0x1fe0000)
--	tc:RegisterEffect(e2_2)   
--	local e2_3=Effect.CreateEffect(e:GetHandler())
--	e2_3:SetType(EFFECT_TYPE_SINGLE)
--	e2_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--	e2_3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
--	e2_3:SetValue(1)
--	e2_3:SetReset(RESET_EVENT+0x1fe0000)
--	tc:RegisterEffect(e2_3)
--	local e2_4=Effect.CreateEffect(e:GetHandler())
--	e2_4:SetType(EFFECT_TYPE_SINGLE)
--	e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--	e2_4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
--	e2_4:SetValue(1)
--	e2_4:SetReset(RESET_EVENT+0x1fe0000)
--	tc:RegisterEffect(e2_4)
		local e2_5=Effect.CreateEffect(e:GetHandler())
		e2_5:SetType(EFFECT_TYPE_SINGLE)
		e2_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2_5:SetValue(1)
		e2_5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_5)
--
	end
end
function c1160011.tg2_1(e,c)
	return not (c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA))
end
