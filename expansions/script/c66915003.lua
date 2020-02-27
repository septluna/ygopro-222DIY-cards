--破坏星曜·解离
function c66915003.initial_effect(c)
    c:SetUniqueOnField(1,0,66915003)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --atk up/indestructable
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_FIELD)
    e22:SetCode(EFFECT_UPDATE_ATTACK)
    e22:SetRange(LOCATION_SZONE)
    e22:SetTargetRange(LOCATION_MZONE,0)
    e22:SetTarget(c66915003.tgtg)
    e22:SetValue(1000)
    c:RegisterEffect(e22) 
    --actlimit
    local e222=Effect.CreateEffect(c)
    e222:SetType(EFFECT_TYPE_FIELD)
    e222:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e222:SetCode(EFFECT_CANNOT_ACTIVATE)
    e222:SetRange(LOCATION_MZONE)
    e222:SetTargetRange(0,1)
    e222:SetCondition(c66915003.con)
    e222:SetValue(c66915003.aclimit)
    e222:SetCondition(c66915003.actcon)
    local e55=Effect.CreateEffect(c)
    e55:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e55:SetRange(LOCATION_SZONE)
    e55:SetTargetRange(LOCATION_MZONE,0)
    e55:SetTarget(c66915003.eftg)
    e55:SetLabelObject(e222)
    c:RegisterEffect(e55) 
    --chain attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(c66915003.atcon)
    e3:SetOperation(c66915003.atop)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c66915003.eftg)
    e5:SetLabelObject(e3)
    c:RegisterEffect(e5)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c66915003.sumlimit)
    c:RegisterEffect(e2)
end
function c66915003.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c66915003.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c66915003.eftg(e,c)
    local seq=c:GetSequence()
    return  c:IsSetCard(0x1374)
    and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)==0 or 
    e:GetHandler():GetSequence()-seq==1
end
function c66915003.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end
function c66915003.cfilter(c)
    return c:IsFaceup() and c:IsCode(66915001)
end
function c66915003.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c66915003.atcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:GetFlagEffect(66915003)==0
        and c:IsChainAttackable()
end
function c66915003.atop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChainAttack()
end
function c66915003.tgtg(e,c)
    local seq=c:GetSequence()
    return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x1374)
    and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)==0 or
    e:GetHandler():GetSequence()-seq==1
end