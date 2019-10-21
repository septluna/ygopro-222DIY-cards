--灾厄 暴君威压
function c14801083.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c14801083.condition)
    e1:SetTarget(c14801083.target)
    e1:SetOperation(c14801083.activate)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(c14801083.handcon)
    c:RegisterEffect(e2)
end
function c14801083.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end
function c14801083.filter(c)
    return c:IsPosition(POS_FACEUP_ATTACK)
end
function c14801083.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801083.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c14801083.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c14801083.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()==0 then return end
    local atk=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*1000
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c14801083.handcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_SZONE,0)==0
end