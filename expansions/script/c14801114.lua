--华丽偶像 御三家
function c14801114.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,3,c14801114.ovfilter,aux.Stringid(14801114,0),99,c14801114.xyzop)
    c:EnableReviveLimit()
    --increase atk/def
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c14801114.condition)
    e1:SetLabel(4)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c14801114.efilter)
    e2:SetCondition(c14801114.effcon)
    e2:SetLabel(8)
    c:RegisterEffect(e2)
    --disable spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetCondition(c14801114.effcon2)
    e3:SetLabel(16)
    c:RegisterEffect(e3)
end
function c14801114.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and not c:IsCode(14801114)
end
function c14801114.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,14801114)==0 end
    Duel.RegisterFlagEffect(tp,14801114,RESET_PHASE+PHASE_END,0,1)
end
function c14801114.condition(e)
    local c=e:GetHandler()
    local ph=Duel.GetCurrentPhase()
    return c:GetOverlayCount()>=e:GetLabel() and (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
        and c:IsRelateToBattle()
end
function c14801114.effcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()==e:GetLabel()
end
function c14801114.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c14801114.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end