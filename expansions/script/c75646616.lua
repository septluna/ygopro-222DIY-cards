--科学的原点 SCIENCE
function c75646616.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646616,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646616+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75646616.target)
	e1:SetOperation(c75646616.activate)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75646616.tg)
	e2:SetOperation(c75646616.op)
	c:RegisterEffect(e2)
end
function c75646616.tgfilter(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c75646616.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646616.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75646616.filter(c,e,tp)
	return aux.IsCodeListed(c,75646600) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646616.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local sg=Duel.GetMatchingGroup(c75646616.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646616.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Recover(p,d,REASON_EFFECT)
		if Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75646616,1))
		then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c75646616.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c75646616.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end