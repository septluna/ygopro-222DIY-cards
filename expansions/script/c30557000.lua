--永辉真理 公理系统
function c30557000.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c30557000.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x306),true)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetCondition(c30557000.con)
	e1:SetTarget(c30557000.tg)
	e1:SetOperation(c30557000.op)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,30557002)
	e2:SetCondition(c30557000.condition)
	e2:SetOperation(c30557000.activate)
	c:RegisterEffect(e2)
	 --special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(30557000,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1,30557000)
	e5:SetTarget(c30557000.sptg)
	e5:SetOperation(c30557000.spop)
	c:RegisterEffect(e5)
end
function c30557000.repop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
end
function c30557000.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep~=tp 
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)>0 
end
function c30557000.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c30557000.repop)
end
function c30557000.matfilter(c)
	return c:IsFusionSetCard(0x306) and c:IsFusionType(TYPE_FUSION)
end
function c30557000.confil(c,tp)
	return c:GetPreviousControler()==tp and c:IsAbleToHand()
end
function c30557000.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30557000.confil,1,nil,tp)
end
function c30557000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c30557000.confil,nil,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c30557000.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c30557000.confil,nil,tp)
	if g:GetCount()>0 then
		local num=Duel.SendtoHand(g,tp,REASON_EFFECT)
		if num>0 then
			local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,num,nil)
			Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		end
	end
end

function c30557000.spfilter(c,e,tp)
	return c:IsSetCard(0x306) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30557000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30557000.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c30557000.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30557000.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end