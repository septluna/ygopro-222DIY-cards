--霓色独珠的星夜回忆
function c65050120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050120+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65050120.cost)
	e1:SetTarget(c65050120.target)
	e1:SetOperation(c65050120.activate)
	c:RegisterEffect(e1)
end
function c65050120.costfil(c)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToGraveAsCost()
end
function c65050120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050120.costfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65050120.costfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65050120.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true,POS_FACEUP_DEFENSE) and c:IsSetCard(0x3da8) and c:IsType(TYPE_XYZ)
end
function c65050120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65050120.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050120.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65050120.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g and Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP_DEFENSE)~=0 and g:GetFirst():IsFaceup() then
		g:GetFirst():CompleteProcedure()
		e:GetHandler():CancelToGrave()
		Duel.Overlay(g:GetFirst(),e:GetHandler())
	end
end
