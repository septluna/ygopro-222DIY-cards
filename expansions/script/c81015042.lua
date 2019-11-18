--一夏一刻物语·北上丽花
require("expansions/script/c81000000")
function c81015042.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c81015042.synfiltera,aux.NonTuner(c81015042.synfilterb),1)
	c:EnableReviveLimit()
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c81015042.sumcon)
	e0:SetOperation(c81015042.sumsuc)
	c:RegisterEffect(e0)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81015942)
	e2:SetCondition(c81015042.condition)
	e2:SetTarget(c81015042.target)
	e2:SetOperation(c81015042.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81015042)
	e3:SetCondition(c81015042.negcon)
	e3:SetCost(c81015042.negcost)
	e3:SetTarget(c81015042.negtg)
	e3:SetOperation(c81015042.negop)
	c:RegisterEffect(e3)
end
function c81015042.synfiltera(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c81015042.synfilterb(c)
	return c:IsSetCard(0x81a)
end
function c81015042.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c81015042.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c81015042.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81015042.actlimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	local c=re:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function c81015042.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c81015042.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a) and not c:IsHasEffect(EFFECT_PIERCE)
end
function c81015042.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c81015042.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81015042.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81015042.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c81015042.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Tenka.ReikaCon(e,tp,eg,ep,ev,re,r,rp) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c81015042.cfilter(c)
	return c:IsSetCard(0x81a) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c81015042.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81015042.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81015042.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81015042.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81015042.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_DECK) then
		if (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(81015042,2)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
			Duel.ConfirmCards(1-tp,rc)
		end
	end
end
