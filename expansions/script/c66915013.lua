--不协星曜·振变
local m=66915013
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)  
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)    
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ACTIVATE_COST)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(0,1)
    e2:SetCondition(cm.tgcon)
    e2:SetCost(cm.costchk)
    e2:SetOperation(cm.costop)
    c:RegisterEffect(e2)  
    --cannot remove
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_FIELD)
    e22:SetCode(EFFECT_CANNOT_REMOVE)
    e22:SetRange(LOCATION_SZONE)
    e22:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e22:SetTargetRange(1,1)
    e22:SetCondition(cm.tgcons)
    c:RegisterEffect(e22)
    --spsummon limit
    local e222=Effect.CreateEffect(c)
    e222:SetType(EFFECT_TYPE_FIELD)
    e222:SetRange(LOCATION_SZONE)
    e222:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e222:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e222:SetTargetRange(1,0)
    e222:SetTarget(cm.sumlimit)
    c:RegisterEffect(e222)
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
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.costchk(e,te_or_c,tp)
    local ct=Duel.GetFlagEffect(tp,m)
    return Duel.CheckLPCost(tp,ct*600)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.PayLPCost(tp,600)
end
function cm.cfilters(c)
    return c:IsFaceup() and c:IsCode(66915020) and c:IsType(TYPE_MONSTER)
end
function cm.tgcons(e,tp,eg,ep,ev,re,r,rp)
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