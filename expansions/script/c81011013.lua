--花嫁·黑崎智秋
function c81011013.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,81011013)
	e2:SetTarget(c81011013.tg)
	e2:SetOperation(c81011013.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c81011013.ccon)
	c:RegisterEffect(e3)
end
function c81011013.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and ep~=tp
end
function c81011013.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_SZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	elseif e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
	end
end
function c81011013.thfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSSetable() and not c:IsCode(81011013)
end
function c81011013.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
			if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c81011013.thfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(81011013,0)) then
				Duel.BreakEffect()
				local g=Duel.SelectMatchingCard(tp,c81011013.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SSet(tp,g:GetFirst())
			end
		end
	end
end
