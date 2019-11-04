--诅咒之地
c11200040.card_code_list={11200029}
function c11200040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c11200040.acop)
	c:RegisterEffect(e3)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(c11200040.ctcon)
	e7:SetTarget(c11200040.cttg)
	e7:SetOperation(c11200040.ctop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c11200040.cfilter(c)
	return aux.IsCodeListed(c,11200029) and not c:IsCode(11200040) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c11200040.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFaceup,1,nil,nil) and Duel.IsExistingMatchingCard(c11200040.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function c11200040.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ec=eg:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ec,0,0x1620)
end
function c11200040.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:AddCounter(0x1620,1)
		tc=eg:GetNext()
	end
end
function c11200040.acop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) or not tc:IsFaceup() or tc:GetCounter(0x1620)<1 then return end
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and e:GetHandler():GetFlagEffect(1)>0 then
		Duel.Hint(HINT_CARD,0,11200040)
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
