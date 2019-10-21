--霓色独珠的耳语花园
function c65050113.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,65050113)
	e2:SetCondition(c65050113.condition)
	e2:SetTarget(c65050113.target)
	e2:SetOperation(c65050113.activate)
	c:RegisterEffect(e2)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c65050113.chaincon)
	e4:SetOperation(c65050113.chainop)
	c:RegisterEffect(e4)
end
function c65050113.confil(c,tp)
	return c:IsType(TYPE_XYZ) and c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c65050113.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050113.confil,1,nil,tp) 
end
function c65050113.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050113.tgfil(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050113.tgfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c65050113.tgfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c65050113.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c65050113.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c65050113.tgfil,tp,LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end

function c65050113.chaincfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c65050113.chaincon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65050113.chaincfil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050113.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_RITUAL) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) then
		Duel.SetChainLimit(c65050113.chainlm)
	end
end
function c65050113.chainlm(e,rp,tp)
	return tp==rp
end