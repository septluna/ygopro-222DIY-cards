--灾厄之王 极恶贝利亚
function c14801035.initial_effect(c)
    c:EnableReviveLimit()
    --connot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c14801035.spcon)
    e2:SetOperation(c14801035.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetRange(LOCATION_GRAVE)
    c:RegisterEffect(e3)
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c14801035.efilter)
    c:RegisterEffect(e4)
    --attackall
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_ATTACK_ALL)
    e5:SetValue(1)
    c:RegisterEffect(e5)
end
function c14801035.spfilter1(c,ft,tp)
    return (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup()) and (c:IsSetCard(0x4800) and c:IsType(TYPE_FUSION))
end
function c14801035.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,c14801035.spfilter1,1,nil,ft,tp)
end
function c14801035.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,c14801035.spfilter1,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
    local atk=g:GetFirst():GetBaseAttack()
    local dam=g:GetFirst():GetBaseDefense()
    if atk<0 then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)
    if dam<0 then return end
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(dam)
    e2:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e2)
end
function c14801035.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end