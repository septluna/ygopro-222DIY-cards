--圣夜钟声·佐城雪美
function c81021005.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81021005.matfilter,1,1)
	--Cost Change
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_LPCOST_CHANGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetValue(c81021005.costchange)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,81021005)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c81021005.thcost)
	e1:SetTarget(c81021005.thtg)
	e1:SetOperation(c81021005.thop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81021905)
	e2:SetCondition(c81021005.tgcon)
	e2:SetTarget(c81021005.tdtg)
	e2:SetOperation(c81021005.tdop)
	c:RegisterEffect(e2)
end
function c81021005.matfilter(c)
	return c:IsLinkType(TYPE_RITUAL) and c:IsLinkType(TYPE_PENDULUM)
end
function c81021005.costchange(e,re,rp,val)
	local rc=re:GetHandler()
	if re and re:GetHandler():IsSetCard(0x818) and re:IsHasType(0x7f0) then
		return 200
	else
		return val
	end
end
function c81021005.costfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c81021005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81021005.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81021005.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c81021005.thfilter1(c,tp)
	return c:IsSetCard(0x818) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c81021005.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c81021005.thfilter2(c)
	return c:IsSetCard(0x818) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c81021005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81021005.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c81021005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c81021005.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c81021005.thfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c81021005.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c81021005.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c81021005.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
