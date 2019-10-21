--相交少女世界
function c81011304.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c81011304.matfilter,nil,nil,aux.NonTuner(Card.IsType,TYPE_RITUAL),1,99)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81011304)
	e1:SetCondition(c81011304.rmcon)
	e1:SetTarget(c81011304.rmtg)
	e1:SetOperation(c81011304.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81011394)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c81011304.sptg2)
	e3:SetOperation(c81011304.spop2)
	c:RegisterEffect(e3)
end
function c81011304.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsAttack(1550) and c:IsDefense(1050))
end
function c81011304.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
end
function c81011304.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function c81011304.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
function c81011304.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsAttack(1550) and c:IsDefense(1050) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(81011304)
end
function c81011304.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81011304.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81011304.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81011304.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81011304.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
