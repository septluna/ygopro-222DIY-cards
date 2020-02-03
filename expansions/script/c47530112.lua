--水中型扎古
function c47530112.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c47530112.matfilter,1,1) 
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47530112)
    e1:SetCondition(c47530112.hspcon)
    e1:SetTarget(c47530112.hsptg)
    e1:SetOperation(c47530112.hspop)
    c:RegisterEffect(e1)
end
function c47530112.matfilter(c)
    return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsRace(RACE_MACHINE)
end
function c47530112.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47530112.hspfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c47530112.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530112.hspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c47530112.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530112.hspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
    Duel.SpecialSummonComplete()
end