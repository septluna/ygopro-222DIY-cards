--杰钢（巴纳姆所属机）
function c47530040.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCountLimit(1,47530040)
    e1:SetCondition(c47530040.rtcon)
    e1:SetTarget(c47530040.rttg)
    e1:SetOperation(c47530040.rtop)
    c:RegisterEffect(e1)   
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530040,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,47530041)
    e2:SetCondition(c47530040.spcon)
    e2:SetTarget(c47530040.sptg)
    e2:SetOperation(c47530040.spop)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47530040,1))
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47530041)
    e4:SetTarget(c47530040.thtg)
    e4:SetOperation(c47530040.thop)
    c:RegisterEffect(e4)
end
function c47530040.cfilter(c)
    return c:IsRace(RACE_MACHINE)
end
function c47530040.rtcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530040.cfilter,1,e:GetHandler(),tp)
end
function c47530040.lfilter(c)
    return c:IsType(TYPE_LINK) and c:IsRace(RACE_MACHINE)
end
function c47530040.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=Duel.GetLinkedZone(tp)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c47530040.lfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and zone~=0 end
    local g=Duel.SelectTarget(tp,c47530040.lfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,1,1,0,0)
end
function c47530040.rtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
    if zone==0 or ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local tg=eg:Filter(c47530040.cfilter,nil,e,tp)
    local g=nil
    if tg:GetCount()>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=tg:Select(tp,ft,ft,nil)
    else
        g=tg
    end
    if g:GetCount()>0 then
        local tc1=g:GetFirst()
        while tc1 do
            Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP,zone)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc1:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc1:RegisterEffect(e2)
            tc1=g:GetNext()
        end
        Duel.SpecialSummonComplete()
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c47530040.splimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp) 
end
function c47530040.splimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530040.cfilter2(c,tp)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:GetSummonPlayer()==tp
end
function c47530040.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530040.cfilter2,1,nil,tp)
end
function c47530040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47530040.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47530040.tgfilter(c,tp)
    return c:IsFaceup() and Duel.IsExistingMatchingCard(c47530040.thfilter,tp,LOCATION_DECK,0,1,nil,c) and c:IsRace(RACE_MACHINE)
end
function c47530040.thfilter(c,tc)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
        and c:IsLevelAbove(tc:GetLevel()) and c:IsAttribute(tc:GetAttribute()) and not c:IsCode(tc:GetCode())
end
function c47530040.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c47530040.tgfilter(chkc,tp) end
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
        and Duel.IsExistingTarget(c47530040.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47530040.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47530040.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c47530040.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,tp,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end