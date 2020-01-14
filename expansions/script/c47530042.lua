--扎古III改
function c47530042.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,47530042)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTarget(c47530042.sptg)
    e1:SetOperation(c47530042.spop)
    c:RegisterEffect(e1) 
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,47530043)
    e2:SetCondition(c47530042.rtcon)
    e2:SetTarget(c47530042.rttg)
    e2:SetOperation(c47530042.rtop)
    c:RegisterEffect(e2)
end
function c47530042.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=eg:GetFirst()
    return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c47530042.spfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530042.rbtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c47530042.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    local g=Duel.SelectTarget(tp,c47530042.lfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,1,1,0,0)
end
function c47530042.rbop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47530042.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and zone~=0 then
        Duel.Destroy(c,REASON_EFFECT)
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_XYZ_LEVEL)
        e1:SetValue(10)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c47530042.splimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp) 
end
function c47530042.splimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530042.cfilter(c,tp)
    return c:IsRace(RACE_MACHINE) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c47530042.rtcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530042.cfilter,1,nil,tp)
end
function c47530042.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c47530042.cfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    local g=eg:Filter(c47530042.cfilter,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47530042.rtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local g=eg:Filter(c47530042.cfilter,nil,tp)
        if g:GetCount()>0 then 
            Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c47530042.splimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp) 
end