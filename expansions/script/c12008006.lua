--双色的恋意
local m=12008006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c12008006.cost)
	e1:SetTarget(c12008006.tg)
	e1:SetOperation(c12008006.op)
	c:RegisterEffect(e1)
	--recover
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c12008006.spcon)
	e2:SetTarget(c12008006.sptg)
	e2:SetOperation(c12008006.spop)
	c:RegisterEffect(e2)
--  if not c12008006.global_check then
--  c12008006.global_check=true
--  local ge1=Effect.CreateEffect(c)
--  ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--  ge1:SetCode(EVENT_CHAINING)
--  ge1:SetOperation(c12008006.checkop)
--  Duel.RegisterEffect(ge1,0)
--  end  
end

-- function c12008006.checkop(e,tp,eg,ep,ev,re,r,rp)
--  if not eg then return end
--  if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsCode(12008006) then
--  Duel.RegisterFlagEffect(tp,12008006,RESET_PHASE+PHASE_END,0,1)
--  end
--end
function c12008006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,12008006,RESET_PHASE+PHASE_END,0,1) 
end
function c12008006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c12008006.spfilter(c)
	return c:IsCode(12008006) 
end
function c12008006.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if true then Duel.Recover(p,d,REASON_EFFECT)  end
	local sg=Duel.GetMatchingGroup(c12008006.spfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c12008006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c12008006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffect(tp,12008006)
	if ct<=0 then
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,800) end
	if ct>=1 then
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end
	if ct>=3 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) end
	if ct==5 then
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,20000)
	end
end
function c12008006.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12008006.spfilter2(c)
	return c:IsCode(12008006) and c:IsAbleToHand()
end
function c12008006.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,12008006)
	if ct<=0 then Duel.Damage(tp,800,REASON_EFFECT) end
	if ct>=1 then Duel.Draw(tp,1,REASON_EFFECT) end 
	if ct>=3 and Duel.IsExistingMatchingCard(c12008006.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and  Duel.SelectYesNo(tp,aux.Stringid(12008006,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local g=Duel.SelectMatchingCard(tp,c12008006.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		 if g:GetCount()>0 then
		 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		 end
	 end
	 if ct==5 then 
	 Duel.Recover(tp,20000,REASON_EFFECT)
	 end 
end