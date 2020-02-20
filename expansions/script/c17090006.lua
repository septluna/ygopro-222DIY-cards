--ドラゴンナイツ
local m=17090006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17090006+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.IsVane(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Vane
end
function cm.IsSiegfried(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Siegfried
end
function cm.IsPercival(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Percival
end
function cm.Vane(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsCode(47500501) or cm.IsVane(c))
end
function cm.Siegfried(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsCode(14000104,47548001,47500503,10120011) or cm.IsSiegfried(c))
end
function cm.Lancelot(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa8) 
end
function cm.Percival(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsCode(17060925,47500507) or cm.IsPercival(c))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (cm.Percival(c) or cm.Lancelot(c) or cm.Siegfried(c) or cm.Vane(c)) 
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function cm.check(g)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(cm.Vane,1,nil) then res=res+0x1 end
	if g:IsExists(cm.Siegfried,1,nil) then res=res+0x2 end
	if g:IsExists(cm.Lancelot,1,nil) then res=res+0x4 end
	if g:IsExists(cm.Percival,1,nil) then res=res+0x8 end
	return res~=0x1 and res~=0x2 and res~=0x4 and res~=0x8
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:SelectSubGroup(tp,cm.check,false,1,2)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)
	end
	local ng=g1:Filter(cm.Siegfried,nil)
	local vc=ng:GetFirst()
	while vc do
		if vc:IsType(TYPE_XYZ) and cm.Siegfried(vc) then
			e:GetHandler():CancelToGrave()
			Duel.Overlay(vc,Group.FromCards(e:GetHandler()))
		end
		vc=ng:GetNext()
	end
end
