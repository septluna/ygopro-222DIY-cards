--白玉 桃山铃音
local m=14801253
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,2)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(cm.cost2)
    e1:SetTarget(cm.sptg2)
    e1:SetOperation(cm.spop2)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetHintTiming(TIMING_DAMAGE_STEP)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.cona)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,3))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cm.cond)
    e3:SetCost(cm.negcost)
    e3:SetTarget(cm.negtg)
    e3:SetOperation(cm.negop)
    c:RegisterEffect(e3)
    --to defense
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,4))
    e4:SetCategory(CATEGORY_POSITION)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(cm.potg)
    e4:SetOperation(cm.poop)
    c:RegisterEffect(e4)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter(c,e,tp)
    return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.cona(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsAttackPos() and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function cm.filter2(c)
    return c:IsFaceup() and c:IsSetCard(0x4802) or c:IsSetCard(0x480a)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter2(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local val=Duel.GetMatchingGroupCount(cm.filter2,tp,LOCATION_ONFIELD,0,nil)*500
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(val)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
    end
end
function cm.cond(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return e:GetHandler():IsDefensePos() and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,2000) end
    Duel.PayLPCost(tp,2000)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function cm.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAttackPos() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function cm.poop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end