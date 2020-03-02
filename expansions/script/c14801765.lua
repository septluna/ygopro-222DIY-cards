--星际战舰 纳迦法级无畏战舰
local m=14801765
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
    e1:SetCondition(cm.sprcon)
    e1:SetOperation(cm.sprop)
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
    --destroy
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,1))
    e6:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e6:SetCondition(cm.descon)
    e6:SetCost(cm.spcost1)
    e6:SetTarget(cm.destg)
    e6:SetOperation(cm.desop)
    c:RegisterEffect(e6)
end
function cm.sprfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function cm.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x48f)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x48f,4)
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
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48f,2,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x48f,2,REASON_COST)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.posfilter(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
        local g=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
        end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end