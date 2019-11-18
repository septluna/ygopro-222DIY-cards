--天界之门
local m=17030058
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<1 or (not c:IsRelateToEffect(e)) then return end
	Duel.ConfirmCards(tp,g)
	if g:GetClassCount(Card.GetCode)==g:GetCount() then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(17030058,2))
		--Effect Draw
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DRAW_COUNT)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_FZONE)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(2)
		c:RegisterEffect(e2)
		--spsummon
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(17030058,0))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_FZONE)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetTarget(cm.sptg)
		e3:SetOperation(cm.spop)
		c:RegisterEffect(e3)
		--to hand
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(17030058,1))
		e4:SetCategory(CATEGORY_TOHAND)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetRange(LOCATION_FZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetCountLimit(1)
		e4:SetCondition(cm.thcon)
		e4:SetTarget(cm.thtg)
		e4:SetOperation(cm.thop)
		c:RegisterEffect(e4)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(cm.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end