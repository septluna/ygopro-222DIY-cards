--手长足长的神明
c11200049.card_code_list={11200029}
function c11200049.initial_effect(c)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(11200029)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11200049)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c11200049.ctcost)
	e1:SetTarget(c11200049.cttg)
	e1:SetOperation(c11200049.ctop)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
end
function c11200049.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c11200049.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1620,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1620,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1620,1)
end
function c11200049.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x1620,1) then
		local e3_1_1=Effect.CreateEffect(c)
		e3_1_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_1_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3_1_1:SetCondition(c11200049.disable)
		e3_1_1:SetValue(1)
		e3_1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_1_1)
		local e3_1_2=e3_1_1:Clone()
		e3_1_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e3_1_2)
		local e3_1_3=e3_1_1:Clone()
		e3_1_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e3_1_3)
		local e3_1_4=e3_1_1:Clone()
		e3_1_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e3_1_4)
		local e3_1_5=e3_1_1:Clone()
		e3_1_5:SetCode(EFFECT_UNRELEASABLE_SUM)
		tc:RegisterEffect(e3_1_5)
		local e3_1_6=e3_1_1:Clone()
		e3_1_6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e3_1_6)
	end
end
function c11200049.disable(e)
	return e:GetHandler():GetCounter(0x1620)>0
end
