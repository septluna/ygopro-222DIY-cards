--霓色独珠 憧憬少女
function c65050110.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),8,2)
	c:EnableReviveLimit()
	--change rank
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,65050110)
	e1:SetCondition(c65050110.con)
	e1:SetCost(c65050110.cost)
	e1:SetOperation(c65050110.op)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050111)
	e2:SetCondition(c65050110.condition)
	e2:SetCost(c65050110.cost2)
	e2:SetTarget(c65050110.target)
	e2:SetOperation(c65050110.activate)
	c:RegisterEffect(e2)
end
function c65050110.confil(c,tp)
	return c:IsSetCard(0x3da8) and c:GetSummonPlayer()==tp
end
function c65050110.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050110.confil,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c65050110.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65050110.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050110.tgfil(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050110.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050110.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c65050110.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c65050110.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c65050110.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end


function c65050110.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c65050110.costfil(c)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c65050110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050110.costfil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65050110.costfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c65050110.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RANK_FINAL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e2:SetValue(e:GetLabel())
	c:RegisterEffect(e2)
end