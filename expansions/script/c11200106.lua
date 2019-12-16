--虚构之炎
function c11200106.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,c11200106.filter,nil,c11200106.mfilter)   
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,11200106)
	e2:SetTarget(c11200106.sptg2)
	e2:SetOperation(c11200106.spop2)
	c:RegisterEffect(e2)
end
function c11200106.filter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c11200106.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c11200106.cfilter(c,tp)
	return c:IsAbleToRemoveAsCost()
end
function c11200106.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingMatchingCard(c11200106.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11200106.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c11200106.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp)
	local c=e:GetHandler()
	local tc=tg:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)
		and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
