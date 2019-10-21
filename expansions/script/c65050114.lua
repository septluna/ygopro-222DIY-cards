--霓色独珠的起点
function c65050114.initial_effect(c)
	aux.AddRitualProcEqual2(c,c65050114.ritual_filter)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,65050114)
	e1:SetCondition(c65050114.con)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c65050114.tg1)
	e1:SetOperation(c65050114.op1)
	c:RegisterEffect(e1)
end
function c65050114.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x3da8)
end

function c65050114.cfil(c)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c65050114.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050114.cfil,1,nil)
end
function c65050114.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not c:IsSetCard(0x3da8) then return false end
	local m=Duel.GetMatchingGroup(c65050104.matfilter,tp,LOCATION_GRAVE,0,c)
	return m:GetCount()>0 and m:CheckWithSumEqual(Card.GetRitualLevel,8,1,99,c) 
end
function c65050114.matfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x3da8) and c:IsLevelAbove(1)
end
function c65050114.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c65050114.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
--
function c65050114.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c65050114.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local mg=Duel.GetMatchingGroup(c65050114.matfilter,tp,LOCATION_GRAVE,0,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end