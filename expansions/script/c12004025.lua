--睿智之泉 拉结尔
local m=12004025
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c12004025.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12004025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12004025)
	e1:SetCondition(c12004025.hspcon)
	e1:SetTarget(c12004025.hsptg)
	e1:SetOperation(c12004025.hspop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12004025,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12004025+100)
	e2:SetCondition(c12004025.atkcon)
	e2:SetTarget(c12004025.atktg)
	e2:SetOperation(c12004025.atkop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCountLimit(1,12004025+200)
	e4:SetCondition(c12004025.atkcon1)
	c:RegisterEffect(e4)  
end
function c12004025.lcheck(g,lc)
	return g:IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end
function c12004025.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12004025.hspfilter(c,e,tp)
	return ( c:IsSetCard(0x1fbd) or c:IsSetCard(0xfb1) )and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c12004025.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12004025.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12004025.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12004025.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c12004025.cfilter(c,tp,sumt)
	return c:IsFaceup() and c:IsSetCard(0xfb1) and c:IsSummonType(sumt) and c:GetSummonPlayer()==tp
end
function c12004025.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12004025.cfilter,1,nil,tp,SUMMON_TYPE_FUSION)
end
function c12004025.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,12004024)
end
function c12004025.sfilter(c,e,tp)
	return c:GetAttack()==3300 and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12004025.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFirstMatchingCard(c12004025.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12004025.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12004025.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
