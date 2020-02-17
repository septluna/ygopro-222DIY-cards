--ZEON公国的陨落
local m=11700020
local cm=_G["c"..m]
function cm.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.counter)
	c:RegisterEffect(e2)
--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x280))
	e3:SetValue(200)
	c:RegisterEffect(e3)
--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)   
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
end
function cm.cfilter(c,tp)
	return  c:IsReason(REASON_BATTLE)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.cfilter,nil,tp)
	if ct>0 then
		Duel.Damage(tp,300,REASON_EFFECT)
	end
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function cm.filter(c)
	return c:IsSetCard(0x280) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return end
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(cm.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,cm.filter,1,1,nil)	
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp) 
   else Duel.ShuffleDeck(tp)   
   end
end