--黯食偶像 富利阿洛思
function c65040004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65040004)
	e1:SetCost(c65040004.spcost)
	e1:SetTarget(c65040004.sptg)
	e1:SetOperation(c65040004.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,65040104)
	e2:SetTarget(c65040004.thtg)
	e2:SetOperation(c65040004.thop)
	c:RegisterEffect(e2)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65040004.bccon)
	e3:SetTarget(c65040004.bctg)
	e3:SetOperation(c65040004.bcop)
	c:RegisterEffect(e3)
	--reg
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c65040004.regop)
	c:RegisterEffect(e4)
end
function c65040004.cfilter(c,ft)
	return c:IsSetCard(0x3da3) and c:IsReleasable() and (ft>0 or (ft<=0 and c:IsLocation(LOCATION_MZONE)))
end
function c65040004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c65040004.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),ft) end
	local sg=Duel.SelectMatchingCard(tp,c65040004.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),ft)
	Duel.Release(sg,REASON_COST)
end
function c65040004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65040004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65040004.thfil(c,e,tp)
	return c:IsSetCard(0x3da3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(65040004)
end
function c65040004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65040004.thfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c65040004.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65040004.thfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65040004.bccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(65040004)==0
end

function c65040004.bctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c65040004.bcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)~=0 then
			local life=Duel.GetLP(tp)
			Duel.SetLP(tp,life-800)
		end
	end
end

function c65040004.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END then
	e:GetHandler():RegisterFlagEffect(65040004,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	end
end
