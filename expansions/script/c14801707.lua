--武装神姬 战乙女型 黑
function c14801707.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,3,c14801707.ovfilter,aux.Stringid(14801707,3))
    c:EnableReviveLimit()
    --xyzlimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801707,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801707.eqtg)
    e1:SetOperation(c14801707.eqop)
    c:RegisterEffect(e1)
    --unequip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801707,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c14801707.sptg)
    e2:SetOperation(c14801707.spop)
    c:RegisterEffect(e2)
    --destroy sub
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e3:SetValue(c14801707.repval)
    c:RegisterEffect(e3)
    --eqlimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c14801707.eqlimit)
    c:RegisterEffect(e4)
    --Atk up
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(1500)
    c:RegisterEffect(e5)
    --Def up
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    e6:SetValue(1500)
    c:RegisterEffect(e6)
    --increase atk/def
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c14801707.condition)
    e7:SetValue(c14801707.val)
        local e10=Effect.CreateEffect(c)
        e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
        e10:SetRange(LOCATION_SZONE)
        e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e10:SetTarget(c14801707.eftg)
        e10:SetLabelObject(e7)
        c:RegisterEffect(e10)
    local e9=e7:Clone()
    e9:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e9)
    --equip
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(14801707,2))
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetCategory(CATEGORY_DISABLE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)
    e8:SetCost(c14801707.cost)
    e8:SetTarget(c14801707.target)
    e8:SetOperation(c14801707.operation)
    c:RegisterEffect(e8)
end
function c14801707.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x480c) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
function c14801707.filter(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:IsType(TYPE_UNION) and ct2==0
end
function c14801707.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801707.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(14801707)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c14801707.filter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c14801707.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(14801707,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801707.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c14801707.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function c14801707.eftg(e,c)
    return e:GetHandler():GetEquipTarget()==c
end
function c14801707.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(14801707)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(14801707,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801707.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c14801707.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c14801707.eqlimit(e,c)
    return c:IsType(TYPE_MONSTER) or e:GetHandler():GetEquipTarget()==c
end
function c14801707.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801707.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c14801707.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function c14801707.condition(e)
    local c=e:GetHandler()
    local ph=Duel.GetCurrentPhase()
    return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
        and c:IsRelateToBattle()
end
function c14801707.val(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*1000
end