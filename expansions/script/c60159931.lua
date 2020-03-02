--裁决之光
function c60159931.initial_effect(c)
    c:SetSPSummonOnce(60159931)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c60159931.matfilter,1,1)
    --cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c60159931.e1tg)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_TRIGGER)
    c:RegisterEffect(e2)
    --cannot attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c60159931.e3tg)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_INACTIVATE)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    c:RegisterEffect(e5)
    local e6=e3:Clone()
    e6:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e6)
end
function c60159931.matfilter(c)
    return c:IsAttackPos()
end
function c60159931.e1tg(e,c)
    return not e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c60159931.e3tg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
