--小花栗 伊瑟琳
function c75646627.initial_effect(c)
	c:SetUniqueOnField(1,0,75646627)
	aux.AddCodeList(c,75646600)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646627.spcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c75646627.drop)
	c:RegisterEffect(e2)
end
function c75646627.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c5)
end
function c75646627.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646627.cfilter,c:GetControler(),LOCATION_MZONE,0,1,c:IsCode(75646627))
end
function c75646627.drfilter(c,re)
	return c:IsCode(75646600) and c:IsReason(REASON_COST) and re:IsHasType(0x7f0)
end
function c75646627.drop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	if not eg:IsExists(c75646627.drfilter,1,nil,re) then return end
	Duel.Hint(HINT_CARD,0,75646627)
	Duel.Draw(tp,1,REASON_EFFECT)
end