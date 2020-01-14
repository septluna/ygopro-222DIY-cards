--北上丽花的瞎jb吹
require("expansions/script/c81000000")
function c81015007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81015007)
	e1:SetCondition(c81015007.condition)
	e1:SetTarget(c81015007.target)
	e1:SetOperation(c81015007.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81015907)
	e2:SetCondition(c81015007.drcon)
	e2:SetCost(c81015007.drcost)
	e2:SetTarget(c81015007.drtg)
	e2:SetOperation(c81015007.drop)
	c:RegisterEffect(e2)
	--act qp in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(Tenka.ReikaCon)
	c:RegisterEffect(e3)
end
function c81015007.eeilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a)
end
function c81015007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81015007.eeilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81015007.tgfilter(c,tp)
	return Duel.IsExistingMatchingCard(c81015007.gyfilter,tp,0,LOCATION_MZONE,1,nil,c:GetColumnGroup())
end
function c81015007.gyfilter(c,g)
	return g:IsContains(c)
end
function c81015007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c81015007.tgfilter,tp,0,LOCATION_SZONE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_MZONE)
end
function c81015007.activate(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.SelectMatchingCard(tp,c81015007.tgfilter,tp,0,LOCATION_SZONE,1,1,nil,tp)
	if pg:GetCount()==0 then return end
	local g=Duel.GetMatchingGroup(c81015007.gyfilter,tp,0,LOCATION_MZONE,nil,pg:GetFirst():GetColumnGroup())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c81015007.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Tenka.ReikaCon(e) and aux.exccon(e)
end
function c81015007.cfilter(c)
	return c:IsSetCard(0x81a) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81015007.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c81015007.cfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81015007.cfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81015007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81015007.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
