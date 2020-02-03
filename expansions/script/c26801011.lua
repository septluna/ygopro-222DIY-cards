--樱木真乃的新年初诣
function c26801011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26801011)
	e1:SetTarget(c26801011.target)
	e1:SetOperation(c26801011.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26801911)
	e2:SetCondition(c26801011.dcondition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26801011.dtarget)
	e2:SetOperation(c26801011.doperation)
	c:RegisterEffect(e2)
end
function c26801011.filter(c)
	return c:IsSetCard(0x602) and c:IsAbleToHand()
end
function c26801011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26801011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26801011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26801011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26801011.dfilter(c,tp)
	return c:IsLevelBelow(6) and (c:IsType(TYPE_FUSION) or bit.band(c:GetType(),0x81)==0x81) and c:IsControler(tp)
end
function c26801011.dcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26801011.dfilter,1,nil,tp)
end
function c26801011.dtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26801011.doperation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
