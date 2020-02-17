--质点的宣托
local m=12004000
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12004000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,12004000+100)
	e1:SetCondition(c12004000.spcon)
	e1:SetTarget(c12004000.sptg)
	e1:SetOperation(c12004000.spop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCondition(c12004000.spcon1)
	e11:SetDescription(aux.Stringid(12004000,2))
	e11:SetCountLimit(1,12004000+200)
	c:RegisterEffect(e11)
	local e12=e1:Clone()
	e12:SetCondition(c12004000.spcon2)
	e12:SetDescription(aux.Stringid(12004000,3))
	e12:SetCountLimit(1,12004000+300)
	c:RegisterEffect(e12)
	local e13=e1:Clone()
	e13:SetCondition(c12004000.spcon3)
	e13:SetDescription(aux.Stringid(12004000,4))
	e13:SetCountLimit(1,12004000+400)
	c:RegisterEffect(e13)
	local e14=e1:Clone()
	e14:SetCondition(c12004000.spcon4)
	e14:SetDescription(aux.Stringid(12004000,5))
	e14:SetCountLimit(1,12004000+500)
	c:RegisterEffect(e14)
	local e15=e1:Clone()
	e15:SetCondition(c12004000.spcon5)
	e15:SetDescription(aux.Stringid(12004000,6))
	e15:SetCountLimit(1,12004000+100)
	c:RegisterEffect(e15)

	--sp Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12004000,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c12004000.condition)
	e2:SetTarget(c12004000.target)
	e2:SetOperation(c12004000.activate)
	c:RegisterEffect(e2)
end
function c12004000.cfilter(c,tp,att)
	return c:GetPreviousControler()==tp and c:IsRace(RACE_WARRIOR) and c:IsAttribute(att)
end
function c12004000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local att=ATTRIBUTE_DARK 
	local tc=eg:Filter(c12004000.cfilter,nil,tp,att)
	e:SetLabel(att)
	return tc:GetCount()>0
end
function c12004000.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local att=ATTRIBUTE_WIND 
	local tc=eg:Filter(c12004000.cfilter,nil,tp,att)
	e:SetLabel(att)
	return tc:GetCount()>0
end
function c12004000.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local att=ATTRIBUTE_EARTH 
	local tc=eg:Filter(c12004000.cfilter,nil,tp,att)
	e:SetLabel(att)
	return tc:GetCount()>0
end
function c12004000.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local att=ATTRIBUTE_FIRE 
	local tc=eg:Filter(c12004000.cfilter,nil,tp,att)
	e:SetLabel(att)
	return tc:GetCount()>0
end
function c12004000.spcon4(e,tp,eg,ep,ev,re,r,rp)
	local att=ATTRIBUTE_LIGHT 
	local tc=eg:Filter(c12004000.cfilter,nil,tp,att)
	e:SetLabel(att)
	return tc:GetCount()>0
end
function c12004000.spcon5(e,tp,eg,ep,ev,re,r,rp)
	local att=ATTRIBUTE_WATER 
	local tc=eg:Filter(c12004000.cfilter,nil,tp,att)
	e:SetLabel(att)
	return tc:GetCount()>0
end
function c12004000.sfilter(c,e,tp,att)
	return c:IsSetCard(0xfb1) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12004000.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local att=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c12004000.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp,att)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12004000.spop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c12004000.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,att)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c12004000.cfilter1(c)
	return c:GetSequence()<5
end
function c12004000.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12004000.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c12004000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12003011,0,0x4011,800,1000,3,RACE_SEASERPENT,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12004000.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,12003011,0,0x4011,800,1000,3,RACE_SEASERPENT,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,12003011)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e2,true)
	Duel.SpecialSummonComplete()
        local c=e:GetHandler()
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetTargetRange(1,0)
	e11:SetTarget(c12004000.splimit)
	e11:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e11,tp)
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_EXTRA)
end
