--幻海深渊 伊瑟琳
function c75646618.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c75646618.matfilter,1,1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646618,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,75646618)
	e1:SetCondition(c75646618.eqcon)
	e1:SetTarget(c75646618.eqtg)
	e1:SetOperation(c75646618.eqop)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28806532,0))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,5646618)
	e2:SetCondition(c75646618.con)
	e2:SetTarget(c75646618.tg)
	e2:SetOperation(c75646618.op)
	c:RegisterEffect(e2)
end
function c75646618.matfilter(c)
	return c:IsLinkRace(RACE_CYBERSE) and not c:IsLinkType(TYPE_LINK)
end
function c75646618.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c75646618.filter(c,ec)
	return c:IsCode(75646606) and c:CheckEquipTarget(ec)
end
function c75646618.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c75646618.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75646618.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c75646618.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.Equip(tp,g:GetFirst(),c)
		if Duel.GetFlagEffect(tp,75646600)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetCondition(c75646618.imcon)
			e1:SetValue(c75646618.imfilter)
			e1:SetOwnerPlayer(tp)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
function c75646618.cfilter(c)
	return aux.IsCodeListed(c,75646600) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c75646618.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646618.cfilter,1,nil)
end
function c75646618.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
end
function c75646618.spcfilter(c)
	return c:IsCode(75646600)
end
function c75646618.spfilter(c,e,tp)
	return c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646618.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local sg=Duel.GetMatchingGroup(c75646618.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	Duel.Recover(p,d,REASON_EFFECT)
	if (eg:IsExists(c75646618.spcfilter,1,nil) or Duel.GetFlagEffect(tp,75646600)>0) and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75646618,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end