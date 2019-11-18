--反击的白刃·阿尼耶丝
local m=17030029
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17030029,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.atkcon)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--spsummon voice
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetOperation(cm.sumsuc)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	--atk voice
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ATTACK_ANNOUNCE)
	e9:SetOperation(cm.atksuc)
	c:RegisterEffect(e9)
	--destroy voice
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_DESTROYED)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCondition(cm.descon)
	e10:SetOperation(cm.dessuc)
	c:RegisterEffect(e10)
end
function cm.filter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.rccfilter(c)
	return c:IsFaceup() and c:IsCode(17030001)
end
function cm.atkcon(e)
	return Duel.IsExistingMatchingCard(cm.rccfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.atkval(e,c)
	local lps=Duel.GetLP(c:GetControler())
	local lpo=Duel.GetLP(1-c:GetControler())
	if lps>=lpo then return 0
	else return lpo-lps end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE+LOCATION_SZONE) and c:IsFaceup()
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(17030029,1))
end	
function cm.atksuc(e,tp,eg,ep,ev,re,r,rp)
	local lps=Duel.GetLP(tp)
	local lpo=Duel.GetLP(1-tp)
	if lps>=lpo then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17030029,2))
	else
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17030029,3))
	end
end
function cm.dessuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(17030029,4))
end