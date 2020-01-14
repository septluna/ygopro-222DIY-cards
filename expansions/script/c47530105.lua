--中性高达
local m=47530105
local cm=_G["c"..m]
function c47530105.initial_effect(c)
    c:EnableReviveLimit()  
    --Trial System
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c47530105.disable)
    e1:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e1) 
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(c47530105.mtcon)
    e2:SetOperation(c47530105.mtop)
    c:RegisterEffect(e2) 
    --back
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ADJUST)
    e3:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetCondition(c47530105.backon)
    e3:SetOperation(c47530105.backop)
    c:RegisterEffect(e3)
end
function c47530105.disable(e,c)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c47530105.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO and eg:IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end
function c47530105.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=eg:Filter(Card.IsRace,nil,RACE_MACHINE)
    local rc=g:GetFirst()
    if not rc then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c47530105.disable)
    e1:SetCode(EFFECT_DISABLE)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_ADD_TYPE)
        e3:SetValue(TYPE_EFFECT)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e3,true)
    end
    rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(47530105,0))
end
function c47530105.backon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c47530105.backop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode)
    Duel.ConfirmCards(tp,Group.FromCards(c))
    Duel.ConfirmCards(1-tp,Group.FromCards(c))
    c:ReplaceEffect(tcode,0,0)
end