--守护星曜·遁甲
function c66915004.initial_effect(c)
    c:SetUniqueOnField(1,0,66915004)  
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1) 
    --target
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_FIELD)
    e22:SetRange(LOCATION_MZONE)
    e22:SetTargetRange(0,LOCATION_MZONE)
    e22:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e22:SetValue(c66915004.atlimit)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c66915004.eftg)
    e5:SetLabelObject(e22)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c66915004.tglimit)
    e3:SetValue(aux.tgoval)
    local e55=Effect.CreateEffect(c)
    e55:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e55:SetRange(LOCATION_SZONE)
    e55:SetTargetRange(LOCATION_MZONE,0)
    e55:SetTarget(c66915004.eftg)
    e55:SetLabelObject(e3)
    --spsummon
    local e222=Effect.CreateEffect(c)
    e222:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e222:SetType(EFFECT_TYPE_QUICK_O)
    e222:SetRange(LOCATION_MZONE)
    e222:SetCode(EVENT_BECOME_TARGET)
    e222:SetCondition(c66915004.spcon)
    e222:SetTarget(c66915004.distg)
    e222:SetOperation(c66915004.disop)
    local e555=Effect.CreateEffect(c)
    e555:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e555:SetRange(LOCATION_SZONE)
    e555:SetTargetRange(LOCATION_MZONE,0)
    e555:SetTarget(c66915004.eftg)
    e555:SetLabelObject(e222)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c66915004.sumlimit)
    c:RegisterEffect(e2)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e11:SetTarget(c66915004.tgtg)
    e11:SetValue(1)
    c:RegisterEffect(e11)
end
function c66915004.atlimit(e,c)
    return c~=e:GetHandler()
end
function c66915004.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end
function c66915004.eftg(e,c)
    local seq=c:GetSequence()
    return  c:IsSetCard(0x1374)
    and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)==0 or
    math.abs(e:GetHandler():GetSequence()-seq)==1
end
function c66915004.cfilter(c)
    return c:IsFaceup() and c:IsCode(66915001)
end
function c66915004.tgtg(e,c)
    local seq=c:GetSequence()
    return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x1374)
        and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)==0 or
        math.abs(e:GetHandler():GetSequence()-seq)==1
end
function c66915004.tglimit(e,c)
    return c~=e:GetHandler()
end
function c66915004.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c66915004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c66915004.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
