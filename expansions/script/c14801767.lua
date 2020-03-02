--星际战舰 拉格纳洛克级泰坦
local m=14801767
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableCounterPermit(0x48f)
    c:EnableReviveLimit()
    --special summon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
    --spsummon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.spcon)
    c:RegisterEffect(e1)
    --counter
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(cm.cttg)
    e2:SetOperation(cm.ctop)
    c:RegisterEffect(e2)
    --destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetTarget(cm.reptg)
    e4:SetOperation(cm.repop)
    c:RegisterEffect(e4)
    --Negate
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,1))
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(cm.negcost)
    e6:SetTarget(cm.immtg)
    e6:SetOperation(cm.immop)
    c:RegisterEffect(e6)
end
function cm.spfilter(c)
    return c:IsSetCard(0x480b) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,c)
    if c==nil then return true end
    if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
    local g=Duel.GetMatchingGroup(cm.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    return ct>5
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,5,0,0x48f)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x48f,5)
    end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x48f,1,REASON_EFFECT) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveCounter(tp,0x48f,1,REASON_EFFECT)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48f,2,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x48f,2,REASON_COST)
end
function cm.immfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function cm.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.immfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.immfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(cm.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function cm.efilter(e,te,c)
    return te:GetOwner()~=c
end