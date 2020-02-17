--六曜的赤口
local m=12001017
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12001017.target)
	e1:SetOperation(c12001017.activate)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12001017,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,12001104)
	e3:SetCondition(c12001017.dscon)
	e3:SetCondition(c12001017.dstg)
	e3:SetOperation(c12001017.dsop)
	c:RegisterEffect(e3)
 
end
function c12001017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ct=ct-1 end
	if chk==0 then return Duel.IsPlayerCanRemove(1-tp)
		and ct>0 and g:IsExists(Card.IsAbleToRemove,1,nil,1-tp,POS_FACEUP,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c12001017.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=tg:FilterSelect(1-tp,Card.IsAbleToRemove,ct,ct,nil,1-tp,POS_FACEUP,REASON_RULE)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end
function c12001017.dscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
function c12001017.dstg(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_MZONE)
end
function c12001017.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_RULE)
	end
end
