--黯色反转 布蕾克
function c11200304.initial_effect(c)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11200304)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c11200304.atktg)
	e1:SetOperation(c11200304.atkop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,11209304)
	e2:SetCost(c11200304.thcost)
	e2:SetTarget(c11200304.thtg)
	e2:SetOperation(c11200304.thop)
	c:RegisterEffect(e2)
end
function c11200304.dsfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c11200304.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11200304.dsfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200304.dsfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11200304.dsfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11200304.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
	end
end
function c11200304.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c11200304.filter(c,tp)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c11200304.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c)
end
function c11200304.filter2(c,mc)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand() and c11200304.isfit(c,mc)
end
function c11200304.isfit(c,mc)
	return (mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))) or aux.IsCodeListed(mc,c:GetCode())
end
function c11200304.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200304.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11200304.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11200304.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11200304.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11200304.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c11200304.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
