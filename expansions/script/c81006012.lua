--最后的情书·姬野星奏
local m=81006012
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	local e0=aux.AddRitualProcEqual2(c,cm.ritfilter)
	e0:SetCountLimit(1,m)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCode(0)
	e0:SetRange(LOCATION_MZONE)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,m+900)
	e6:SetCost(aux.bfgcost)
	e6:SetTarget(cm.tdtg)
	e6:SetOperation(cm.tdop)
	c:RegisterEffect(e6)
end
function cm.ritfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttack(1550) and c:IsDefense(1050) and c:IsType(TYPE_PENDULUM)
end
function cm.tdfilter(c)
	return c:GetType()==0x82 and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
