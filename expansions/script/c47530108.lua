--座天使高达三型
function c47530108.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47530108.mfilter,c47530108.xyzcheck,2,2) 
    --GN Stealth Field
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530108,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c47530108.cost)
    e1:SetOperation(c47530108.stop)
    c:RegisterEffect(e1)  
    --Energy Charge
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530108,1))
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c47530108.rcon)
    e1:SetOperation(c47530108.rop)
    c:RegisterEffect(e1)  
end
function c47530108.mfilter(c,xyzc)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(4)
end
function c47530108.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c47530108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47530108.stop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTargetRange(0,LOCATION_ONFIELD)
        e1:SetValue(1)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_OATH)
        e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end
end
function c47530108.rcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsRace(RACE_MACHINE) and not re:GetHandler()~=e:GetHandler()
        and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
        and ep==e:GetOwnerPlayer() and re:GetHandler():GetOverlayCount()>=ev-1
end
function c47530108.rop(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end