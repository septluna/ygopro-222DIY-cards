--星月转夜的星光
function c65050232.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050232+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c65050232.activate)
	c:RegisterEffect(e1)
	--RaiseEvent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEVEL_UP)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c65050232.raop)
	c:RegisterEffect(e3)
end
function c65050232.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c65050232.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(65050232,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c65050232.cost)
	e1:SetTarget(c65050232.tg)
	e1:SetOperation(c65050232.op)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65050232.eftg)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function c65050232.costfil(c,e,tp,mc)
	local g=Group.FromCards(c,mc)
	local lv=c:GetRank()+mc:GetLevel()
	return c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsSetCard(0x5da9) and Duel.IsExistingMatchingCard(c65050232.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,g) 
end
function c65050232.spfil(c,e,tp,lv,mg)
	return c:IsSetCard(0x5da9) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsLevel(lv) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c65050232.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050232.costfil,tp,LOCATION_MZONE,0,1,nil,e,tp,e:GetHandler()) and e:GetHandler():IsAbleToGraveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c65050232.costfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp,e:GetHandler())
	local lv=g:GetFirst():GetRank()+e:GetHandler():GetLevel()
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(lv)
end
function c65050232.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65050232.op(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c65050232.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end

function c65050232.eftg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x5da9) and c:IsType(TYPE_TUNER) 
end