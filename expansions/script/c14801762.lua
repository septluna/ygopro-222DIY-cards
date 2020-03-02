--星际战舰 狂暴级战列舰
local m=14801762
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableCounterPermit(0x48f)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(17988746,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
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
    local e7=e2:Clone()
    e7:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e7)
    --destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetTarget(cm.reptg)
    e4:SetOperation(cm.repop)
    c:RegisterEffect(e4)
    --atkup
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(cm.atkcon)
    e6:SetCost(cm.atkcost)
    e6:SetTarget(cm.atktg)
    e6:SetOperation(cm.atkop)
    c:RegisterEffect(e6)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and 1-tp==rp and Duel.GetAttacker():IsControler(1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.filter(c,e,tp,atk)
    return c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp,ev)
        if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
            and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x48f)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x48f,3)
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
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48f,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x48f,1,REASON_COST)
end
function cm.atkfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsCode(m)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_OATH)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(cm.ftarget)
    e1:SetLabel(e:GetHandler():GetFieldID())
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE,0,nil)
        local atk=g:GetSum(Card.GetAttack)
        local def=g:GetSum(Card.GetDefense)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
        e1:SetValue(atk)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(def)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
        tc:RegisterEffect(e2)
    end
end
function cm.ftarget(e,c)
    return e:GetLabel()~=c:GetFieldID()
end