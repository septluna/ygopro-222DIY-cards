--平行四界·诗岸
local m=26806015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,e,tp,ec)
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	return c:IsFaceup() and c:IsAttack(3200) and c:IsType(TYPE_LINK) and zone>0 and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1,true)
		end
	end
end
