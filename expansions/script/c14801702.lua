--武装神姬 恶魔型
function c14801702.initial_effect(c)
    --fusion summon
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_UNION),4,true)
    --spsummon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(c14801702.splimit)
    c:RegisterEffect(e0)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801702,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801702.eqtg)
    e1:SetOperation(c14801702.eqop)
    c:RegisterEffect(e1)
    --unequip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801702,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c14801702.sptg)
    e2:SetOperation(c14801702.spop)
    c:RegisterEffect(e2)
    --destroy sub
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e3:SetValue(c14801702.repval)
    c:RegisterEffect(e3)
    --eqlimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c14801702.eqlimit)
    c:RegisterEffect(e4)
    --Atk up
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(2000)
    c:RegisterEffect(e5)
    --Def up
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    e6:SetValue(2000)
    c:RegisterEffect(e6)
    --negate
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(14801702,2))
    e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_CHAINING)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e7:SetCountLimit(1)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c14801702.negcon)
    e7:SetTarget(c14801702.negtg)
    e7:SetOperation(c14801702.negop)
    local e10=Effect.CreateEffect(c)
        e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
        e10:SetRange(LOCATION_SZONE)
        e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e10:SetTarget(c14801702.eftg)
        e10:SetLabelObject(e7)
        c:RegisterEffect(e10)
    --equip
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(14801702,3))
    e9:SetCategory(CATEGORY_EQUIP)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetCondition(c14801702.eqcon)
    e9:SetCountLimit(1,14801702)
    e9:SetTarget(c14801702.target2)
    e9:SetOperation(c14801702.operation2)
    c:RegisterEffect(e9)
end
function c14801702.splimit(e,se,sp,st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c14801702.filter(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:IsType(TYPE_UNION) and ct2==0
end
function c14801702.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801702.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(14801702)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c14801702.filter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c14801702.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(14801702,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801702.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c14801702.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function c14801702.eftg(e,c)
    return e:GetHandler():GetEquipTarget()==c
end
function c14801702.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(14801702)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(14801702,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801702.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c14801702.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c14801702.eqlimit(e,c)
    return c:IsType(TYPE_MONSTER) or e:GetHandler():GetEquipTarget()==c
end
function c14801702.negcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c14801702.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c14801702.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c14801702.efilter(c)
    return c:IsFaceup()
end
function c14801702.eqfilter(c,g)
    return c:IsType(TYPE_UNION) and g:IsExists(c14801702.eqcheck,1,nil,c)
end
function c14801702.eqcheck(c,ec)
    return ec:CheckEquipTarget(c)
end
function c14801702.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c14801702.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        local g=Duel.GetMatchingGroup(c14801702.efilter,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(c14801702.eqfilter,tp,LOCATION_GRAVE,0,1,nil,g)
    end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c14801702.operation2(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft<=0 then return end
    local g=Duel.GetMatchingGroup(c14801702.efilter,tp,LOCATION_MZONE,0,nil)
    local eq=Duel.GetMatchingGroup(c14801702.eqfilter,tp,LOCATION_GRAVE,0,nil,g)
    if ft>eq:GetCount() then ft=eq:GetCount() end
    if ft==0 then return end
    for i=1,ft do
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801702,4))
        local ec=eq:Select(tp,1,1,nil):GetFirst()
        eq:RemoveCard(ec)
        local tc=g:FilterSelect(tp,c14801702.eqcheck,1,1,nil,ec):GetFirst()
        if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
            aux.SetUnionState(ec)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_SZONE)
            e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            ec:RegisterEffect(e1)
        end
    end
    Duel.EquipComplete()
end