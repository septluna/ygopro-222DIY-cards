--渺奏迷景曲-爱为何物
function c65072027.initial_effect(c)
	aux.AddCodeList(c,65072016)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072027+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65072027.cost)
	e1:SetTarget(c65072027.target)
	e1:SetOperation(c65072027.activate)
	c:RegisterEffect(e1)
end
function c65072027.costfil(c)
	return aux.IsCodeListed(c,65072016) and c:IsAbleToGraveAsCost()
end
function c65072027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072027.costfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) end
	local num1=Duel.GetMatchingGroup(c65072027.costfil,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)
	local num2=Duel.GetMZoneCount(tp)
	if num1>num2 then num1=num2 end
	if num1>3 then num1=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then num1=1 end
	local g=Duel.GetMatchingGroup(c65072027.costfil,tp,LOCATION_DECK,0,nil):SelectSubGroup(tp,aux.dncheck,false,1,num1)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c65072027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(21,0,aux.Stringid(65072027,0))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65072027.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<num
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	for i=1,num do
			local token=Duel.CreateToken(tp,65072015)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			--cannot summon
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65072027.splimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	token:RegisterEffect(e2)
			
		end
		Duel.SpecialSummonComplete()
end
function c65072027.splimit(e,c)
	return not c:IsCode(65071999)
end
