--原罪机械 Sloth 席杜梅
function c12004005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12004005,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c12004005.ttcon1)
	e1:SetOperation(c12004005.ttop1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12004005,2))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetTargetRange(POS_FACEUP_ATTACK,1)
	e2:SetCondition(c12004005.ttcon2)
	e2:SetOperation(c12004005.ttop2)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(c12004005.setcon)
	c:RegisterEffect(e3)

	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12004005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c12004005.spcon)
	e3:SetTarget(c12004005.sptg)
	e3:SetOperation(c12004005.spop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c12004005.valcheck)
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
end
function c12004005.ttcon1(e,c,minc)
	if c==nil then return true end
	return minc<=2 and Duel.CheckTribute(c,2)
end
function c12004005.ttop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c12004005.ttcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return --minc<=1 and 
 Duel.CheckTribute(c,1,2,mg,1-tp)
end
function c12004005.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,1,2,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c12004005.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c12004005.valcheck(e,c)
	local tc=0
	local g=c:GetMaterial()
	local tc=g:GetCount()
	e:GetLabelObject():SetLabel(tc)
end
function c12004005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c12004005.tgfilter(c)
	return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c12004005.spfilter(c,e,tp)
	return c:IsAttackAbove(2400) and c:IsDefense(1000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12004005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,nil,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c12004005.spop(e,tp,eg,ep,ev,re,r,rp)
	local tt=e:GetLabel()
	Duel.Draw(tp,tt,REASON_EFFECT)
	if tt>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,12003011,0,0x4011,800,1000,3,RACE_SEASERPENT,ATTRIBUTE_WATER,1-tp) then 
		local token=Duel.CreateToken(tp,12003011)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end 
	if tt-1>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,12003011,0,0x4011,800,1000,3,RACE_SEASERPENT,ATTRIBUTE_WATER,1-tp) then 
		local token=Duel.CreateToken(tp,12003011)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end 
	Duel.SpecialSummonComplete()
end