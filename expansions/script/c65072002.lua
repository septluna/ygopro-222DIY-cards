--渺奏迷景-少女奇境
function c65072002.initial_effect(c)
	aux.AddCodeList(c,65072000)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65072002.target)
	e1:SetOperation(c65072002.activate)
	c:RegisterEffect(e1)
end
function c65072002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.Hint(21,0,aux.Stringid(65072002,0))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65072002.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65071999,0,0x4011,2100,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,65071999)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	--cannot summon
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65072002.splimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	token:RegisterEffect(e2,true)
	--effect gain
	local e3=Effect.CreateEffect(token)
	e3:SetDescription(aux.Stringid(65072002,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetCountLimit(1)
	e3:SetTarget(c65072002.eftg)
	e3:SetOperation(c65072002.efop)
	token:RegisterEffect(e3,true)
	--become effect
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetValue(TYPE_EFFECT)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e4,true)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetValue(TYPE_NORMAL)
	token:RegisterEffect(e5,true)
	token:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65072002,2))
	Duel.SpecialSummonComplete()
end
function c65072002.splimit(e,c)
	return not c:IsCode(65071999)
end
function c65072002.eftgfil(c)
	return c:IsType(TYPE_FIELD) and aux.IsCodeListed(c,65072000)
end
function c65072002.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingTarget(c65072002.eftgfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65072002.eftgfil,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c65072002.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_FZONE,0,nil)
	if g:GetCount()>0 then
		local code=e:GetLabel()
		local tc=g:GetFirst()
		local cid=tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
	end
end
