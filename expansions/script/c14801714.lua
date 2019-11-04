--武装神姬 战斗机型
function c14801714.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801714,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801714.eqtg)
    e1:SetOperation(c14801714.eqop)
    c:RegisterEffect(e1)
    --unequip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801714,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c14801714.sptg)
    e2:SetOperation(c14801714.spop)
    c:RegisterEffect(e2)
    --destroy sub
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e3:SetValue(c14801714.repval)
    c:RegisterEffect(e3)
    --eqlimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c14801714.eqlimit)
    c:RegisterEffect(e4)
    --Atk up
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(300)
    c:RegisterEffect(e5)
    --Def up
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    e6:SetValue(300)
    c:RegisterEffect(e6)
    --search
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(14801714,2))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCost(c14801714.cost)
    e7:SetTarget(c14801714.thtg)
    e7:SetOperation(c14801714.thop)
    local e10=Effect.CreateEffect(c)
        e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
        e10:SetRange(LOCATION_SZONE)
        e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e10:SetTarget(c14801714.eftg)
        e10:SetLabelObject(e7)
        c:RegisterEffect(e10)
    --equip
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(14801714,3))
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetCategory(CATEGORY_EQUIP)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1,14801714)
    e8:SetTarget(c14801714.eqtg1)
    e8:SetOperation(c14801714.eqop1)
    c:RegisterEffect(e8)
end
function c14801714.filter(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:IsType(TYPE_UNION) and ct2==0
end
function c14801714.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801714.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(14801714)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c14801714.filter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c14801714.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(14801714,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801714.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c14801714.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function c14801714.eftg(e,c)
    return e:GetHandler():GetEquipTarget()==c
end
function c14801714.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c14801714.thfilter(c)
    return c:IsSetCard(0x480c) and c:IsAbleToHand()
end
function c14801714.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801714.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801714.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801714.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c14801714.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(14801714)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(14801714,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801714.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c14801714.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c14801714.eqlimit(e,c)
    return c:IsType(TYPE_MONSTER) or e:GetHandler():GetEquipTarget()==c
end
function c14801714.filter1(c)
    return c:IsSetCard(0x480c) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c14801714.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c14801714.filter1,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_HAND)
end
function c14801714.eqop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c14801714.filter1),tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if not Duel.Equip(tp,tc,c,true) then return end
        local e8=Effect.CreateEffect(c)
        e8:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e8:SetType(EFFECT_TYPE_SINGLE)
        e8:SetCode(EFFECT_EQUIP_LIMIT)
        e8:SetReset(RESET_EVENT+RESETS_STANDARD)
        e8:SetValue(c14801714.eqlimit1)
        tc:RegisterEffect(e8)
    end
end
function c14801714.eqlimit1(e,c)
    return e:GetOwner()==c
end