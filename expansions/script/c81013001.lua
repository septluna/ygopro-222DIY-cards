--绫濑亚梦·忘却
function c81013001.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c81013001.ffiltera,c81013001.ffilterb,2,true)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c81013001.immcon)
	e0:SetValue(c81013001.efilter)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81013001,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81013001)
	e1:SetTarget(c81013001.destg)
	e1:SetOperation(c81013001.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,81013901)
	e2:SetTarget(c81013001.sptg)
	e2:SetOperation(c81013001.spop)
	c:RegisterEffect(e2)
end
function c81013001.ffiltera(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsRace(RACE_PLANT) and c:IsFusionAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(9)
end
function c81013001.ffilterb(c)
	return (not c:IsType(TYPE_TOKEN)) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c81013001.bfilter(c,tp)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c81013001.cfilter,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end
function c81013001.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c81013001.immcon(e)
	return Duel.IsExistingMatchingCard(c81013001.bfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c81013001.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c81013001.desfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c81013001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and c81013001.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81013001.desfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c81013001.desfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c81013001.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c81013001.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81013001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c81013001.spfilter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81013001.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81013001.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81013001.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
