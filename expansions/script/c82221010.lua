function c82221010.initial_effect(c)  
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x292),3,99,false)
	--cannot target  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e1:SetValue(aux.tgoval)  
	c:RegisterEffect(e1) 
	--mudamuda  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221010,0))  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetCountLimit(1,82221010)  
	e2:SetCondition(c82221010.mdcon)  
	e2:SetOperation(c82221010.mdop)  
	c:RegisterEffect(e2)  
	--oraora  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221010,1))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_BATTLE_DESTROYING) 
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,82231010) 
	e3:SetCondition(aux.bdocon)  
	e3:SetTarget(c82221010.ortg)  
	e3:SetOperation(c82221010.orop)  
	c:RegisterEffect(e3)  
end
function c82221010.mdcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)  
end  
function c82221010.mdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)	
	e1:SetTargetRange(0,LOCATION_MZONE) 
	e1:SetCode(EFFECT_SET_ATTACK)  
	e1:SetReset(RESET_PHASE+PHASE_END,2)  
	e1:SetValue(0)  
	Duel.RegisterEffect(e1,tp) 
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	Duel.RegisterEffect(e2,tp)  
end
function c82221010.orfilter(c,e,tp)  
	return c:IsSetCard(0x292) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
end  
function c82221010.ortg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82221010.orfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function c82221010.orop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82221010.orfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)  
	end  
end  