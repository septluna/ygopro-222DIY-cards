--砂冢明音
function c81011027.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81011027)
	e1:SetCondition(c81011027.spcon)
	e1:SetOperation(c81011027.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81011927)
	e2:SetCost(c81011027.setcost)
	e2:SetTarget(c81011027.settg)
	e2:SetOperation(c81011027.setop)
	c:RegisterEffect(e2)
end
function c81011027.spfilter(c)
	return (bit.band(c:GetOriginalType(),TYPE_SPELL)~=0 or bit.band(c:GetOriginalType(),TYPE_TRAP)~=0) and c:IsAbleToGraveAsCost()
end
function c81011027.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81011027.spfilter,c:GetControler(),LOCATION_ONFIELD,0,2,nil)
end
function c81011027.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81011027.spfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81011027.vfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c81011027.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81011027.vfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81011027.vfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81011027.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:IsSSetable(true)
end
function c81011027.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c81011027.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c81011027.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81011027.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,g)
	end
end
