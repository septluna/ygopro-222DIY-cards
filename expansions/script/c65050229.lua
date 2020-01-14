--星月转夜 至高之月
function c65050229.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),8,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050229,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1+EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c65050229.spcon)
	e1:SetCost(c65050229.spcost)
	e1:SetTarget(c65050229.sptg)
	e1:SetOperation(c65050229.spop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c65050229.atlimit)
	c:RegisterEffect(e3)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65050229.indtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c65050229.spcfil(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c65050229.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050229.spcfil,1,nil,tp)
end
function c65050229.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65050229.spfilter(c,e,tp)
	return c:IsSetCard(0x5da9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(65050229)
end
function c65050229.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050229.spfilter(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c65050229.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c65050229.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65050229.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if tc:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x5da9) and Duel.SelectYesNo(aux.Stringid(65050229,0)) then
			local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,nil,0x5da9)
			Duel.Overlay(tc,g)
		end
	end
end

function c65050229.indtg(e,c)
	return c~=e:GetHandler()
end
function c65050229.atlimit(e,c)
	return c~=e:GetHandler()
end