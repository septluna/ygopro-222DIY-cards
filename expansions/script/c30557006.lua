--永辉真理 单独概念
function c30557006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x306),c30557006.fusfilter,false)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(c30557006.destg)
	e1:SetOperation(c30557006.desop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE)
	e2:SetCondition(c30557006.indcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c30557006.fusfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown()
end
function c30557006.indcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==1
end


function c30557006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,TYPE_MONSTER) end
	local dg=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,dg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c30557006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g2=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
	if g2:GetCount()>0 and Duel.Destroy(g2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		 Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end