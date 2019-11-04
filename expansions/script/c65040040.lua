--逆光色的脸红心跳
function c65040040.initial_effect(c)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COIN+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c65040040.cost)
	e2:SetTarget(c65040040.cointg)
	e2:SetOperation(c65040040.coinop)
	c:RegisterEffect(e2)
end
c65040040.toss_coin=true
function c65040040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoHand(g,1-tp,REASON_COST)
end
function c65040040.ntrfil(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c65040040.cointg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c65040040.ntrfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65040040.ntrfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,c65040040.ntrfil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c65040040.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local res=Duel.TossCoin(tp,1)
		if res==1 and tc:IsAbleToChangeControler() then
			Duel.GetControl(tc,tp)
		end
	end
end