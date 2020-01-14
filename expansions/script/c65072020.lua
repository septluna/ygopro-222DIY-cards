--渺奏迷景曲-七色遐想
function c65072020.initial_effect(c)
	aux.AddCodeList(c,65072016)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65072020.target)
	e1:SetOperation(c65072020.activate)
	c:RegisterEffect(e1)
end
function c65072020.tgfil(c)
	return aux.IsCodeListed(c,65072016) and c:IsFaceup()
end
function c65072020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) and Duel.IsExistingMatchingCard(c65072020.tgfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(11,0,aux.Stringid(65072020,0))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65072020.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) or not Duel.IsExistingMatchingCard(c65072020.tgfil,tp,LOCATION_GRAVE,0,1,nil) then return end
	local g=Duel.GetMatchingGroup(c65072020.tgfil,tp,LOCATION_GRAVE,0,nil)
	local num=g:GetClassCount(Card.GetCode)
	if num>Duel.GetLocationCount(tp,LOCATION_MZONE) then num=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then num=1 end
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
	e1:SetTarget(c65072020.splimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	token:RegisterEffect(e2)
			if i==num or not Duel.SelectYesNo(tp,aux.Stringid(65072020,2)) then break end
		end
		Duel.SpecialSummonComplete()
end
function c65072020.splimit(e,c)
	return not c:IsCode(65071999)
end