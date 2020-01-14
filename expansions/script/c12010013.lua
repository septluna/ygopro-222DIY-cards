--LA SG Gluttony 阿庫亞
function c12010013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c12010013.spcon)
	e1:SetOperation(c12010013.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010013,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12010013)
	e2:SetCost(c12010013.cost)
	e2:SetTarget(c12010013.tgtg)
	e2:SetOperation(c12010013.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12010013,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1200113)
	e3:SetCost(c12010013.cost)
	e3:SetTarget(c12010013.tgtg)
	e3:SetOperation(c12010013.tgop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(12010013,ACTIVITY_SPSUMMON,c12010013.counterfilter)
end
function c12010013.counterfilter(c)
	return c:IsSetCard(0xfba)
end
function c12010013.ccfilter(c,ft)
	return (ft~=0 and c:IsSetCard(0xfba)) or (ft==0 and c:GetSequence()<5)
end
function c12010013.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c12010013.ccfilter,1,nil,ft)
end
function c12010013.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c12010013.ccfilter,1,1,nil,ft)
	Duel.Release(g,REASON_COST)
end
function c12010013.cfilter(c,tc,tp)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc),TYPE_FUSION)>0
end
function c12010013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(12010013,tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c12010013.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tc,tp) end
	local g=Duel.SelectMatchingCard(tp,c12010013.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c,tc,tp)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c12010013.tgfilter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsLevelBelow(9) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
end
function c12010013.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010013.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12010013.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12010013.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12010013.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12010013.splimit(e,c)
	return not c:IsSetCard(0xfba)
end
