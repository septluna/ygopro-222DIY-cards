--鸢一折纸 星下相游
function c33400401.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33400401,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_EQUIP)
	e0:SetCountLimit(1,33400401)
	e0:SetCondition(c33400401.spcon)
	e0:SetTarget(c33400401.sptg1)
	e0:SetOperation(c33400401.spop1)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetOperation(c33400401.thp)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400401,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33400401+10000)
	e2:SetLabelObject(e1)
	e2:SetCondition(c33400401.thcon)
	e2:SetTarget(c33400401.thtg)
	e2:SetOperation(c33400401.thop)
	c:RegisterEffect(e2)
end
function c33400401.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x6343) or eg:IsExists(Card.IsSetCard,1,nil,0x5343)
end
function c33400401.spfilter1(c,e,tp)
	return c:IsLevelBelow(4) and (c:IsSetCard(0x341) or c:IsSetCard(0x5342)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400401.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33400401.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33400401.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400401.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c33400401.thp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zg=e:GetHandler():GetEquipGroup()
	if zg:IsExists(Card.IsSetCard,1,nil,0x6343) or zg:IsExists(Card.IsSetCard,1,nil,0x5343) then ct=1 
	else
	 ct=0 
	end
	e:SetLabel(ct)
end
function c33400401.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local ct=e:GetLabelObject():GetLabel()
	return ct==1 and c:IsLocation(LOCATION_GRAVE) and (rc:IsSetCard(0x341) or rc:IsSetCard(0x5342)) and r&REASON_FUSION+REASON_LINK~=0
end
function c33400401.thfilter(c)
	return c:IsSetCard(0x6343) and c:IsAbleToHand()
end
function c33400401.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c33400401.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400401.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33400401.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33400401.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end