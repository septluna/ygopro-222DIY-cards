--星月转夜的幻之星
function c65050217.initial_effect(c)
	 --atk/lv up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050217,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c65050217.operation)
	c:RegisterEffect(e1)
	--stars!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+65050216)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,65050217)
	e2:SetCondition(c65050217.con)
	e2:SetTarget(c65050217.tg)
	e2:SetOperation(c65050217.op)
	c:RegisterEffect(e2)
	--RaiseEvent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEVEL_UP)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c65050217.raop)
	c:RegisterEffect(e3)
end
function c65050217.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c65050217.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end

function c65050217.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c65050217.tgfil(c,e,tp)
	return c:IsSetCard(0x5da9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(2)
end
function c65050217.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050217.tgfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050217.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then 
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c65050217.tgfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 then
		local g=Duel.SelectMatchingCard(tp,c65050217.tgfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
