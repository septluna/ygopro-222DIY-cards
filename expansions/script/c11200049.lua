--土著神『宝永四年的赤蛙』
function c11200049.initial_effect(c)
	aux.AddCodeList(c,11200029)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200049)
	e1:SetTarget(c11200049.target)
	e1:SetOperation(c11200049.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200949)
	e2:SetCondition(c11200049.spcon)
	e2:SetTarget(c11200049.sptg)
	e2:SetOperation(c11200049.spop)
	c:RegisterEffect(e2)
end
function c11200049.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_AQUA)
end
function c11200049.matfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_AQUA) and c:IsCanOverlay()
end
function c11200049.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11200049.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200049.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c11200049.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11200049.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11200049.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c11200049.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c11200049.cfilter(c)
	return c:IsControler(tp) and aux.IsCodeListed(c,11200029) and not c:IsCode(11200049)
end
function c11200049.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c11200049.cfilter,1,nil,tp)
end
function c11200049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11200049,0,0x11,0,1800,2,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11200049.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,11200049,0,0x11,0,1800,2,RACE_AQUA,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
