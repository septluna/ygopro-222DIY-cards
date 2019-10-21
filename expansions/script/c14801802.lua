--雷欧帕多
function c14801802.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2)
    c:EnableReviveLimit()
    --atk u/d
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801802,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c14801802.atkcost)
    e1:SetTarget(c14801802.atktg)
    e1:SetOperation(c14801802.atkop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801802,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,14801802)
    e2:SetCondition(c14801802.spcon)
    e2:SetTarget(c14801802.sptg)
    e2:SetOperation(c14801802.spop)
    c:RegisterEffect(e2)  
    --effect gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(c14801802.efcon)
    e3:SetOperation(c14801802.efop)
    c:RegisterEffect(e3)
end
function c14801802.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801802.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local at=Duel.GetAttackTarget()
    if chk==0 then return ((at and at:IsFaceup() and Duel.GetAttacker()==e:GetHandler()) or at==e:GetHandler())
        and not e:GetHandler():IsStatus(STATUS_CHAINING) end
    Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
end
function c14801802.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()/2
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetValue(atk)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e2)
    end
end
function c14801802.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c14801802.spfilter(c,e,tp)
    return c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_XYZ) and c:IsRank(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801802.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c14801802.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14801802.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801802.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
        Duel.Overlay(g:GetFirst(),Group.FromCards(c))
    end
end
function c14801802.efcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return r==REASON_XYZ and c:GetReasonCard():IsRace(RACE_BEASTWARRIOR)
end
function c14801802.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local p=rc:GetControler()
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(14801802,2))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c14801802.xyzcon)
    e1:SetTarget(c14801802.mvtg)
    e1:SetOperation(c14801802.mvop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
end
function c14801802.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c14801802.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c14801802.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(c,nseq)
end