--热核污染病毒-ш
if not pcall(function() require("expansions/script/c33340004") end) then require("script/c33340004") end
local m,cm=rscf.DefineCard(33340014,"Thermonuclear")
function cm.initial_effect(c)
	rccv.publiceffect(c)
	local e1=rsef.I(c,{m,0},1,"th",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE),cm.thop)
	local e2=rsef.I(c,{m,1},{1,m},"th,sp",nil,LOCATION_HAND,cm.spcon,nil,rsop.target({cm.thfilter2,"th",LOCATION_ONFIELD+LOCATION_DECK,LOCATION_ONFIELD },{rscf.spfilter(),"sp"}),cm.spop)
	local e3=rsef.FTF(c,EVENT_TO_HAND,{m,2},1,"th","de",LOCATION_HAND,cm.con,nil,cm.tg,cm.op)
	local e4,e7=rsef.FV_LIMIT_PLAYER(c,"res,dish",nil,aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND),{1,0},rccv.pubcon2)
	e4:SetRange(LOCATION_HAND)
	e7:SetRange(LOCATION_HAND)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetRange(LOCATION_HAND)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(rccv.pubcon2)
	e5:SetValue(cm.atkval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1)
	e6:SetCondition(rccv.pubcon)
	e6:SetOperation(cm.thop2)
	c:RegisterEffect(e6) 
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp<=1000 then Duel.SetLP(tp,0) return end
	Duel.SetLP(tp,lp-1000)
	if e:GetHandler():IsRelateToEffect(e) then
	   Duel.SendtoHand(e:GetHandler(),1-tp,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsFaceup() and rccv.IsSet(c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rshint.Select(tp,"th")
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end 
function cm.spcon(e)
	return not e:GetHandler():IsPublic()
end
function cm.thfilter2(c,e,tp)
	return (c:IsFaceup() or not c:IsOnField()) and rccv.IsSet(c) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c,tp)>0 and not c:IsCode(m)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	rshint.Select(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_ONFIELD+LOCATION_DECK,LOCATION_ONFIELD,1,1,nil)
	if #tg>0 and Duel.SendtoHand(tg,1-tp,REASON_EFFECT)>0 and c then
		rssf.SpecialSummon(c)
	end
end
function cm.thcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.con(e,tp,eg)
	return e:GetHandler():IsPublic() and eg:IsExists(cm.thcfilter,1,nil,tp) and Duel.GetCurrentPhase()~=PHASE_DRAW 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg:Filter(Card.IsControler,nil,tp))
end
function cm.op(e,tp,eg)
	local tg=rsgf.GetTargetGroup(cm.thcfilter,tp)
	Duel.SendtoHand(tg,1-tp,REASON_EFFECT)
	Duel.ShuffleHand(tp)
end
function cm.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end