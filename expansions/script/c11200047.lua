--土著神的顶点
c11200047.card_code_list={11200029}
function c11200047.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,3)
	c:EnableReviveLimit()
	--atk up
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c11200047.con)
	e0:SetValue(c11200047.atkval)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c11200047.con)
	e1:SetCost(c11200047.ctcost)
	e1:SetTarget(c11200047.cttg)
	e1:SetOperation(c11200047.ctop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11200047)
	e2:SetCondition(c11200047.thcon)
	e2:SetTarget(c11200047.thtg)
	e2:SetOperation(c11200047.thop)
	c:RegisterEffect(e2)
end
function c11200047.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c11200047.atkfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1620)>0
end
function c11200047.atkval(e,c)
	local g=Duel.GetMatchingGroup(c11200047.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,c)
	local atk=g:GetSum(Card.GetBaseAttack)
	return atk
end
function c11200047.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11200047.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1620,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1620,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1620,1)
end
function c11200047.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x1620,1) then
		local e3_1_1=Effect.CreateEffect(c)
		e3_1_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_1_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3_1_1:SetCondition(c11200047.disable)
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
function c11200047.disable(e)
	return e:GetHandler():GetCounter(0x1620)>0
end
function c11200047.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c11200047.thfilter(c)
	return aux.IsCodeListed(c,11200029) and not c:IsCode(11200047) and c:IsAbleToHand()
end
function c11200047.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11200047.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200047.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11200047.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11200047.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
