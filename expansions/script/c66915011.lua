--虚无星曜·避役
local m=66915011
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)  
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)  
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCondition(cm.cons)
    e3:SetTargetRange(1,1)
    c:RegisterEffect(e3)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_SUMMON)
    e5:SetCondition(cm.con)
    c:RegisterEffect(e5)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.sumlimit)
    c:RegisterEffect(e2)
    --
    local e33=Effect.CreateEffect(c)
    e33:SetType(EFFECT_TYPE_SINGLE)
    e33:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e33:SetCode(EFFECT_SELF_DESTROY)
    e33:SetRange(LOCATION_SZONE)
    e33:SetCondition(cm.descon)
    c:RegisterEffect(e33)
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsCode(66915001)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.cfilters(c)
    return c:IsFaceup() and c:IsCode(66915020) and c:IsType(TYPE_MONSTER)
end
function cm.cons(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end
function cm.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1374)
end
function cm.descon(e)
    return not Duel.IsExistingMatchingCard(cm.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end