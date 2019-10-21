--华丽空色·多田李衣菜
function c81008022.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,10,2,nil,nil,99)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81008022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81008022)
	e1:SetCondition(c81008022.spcon)
	e1:SetTarget(c81008022.sptg)
	e1:SetOperation(c81008022.spop)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81008022,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81008922)
	e2:SetCondition(c81008022.rcon)
	e2:SetOperation(c81008022.rop)
	c:RegisterEffect(e2)
end
function c81008022.rfilter(c,oc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,oc,REASON_COST)
end
function c81008022.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)
		and re:IsActiveType(TYPE_XYZ) and ep==e:GetOwnerPlayer()
		and Duel.IsExistingMatchingCard(c81008022.rfilter,tp,LOCATION_MZONE,0,1,rc,ev)
end
function c81008022.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local rc=re:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,c81008022.rfilter,tp,LOCATION_MZONE,0,1,1,rc,min)
	return tg:GetFirst():RemoveOverlayCard(tp,min,max,REASON_EFFECT)
end
function c81008022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c81008022.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsRankBelow(10) and not c:IsCode(81008022) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81008022.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81008022.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81008022.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81008022.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81008022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsRelateToEffect(e) and c:GetOverlayCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81008022,1))
		local mg=c:GetOverlayGroup():Select(tp,1,1,nil)
		local oc=mg:GetFirst():GetOverlayTarget()
		Duel.Overlay(tc,mg)
		Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	end
end
