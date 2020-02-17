--ZEON-龟霸
local m=11700012
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(cm.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCountLimit(1,m+10000) 
	e5:SetTarget(cm.sptg2)
	e5:SetOperation(cm.spop2)
	c:RegisterEffect(e5)
end
function cm.incon(e)
	return e:GetHandler():GetOverlayCount()>0
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x280,0x4011,1550,1550,4,RACE_MACHINE,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x280,0x4011,1550,1550,4,RACE_MACHINE,ATTRIBUTE_WATER) then
		local token1=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local token2=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

function cm.cfilter(c,tp)
	return c:IsType(TYPE_TOKEN)
		and c:IsControler(tp) and c:GetSequence()<5
end
function cm.filter(c,e,tp)
	return c:IsLevel(4) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,2,nil,tp)and  Duel.IsExistingTarget(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)  
	local g2=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,tp)   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,tp,LOCATION_MZONE)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,2,nil,tp)and Duel.IsExistingTarget(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp)) then  return end 
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)  
	local g2=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,tp)  
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg2=g2:Select(tp,2,2,nil)
	if Duel.Destroy(tg2,tp,REASON_EFFECT)==2 then 
	local tg1=g1:Select(tp,1,1,nil)
		Duel.SpecialSummon(tg1,0,tp,tp,false,false,POS_FACEUP)
	end
end




