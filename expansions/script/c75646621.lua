--片翼
function c75646621.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--end battle phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646621,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646621.condition)
	e1:SetCost(c75646621.cost)
	e1:SetTarget(c75646621.target)
	e1:SetOperation(c75646621.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646621,4))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,75646621)
	e2:SetTarget(c75646621.thtg)
	e2:SetOperation(c75646621.thop)
	c:RegisterEffect(e2)
end
function c75646621.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp 
end
function c75646621.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsDiscardable() end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp)
end
function c75646621.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646621.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	local g=Duel.GetMatchingGroup(c75646621.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,e:GetHandler(),tp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,e:GetHandler()):GetFirst()
	local te=tc:IsHasEffect(75646628,tp)
	if te then
		e:SetLabel(1)
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		if tc:IsCode(75646600) then e:SetLabel(1) end
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c75646621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75646621.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
		if (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)>0) and  ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,75646622,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE)
		and Duel.SelectYesNo(tp,aux.Stringid(75646621,0)) then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			local ct=1
			if ft>1 then
				local num={}
				local i=1
				while i<=ft do
					num[i]=i
					i=i+1
				end
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646621,1))
				ct=Duel.AnnounceNumber(tp,table.unpack(num))	
			end
			repeat
				local token=Duel.CreateToken(tp,75646622)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
				ct=ct-1
			until ct==0
			Duel.SpecialSummonComplete()
		end
	end
end
function c75646621.cfilter(c,e,tp)
	return  aux.IsCodeListed(c,75646600) and c:IsControler(tp) 
		and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c75646621.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c75646621.cfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c75646621.cfilter,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=eg:FilterSelect(tp,c75646621.cfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75646621.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and (tc:IsCode(75646600) or Duel.GetFlagEffect(tp,75646600)>0) and Duel.SelectYesNo(tp,aux.Stringid(75646621,2)) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		elseif c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		end
	end
end