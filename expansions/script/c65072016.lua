--渺奏迷景-寂静山林
function c65072016.initial_effect(c)
	aux.AddCodeList(c,65072016)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072016+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65072016.cost)
	e1:SetTarget(c65072016.target)
	e1:SetOperation(c65072016.activate)
	c:RegisterEffect(e1)
end
function c65072016.costfil(c)
	return c:IsDiscardable() and c:IsSetCard(0xcda7)
end
function c65072016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072016.costfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65072016.costfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	local c=g:GetFirst()
	local op=0
	if aux.IsCodeListed(c,65072016) then op=1 end
	e:SetLabel(op)
end
function c65072016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65072016.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) or Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<=0 then return end
	local num=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if e:GetLabel()==1 then num=num+1 end
	if num>Duel.GetLocationCount(tp,LOCATION_MZONE) then num=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then num=1 end
	for i=1,num do
		local token=Duel.CreateToken(tp,65072015)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		if i==num or not Duel.SelectYesNo(tp,aux.Stringid(65072016,2)) then break end
	end
	Duel.SpecialSummonComplete()
end
