--混沌饿融合鱼
function c33330086.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33330086.ffilter,3,true)
	--tohand
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c33330086.con)
	e0:SetTarget(c33330086.tg)
	e0:SetOperation(c33330086.op)
	c:RegisterEffect(e0)
	--att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c33330086.attval)
	c:RegisterEffect(e1)
end
function c33330086.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (
			not sg:IsExists(Card.IsAttribute,1,c,c:GetAttribute()))
end
function c33330086.attval(e,c)
	local c=e:GetHandler()
	local og=c:GetMaterial()
	local wbc=og:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=og:GetNext()
	end
	return att
end
function c33330086.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c33330086.tgfil(c,att)
	return c:IsAbleToHand() and c:IsAttribute(att)
end
function c33330086.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330086.tgfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e:GetHandler():GetAttribute()) end
	local g=Duel.GetMatchingGroup(c33330086.tgfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,e:GetHandler():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c33330086.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33330086.tgfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,e:GetHandler():GetAttribute())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
