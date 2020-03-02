--响战士
function c47500381.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(c47500381.sfilter),1,1)
    c:EnableReviveLimit()    
    --symphogear
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500381,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,47500381)
    e1:SetCondition(c47500381.atkcon)
    e1:SetOperation(c47500381.atkop)
    c:RegisterEffect(e1)
    --Scrap Fist
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47500381,1))
    e2:SetCategory(CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47500382)
    e2:SetCondition(c47500381.sfcon)
    e2:SetOperation(c47500381.sfop)
    c:RegisterEffect(e2)
end
function c47500381.sfilter(c)
    return c:IsType(TYPE_SYNCHRO)
end
function c47500381.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47500381.atkfilter(c)
    return c:IsFaceup()
end
function c47500381.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47500381.atkfilter,tp,LOCATION_MZONE,0,e:GetHandler())
    if g:GetCount()>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
        local atk=0
        local tc=g:GetFirst()
        while tc do
            atk=atk+tc:GetAttack()
            tc=g:GetNext()
        end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47500381,2))
    local e0=Effect.CreateEffect(e:GetHandler())
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_CANNOT_ATTACK)
    e0:SetTargetRange(LOCATION_MZONE,0)
    e0:SetTarget(c47500381.ftarget)
    e0:SetLabel(c:GetFieldID())
    e0:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e0,tp)
end
function c47500381.ftarget(e,c)
    return e:GetLabel()~=c:GetFieldID()
end
function c47500381.sfcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47500381.sfop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetCondition(c47500381.actcon)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    e2:SetCondition(c47500381.effcon)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e3:SetCondition(c47500381.damcon)
    e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
    e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetCondition(c47500381.effcon)
    e4:SetValue(1)
    e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_DAMAGE_STEP_END)
    e5:SetCondition(c47500381.descon)
    e5:SetOperation(c47500381.desop)
    e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e5)
end
function c47500381.actcon(e)
    local c=e:GetHandler()
    return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
        and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c47500381.effcon(e)
    return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c47500381.damcon(e)
    return e:GetHandler():GetBattleTarget()~=nil
end
function c47500381.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    return tc and tc:IsRelateToBattle() and e:GetOwnerPlayer()==tp
end
function c47500381.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    Duel.Hint(HINT_CARD,0,47500381)
    Duel.Destroy(tc,REASON_EFFECT)
end