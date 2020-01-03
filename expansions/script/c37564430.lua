--绝对要看的大团圆·终场普莉希拉
local m=37564430
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismXyzProcedure(c,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL,EFFECT_FLAG2_AVAILABLE_BD)
	e1:SetCost(Senya.RemoveOverlayCost(1))
	e1:SetCondition(cm.rmcon)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)	
end
function cm.cfilter(c)
	return Senya.check_set_prism(c) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return #g>6 and g:IsExists(Card.IsType,3,nil,TYPE_XYZ)
end
function cm.rfilter(c,e)
	if e and c:IsImmuneToEffect(e) then return false end
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.sfilter(c,e,tp,g)
	return Senya.check_set_prism(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not g or cm.scheck(g,c,tp))
end
function cm.scheck(g,c,tp)
	if c:IsLocation(LOCATION_EXTRA) then return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 end
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.gcheck(g,mft,eft1,eft2)
	local ect1=g:FilterCount(function(c)
		return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and not c:IsType(TYPE_LINK)
	end,nil)
	local ect2=g:FilterCount(function(c)
		return c:IsLocation(LOCATION_EXTRA) and c(:IsFaceup() or c:IsType(TYPE_LINK))
	end,nil)
	return ect1<=eft1 and ect2<=eft2 and #g-ect1-ect2<=mft
end
function cm.RegisterBuff(c,ec)
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(c:GetBaseAttack()*2)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(function(e,te)
		return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
	end)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2,true)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,0,aux.ExceptThisCard(e),e)
	if #g==0 or not Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g) then return end
	local ct=Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local sg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	local ft=math.min(Duel.GetUsableMZoneCount(tp),ct)
	local mft=Duel.GetMZoneCount(tp)
	local eft1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and math.min(c29724053[tp],(Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ))) or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	local eft2=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and math.min(c29724053[tp],(Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM))) or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local tg=Senya.SelectGroup(tp,HINTMSG_SPSUMMON,sg,cm.gcheck,nil,1,ft,mft,eft)
	local etg1=g:Filter(function(c)
		return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and not c:IsType(TYPE_LINK)
	end)
	local etg2=g:Filter(function(c)
		return c:IsLocation(LOCATION_EXTRA) and c(:IsFaceup() or c:IsType(TYPE_LINK))
	end,nil)
	tg:Sub(etg1)
	tg:Sub(etg2)
	for tc in aux.Next(etg2) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		cm.RegisterBuff(tc,e:GetHandler())
	end
	for tc in aux.Next(etg1) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		cm.RegisterBuff(tc,e:GetHandler())
	end
	for tc in aux.Next(tg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		cm.RegisterBuff(tc,e:GetHandler())
	end
	Duel.SpecialSummonComplete()
end
