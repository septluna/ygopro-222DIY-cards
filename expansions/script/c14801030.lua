--灾厄魑魅 基里艾洛德
function c14801030.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c14801030.indcon)
    e1:SetValue(c14801030.efilter)
    c:RegisterEffect(e1)
    --level change
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801030,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE) 
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c14801030.regcon)
    e2:SetCost(c14801030.cost)
    e2:SetOperation(c14801030.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801030,2))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e3:SetCondition(c14801030.regcon)
    e3:SetCost(c14801030.cost)
    e3:SetOperation(c14801030.atkop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801030,3))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_BE_BATTLE_TARGET)
    e5:SetRange(LOCATION_MZONE) 
    e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e5:SetCondition(c14801030.regcon)
    e5:SetCost(c14801030.cost)
    e5:SetOperation(c14801030.regop2)
    c:RegisterEffect(e5)
    --destroy replace
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(c14801030.reptg)
    c:RegisterEffect(e5)
end
function c14801030.indcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x4800)
end
function c14801030.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c14801030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801030.regcon(e,tp,eg,ep,ev,re,r,rp)
    return (e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget()
end
function c14801030.regop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        d:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        d:RegisterEffect(e2)
    end
end
function c14801030.regop2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    if a then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        a:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        a:RegisterEffect(e2)
    end
end

function c14801030.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_UPDATE_ATTACK)
        e4:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        e4:SetValue(700)
        c:RegisterEffect(e4)
    end
end
function c14801030.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end