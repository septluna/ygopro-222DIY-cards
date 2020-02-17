--热核污染病毒-Ø
if not pcall(function() require("expansions/script/c33340004") end) then require("script/c33340004") end
local m=33340009
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,rccv.IsLinkSet,1,1) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.lpcon)
	e4:SetOperation(cm.lpop)
	c:RegisterEffect(e4)	   
end
cm.rssetcode="Thermonuclear"
function cm.thfilter(c,tp)
	if c:IsOnField() and c:IsFacedown() then return end
	return c:IsAbleToHand() and (c:IsOnField() or Duel.IsPlayerCanDraw(tp,2)) and rccv.IsSet(c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,LOCATION_ONFIELD,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,nil,0xd)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,1-tp,REASON_EFFECT)~=0 then
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thcfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.thcfilter(c,tp)
	return rccv.IsSet(c) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cm.lpcon(e,tp)
	return Duel.GetLP(tp)>=500
end
function cm.lpop(e,tp)
	Duel.SetLP(tp,math.max(0,Duel.GetLP(tp)-500))
	if Duel.GetLP(tp)<=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.val)
	e1:SetReset(rsreset.pend)
	Duel.RegisterEffect(e1,tp)
end
function cm.val(e,re,dam,r,rp,rc)
	if dam>=500 then return 100
	else return dam
	end
end