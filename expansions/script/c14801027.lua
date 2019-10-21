--灾厄熔岩 EX雷德王
function c14801027.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2)
    c:EnableReviveLimit()
    --destroy replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801027.reptg)
    c:RegisterEffect(e1)
    --increase atk/def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c14801027.condition)
    e2:SetValue(c14801027.adval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetCondition(c14801027.immcon)
    e4:SetValue(c14801027.efilter)
    c:RegisterEffect(e4)
end
function c14801027.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end
function c14801027.condition(e)
    local c=e:GetHandler()
    local ph=Duel.GetCurrentPhase()
    return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
        and c:IsRelateToBattle()
end
function c14801027.adval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*500
end
function c14801027.immcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c14801027.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end