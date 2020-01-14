--星月转夜的奇之灵
function c65050218.initial_effect(c)
	--atk/lv up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050218,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c65050218.operation)
	c:RegisterEffect(e1)
	--stars!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+65050216)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050218)
	e2:SetCondition(c65050218.con)
	e2:SetTarget(c65050218.tg)
	e2:SetOperation(c65050218.op)
	c:RegisterEffect(e2)
	--RaiseEvent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEVEL_UP)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c65050218.raop)
	c:RegisterEffect(e3)
end
function c65050218.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e2:SetValue(2)
		c:RegisterEffect(e2)
	end
end
function c65050218.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c65050218.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(aux.TRUE,1,e:GetHandler())
end
function c65050218.tgfil(c,e,tp)
	return c:IsSetCard(0x5da9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c65050218.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050218.tgfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65050218.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end 
	local g=Duel.SelectMatchingCard(tp,c65050218.tgfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

