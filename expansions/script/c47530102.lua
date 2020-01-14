--力天使高达
function c47530102.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
    c:EnableReviveLimit()    
    --direct attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e1)
    --lock on
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c47530102.locost)
    e2:SetTarget(c47530102.lotg)
    e2:SetOperation(c47530102.loop)
    c:RegisterEffect(e2)
    --GN Sniper Rifle
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetTarget(c47530102.sptg)
    e3:SetOperation(c47530102.spop)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetCondition(c47530102.spcon)
    e4:SetOperation(c47530102.spop1)
    c:RegisterEffect(e4)    
end
function c47530102.locost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c47530102.lotg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c47530102.loop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        e1:SetLabelObject(c)
        c:RegisterEffect(e1)
    end
end
function c47530102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,bc) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,1,1,0,0)
end
function c47530102.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
    end
end
function c47530102.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47530102.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end