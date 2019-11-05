--造神计划7 赤游鱼
function c33330107.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c33330107.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33330107.cost)
	e1:SetTarget(c33330107.tg)
	e1:SetOperation(c33330107.op)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c33330107.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function c33330107.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_AQUA)
end
function c33330107.disable(e,c)
	local tp=e:GetHandlerPlayer()
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and (lg1:IsContains(c) or c:GetLinkedGroupCount()>0) and not c:IsRace(RACE_AQUA)
end

function c33330107.costgfil(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_AQUA) and c:GetLinkedGroupCount()>0
end
function c33330107.relfil(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function c33330107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Group.CreateGroup()
	local alg=Duel.GetMatchingGroup(c33330107.costgfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local alc=alg:GetFirst()
	while alc do
		local alcg=alc:GetLinkedGroup()
		lg:Merge(alcg)
		alc=alg:GetNext()
	end
	if chk==0 then return lg and lg:IsExists(c33330107.relfil,1,nil,tp) end
	local g=lg:FilterSelect(tp,c33330107.relfil,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c33330107.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_AQUA) and not c:IsCode(33330107)
end
function c33330107.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330107.spfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c33330107.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c33330107.spfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end