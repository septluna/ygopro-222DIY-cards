--伊瑟琳·抹茶芭菲
function c75646602.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--RECOVER
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646602,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,75646602)
	e1:SetCost(c75646602.cost)
	e1:SetOperation(c75646602.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646602,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,5646602)
	e2:SetCondition(c75646602.spcon)
	e2:SetTarget(c75646602.sptg)
	e2:SetOperation(c75646602.spop)
	c:RegisterEffect(e2)
end
function c75646602.cfilter(c,e,tp)
	if c:IsLocation(LOCATION_HAND+LOCATION_MZONE) then return c==e:GetHandler() and c:IsAbleToGraveAsCost() end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp)
end
function c75646602.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646602.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c75646602.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
	if not g:IsExists(Card.IsHasEffect,1,nil,75646628,tp) then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=Duel.SelectMatchingCard(tp,c75646602.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		local te=tc:IsHasEffect(75646628,tp)
		if te then
			Duel.Remove(tc,POS_FACEUP,REASON_COST)
		else
			Duel.SendtoGrave(tc,REASON_COST)
		end
	end
end
function c75646602.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c75646602.con)
	e1:SetOperation(c75646602.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75646602.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c75646602.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>0 then Duel.Recover(tp,1000,REASON_EFFECT) end
	if Duel.GetFlagEffect(tp,75646600)~=0 and Duel.IsPlayerCanDraw(tp,1)	and Duel.SelectYesNo(tp,aux.Stringid(75646602,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c75646602.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c75646602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75646602.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
	if Duel.GetFlagEffect(tp,75646600)>0 then 
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,  LOCATION_GRAVE+LOCATION_REMOVED,0,0,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)  
		end
	end
end