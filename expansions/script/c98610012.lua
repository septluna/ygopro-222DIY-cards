--少女分形·禁断之梦
function c98610012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,98610012+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98610012.condition)
	e1:SetTarget(c98610012.target)
	e1:SetOperation(c98610012.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98610012,1))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98610012)
	e2:SetCondition(c98610012.tpcon)
	e2:SetTarget(c98610012.tptg)
	e2:SetOperation(c98610012.tpop)
	c:RegisterEffect(e2)
end
function c98610012.cfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x870)
end
function c98610012.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c98610012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98610012.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c98610012.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c98610012.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_REMOVED) then
	    local tc=re:GetHandler()
	    if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and tc:IsAbleToRemove() then
	       Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	    end
	end
end
function c98610012.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)and re and re:GetHandler():IsSetCard(0x870)
end
function c98610012.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
end
function c98610012.tpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
