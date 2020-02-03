--迷你撒旦
local m=17050946
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.value)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17050946,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(cm.tdcon)
	e5:SetTarget(cm.tdtg)
	e5:SetOperation(cm.tdop)
	c:RegisterEffect(e5)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetDecktopGroup(e:GetHandler():GetControler(),5)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==5
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*100
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
		and c:IsPreviousPosition(POS_FACEUP)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
