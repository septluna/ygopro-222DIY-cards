--高山纱代子的女子力？
function c81017023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81017023+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81017023.con)
	e1:SetTarget(c81017023.tg)
	e1:SetOperation(c81017023.op)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c81017023.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81017023.distg)
	e2:SetOperation(c81017023.disop)
	c:RegisterEffect(e2)
end
function c81017023.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousRaceOnField()==RACE_FAIRY and c:GetPreviousControler()==1-tp
end
function c81017023.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81017023.cfilter,1,nil,tp)
end
function c81017023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81017023.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c81017023.tgfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x819)
end
function c81017023.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c81017023.tgfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c81017023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81017023.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
