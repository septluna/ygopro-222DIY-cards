--孤立无援的造形神
function c33330099.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c33330099.lcheck)
	c:EnableReviveLimit()
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33330099.sptg)
	e1:SetOperation(c33330099.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c33330099.spcon)
	e2:SetTarget(c33330099.sptg)
	e2:SetOperation(c33330099.spop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(2)
	e3:SetCondition(c33330099.con)
	e3:SetTarget(c33330099.tg)
	e3:SetOperation(c33330099.op)
	c:RegisterEffect(e3)
	 --cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c33330099.imcon)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_REMOVE)
	e9:SetCondition(c33330099.imcon2)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetValue(1)
	c:RegisterEffect(e10)
end
function c33330099.afilter(c)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_EFFECT)==0 and c:IsType(TYPE_MONSTER)
end
function c33330099.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33330099.afilter,1,nil)
end
function c33330099.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c33330099.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		if c:RegisterEffect(e1)~=0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c33330099.imconfil(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function c33330099.imcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c33330099.imconfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c33330099.imcon2(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c33330099.imconfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and e:GetHandler():IsReason(REASON_EFFECT) 
end
function c33330099.lcfil(c)
	return not c:IsType(TYPE_EFFECT)
end
function c33330099.lcheck(g,lc)
	return g:IsExists(c33330099.lcfil,1,nil)
end
function c33330099.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33330099.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33330085,0,0x4011,2800,0,8,RACE_SPELLCASTER,ATTRIBUTE_EARTH,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33330099.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33330085,0,0x4011,2800,0,8,RACE_SPELLCASTER,ATTRIBUTE_EARTH,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,33330085)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end