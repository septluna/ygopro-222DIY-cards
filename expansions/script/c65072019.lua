--渺奏迷景曲-海誓山盟
function c65072019.initial_effect(c)
	 aux.AddCodeList(c,65072016)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072019+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65072019.target)
	e1:SetOperation(c65072019.activate)
	c:RegisterEffect(e1)
end
function c65072019.tgfil(c)
	return c:IsSetCard(0xcda7) and c:IsFaceup()
end
function c65072019.tgfil2(c)
	return aux.IsCodeListed(c,65072016) and c:IsFaceup()
end
function c65072019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) and Duel.IsExistingMatchingCard(c65072019.tgfil,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65072019,0))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65072019.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local num=1
	if Duel.IsExistingMatchingCard(c65072019.tgfil2,tp,LOCATION_FZONE,0,1,nil) and Duel.GetMZoneCount(tp)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then num=2 end
	for i=1,num do
			local token=Duel.CreateToken(tp,65072015)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			if i==num or not Duel.SelectYesNo(tp,aux.Stringid(65072019,2)) then break end
		end
		Duel.SpecialSummonComplete()
end