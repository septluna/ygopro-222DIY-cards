function c82221009.initial_effect(c)  
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x292),aux.FilterBoolFunction(Card.IsFusionSetCard,0x1292),false)
	--cannot spsummon  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetRange(LOCATION_EXTRA)  
	e0:SetValue(c82221009.splimit)  
	c:RegisterEffect(e0)  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221009,0))  
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)  
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e1:SetHintTiming(TIMING_DAMAGE_STEP)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,82221009)
	e1:SetCondition(c82221009.tgcon)
	e1:SetTarget(c82221009.tgtg)  
	e1:SetOperation(c82221009.tgop)  
	c:RegisterEffect(e1) 
	--Special Summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221009,1))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetCountLimit(1,82231009)
	e2:SetCondition(c82221009.descon)  
	e2:SetTarget(c82221009.destg)  
	e2:SetOperation(c82221009.desop)  
	c:RegisterEffect(e2)   
end
function c82221009.splimit(e,se,sp,st)  
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION  
end  
function c82221009.tgfilter(c)  
	return c:IsRace(RACE_WINDBEAST) and c:IsAbleToGrave()  
end  
function c82221009.tgcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()  
end  
function c82221009.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c82221009.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil) 
end  
function c82221009.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c82221009.tgfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and c:IsFaceup() then  
		local atk=g:GetFirst():GetAttack()
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		e1:SetValue(atk)  
		tc:RegisterEffect(e1)  
	end  
end  
function c82221009.descon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)  
end  
function c82221009.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)  
end  
function c82221009.desop(e,tp,eg,ep,ev,re,r,rp)  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)  
	Duel.Destroy(sg,REASON_EFFECT)  
end  