--一反常态·梦前菜菜
function c81011043.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81011043)
	e1:SetTarget(c81011043.sptg)
	e1:SetOperation(c81011043.spop)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81011943)
	e2:SetCondition(c81011043.rcon)
	e2:SetOperation(c81011043.rop)
	c:RegisterEffect(e2)
end
function c81011043.tfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToHand()
		and c:IsAttribute(ATTRIBUTE_WATER) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c81011043.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81011043.tfilter(chkc,tp) end
	if chk==0 then
		return Duel.GetMZoneCount(tp)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(c81011043.tfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81011043.tfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81011043.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		if Duel.GetMZoneCount(tp)<1 then return end
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c81011043.rcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
		and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToDeckAsCost() and ep==e:GetOwnerPlayer()
end
function c81011043.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
