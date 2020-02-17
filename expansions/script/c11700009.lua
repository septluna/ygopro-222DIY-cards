--ZEON-强人
local m=11700009
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(cm.atlimit)
	c:RegisterEffect(e2)
  --cannot be target
	local e3=Effect.CreateEffect(c)
   e3:SetType(EFFECT_TYPE_FIELD)
   e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
   e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
   e3:SetRange(LOCATION_MZONE)
   e3:SetTargetRange(LOCATION_MZONE,0)
   e3:SetTarget(cm.tgtg)
   e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
--spsummon
	 local e4=Effect.CreateEffect(c)
   e4:SetDescription(aux.Stringid(m,0))
   e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e4:SetCode(EVENT_TO_GRAVE)
   e4:SetCondition(cm.spcon2)
   e4:SetTarget(cm.sptg2)
   e4:SetOperation(cm.spop2)
	c:RegisterEffect(e4)
end
function cm.spfilter1(c)
	return c:IsSetCard(0x280) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.spfilter1,c:GetControler(),LOCATION_HAND,0,1,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end

function cm.atlimit(e,c)
	return c~=e:GetHandler()
end

function cm.tgtg(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x114)
end

function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x280) and (not c:IsCode(m) )and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
