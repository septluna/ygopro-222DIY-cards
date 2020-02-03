--黑蜜站台
local m=14801263
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e0)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(cm.reccon)
    e2:SetOperation(cm.recop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --immune
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4802))
    e5:SetValue(cm.efilter)
    c:RegisterEffect(e5)
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0x4802) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.cfilter(c,tp)
    return c:GetSummonPlayer()==tp
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,200,REASON_EFFECT)
end
function cm.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end