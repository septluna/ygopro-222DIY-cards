--武装神姬 战乙女型 白
function c14801704.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801704,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801704.eqtg)
    e1:SetOperation(c14801704.eqop)
    c:RegisterEffect(e1)
    --unequip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801704,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c14801704.sptg)
    e2:SetOperation(c14801704.spop)
    c:RegisterEffect(e2)
    --destroy sub
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e3:SetValue(c14801704.repval)
    c:RegisterEffect(e3)
    --eqlimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c14801704.eqlimit)
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
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_ATKCHANGE)
    e7:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e7:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e7:SetCondition(c14801704.atkcon)
    e7:SetOperation(c14801704.atkop)
        local e10=Effect.CreateEffect(c)
        e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
        e10:SetRange(LOCATION_SZONE)
        e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e10:SetTarget(c14801704.eftg)
        e10:SetLabelObject(e7)
        c:RegisterEffect(e10)
    --negate
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(14801704,2))
    e9:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e9:SetType(EFFECT_TYPE_QUICK_O)
    e9:SetCode(EVENT_CHAINING)
    e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1)
    e9:SetCondition(c14801704.condition)
    e9:SetTarget(c14801704.target)
    e9:SetOperation(c14801704.operation)
    c:RegisterEffect(e9)
end
function c14801704.filter(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:IsType(TYPE_UNION) and ct2==0
end
function c14801704.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801704.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(14801704)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c14801704.filter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c14801704.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(14801704,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801704.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c14801704.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function c14801704.eftg(e,c)
    return e:GetHandler():GetEquipTarget()==c
end
function c14801704.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(14801704)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(14801704,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801704.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c14801704.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c14801704.eqlimit(e,c)
    return c:IsType(TYPE_MONSTER) or e:GetHandler():GetEquipTarget()==c
end
function c14801704.spfilter(c,e,tp)
    return c:IsType(TYPE_UNION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801704.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801704.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c14801704.spop1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801704.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c14801704.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsLevelAbove(5) and bc:IsControler(1-tp)
end
function c14801704.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        e1:SetValue(bc:GetAttack())
        c:RegisterEffect(e1)
    end
end
function c14801704.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c14801704.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c14801704.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 and rc:GetBaseAttack()>=0
        and c:IsRelateToEffect(e) and c:IsFaceup() then
        local e9=Effect.CreateEffect(c)
        e9:SetType(EFFECT_TYPE_SINGLE)
        e9:SetCode(EFFECT_UPDATE_ATTACK)
        e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        e9:SetValue(rc:GetBaseAttack())
        c:RegisterEffect(e9)
    end
end