--黑蜜云梯
local m=14801260
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
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(cm.drcon1)
    e2:SetOperation(cm.drop1)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_TO_HAND)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(cm.regcon)
    e3:SetOperation(cm.regop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_CHAIN_SOLVED)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(cm.drcon2)
    e4:SetOperation(cm.drop2)
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
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.cfilter(c,tp)
    return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp) 
        and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,200,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,m)==0 
        and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)>0
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.ResetFlagEffect(tp,m)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,200,REASON_EFFECT)
end
function cm.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end