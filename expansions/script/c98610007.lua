 --少女分形·冻结之世
function c98610007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c98610007.ffilter,6,2)
	c:EnableReviveLimit()
	--buff
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98610007,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c98610007.target)
	e1:SetOperation(c98610007.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98610007,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98610007)
	e2:SetCost(c98610007.rmcost)
	e2:SetTarget(c98610007.rmtg)
	e2:SetOperation(c98610007.rmop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(c98610007.spreg)
	c:RegisterEffect(e3)
end
function c98610007.ffilter(c)
	return c:IsSetCard(0x980)and c:IsType(TYPE_MONSTER) 
end
function c98610007.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsAbleToRemove,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c98610007.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=c:GetOverlayGroup():Filter(Card.IsAbleToRemove,nil,REASON_EFFECT)
	if g:GetCount()>0 then
		local sg=g:Select(tp,1,1,nil)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_REMOVED) then
		    --cannot remove
	       local e1=Effect.CreateEffect(c)
	       e1:SetType(EFFECT_TYPE_FIELD)
	       e1:SetCode(EFFECT_CANNOT_REMOVE)
	       e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e1:SetReset(RESET_PHASE+PHASE_END,2)
	       e1:SetTargetRange(1,1)
	       Duel.RegisterEffect(e1,tp)
	      --act limit
	       local e2=Effect.CreateEffect(c)
	       e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	       e2:SetCode(EVENT_CHAINING)
	       e2:SetReset(RESET_PHASE+PHASE_END,2)
	       e2:SetOperation(c98610007.chainop)
	       Duel.RegisterEffect(e2,tp)
	    end
	end
end
function c98610007.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end
function c98610007.spreg(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsReason(REASON_EFFECT) and rc:IsSetCard(0x980) then
		c:RegisterFlagEffect(98610007,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c98610007.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98610007)>0 and e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c98610007.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98610007.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end