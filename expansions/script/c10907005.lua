--花寄女生 野野宫
function c10907005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c10907005.spcon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x23a))
	c:RegisterEffect(e1)	  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c10907005.repcon)
	e0:SetOperation(c10907005.repop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,10907005)
	e1:SetCondition(c10907005.spcon)
	e1:SetTarget(c10907005.distg)
	e1:SetOperation(c10907005.drop)
	c:RegisterEffect(e1)
end
function c10907005.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and e:GetHandler():GetFlagEffect(10907005)==0
end
function c10907005.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c10907005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(10907000)
end
function c10907005.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c10907005.cfilter(c)
	return c:IsSetCard(0x23a) or c:IsSetCard(0x32c4) and c:IsLocation(LOCATION_GRAVE)
end
function c10907005.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c10907005.cfilter,nil)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end