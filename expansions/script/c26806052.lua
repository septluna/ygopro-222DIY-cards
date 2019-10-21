--未知错误·赤羽
function c26806052.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c26806052.sfilter),1,1)
	c:EnableReviveLimit()
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26806052)
	e1:SetTarget(c26806052.destg)
	e1:SetOperation(c26806052.desop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,26806952)
	e3:SetCondition(c26806052.spcon)
	e3:SetTarget(c26806052.sptg)
	e3:SetOperation(c26806052.spop)
	c:RegisterEffect(e3)
end
function c26806052.sfilter(c)
	return c:IsAttack(2200) and c:IsDefense(600)
end
function c26806052.rmfilter(c)
	return c:IsAttack(2200) and c:IsDefense(600) and c:IsAbleToRemove()
end
function c26806052.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26806052.rmfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c26806052.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==sg:GetCount()
end
function c26806052.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local ct=dg:GetCount()
	local g=Duel.GetMatchingGroup(c26806052.rmfilter,tp,LOCATION_GRAVE,0,nil)
	if ct==0 or g:GetCount()==0 then return end
	local rg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		rg:Merge(sg)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		ct=ct-1
	until ct==0 or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(26806052,0))
	local rc=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	if rc>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,rc,rc,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c26806052.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c26806052.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsAttack(2200) and c:IsDefense(600) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26806052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26806052.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,tp,LOCATION_REMOVED)
end
function c26806052.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c26806052.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
