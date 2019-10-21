--灾厄魔人 萨迪斯
function c14801049.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801049,3))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,14801049)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c14801049.spcon)
    e1:SetTarget(c14801049.sptg)
    e1:SetOperation(c14801049.spop)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801049,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,148010491)
    e2:SetTarget(c14801049.destg)
    e2:SetOperation(c14801049.desop)
    c:RegisterEffect(e2)
    --equip
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801049,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e3:SetCountLimit(1,148010492)
    e3:SetTarget(c14801049.eqtg)
    e3:SetOperation(c14801049.eqop)
    c:RegisterEffect(e3)
    --cannot activate
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801049,2))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c14801049.destg2)
    e4:SetOperation(c14801049.desop2)
    c:RegisterEffect(e4)
    --Atk up
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(1000)
    c:RegisterEffect(e5)
    --Def up
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    e6:SetValue(1000)
    c:RegisterEffect(e6)
end
function c14801049.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipTarget()
end
function c14801049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14801049.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c14801049.desfilters(c)
    return c:IsSetCard(0x4800)
end
function c14801049.spfilter(c,e,tp)
    return c:IsSetCard(0x4800) and c:IsLevel(7,8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801049.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c14801049.desfilters(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801049.desfilters,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801049.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c14801049.desfilters,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14801049.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c14801049.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
            Duel.SpecialSummonComplete()
        end
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetValue(c14801049.val)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end
function c14801049.val(e,re,dam,r,rp,rc)
    if bit.band(r,REASON_BATTLE)~=0 then
        return math.ceil(dam/2)
    else return dam end
end
function c14801049.filter2(c)
    return c:IsFaceup() and c:IsCode(14801047)
end
function c14801049.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801049.filter2(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c14801049.filter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c14801049.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c14801049.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    e3:SetValue(c14801049.eqlimit)
    e3:SetLabelObject(tc)
    c:RegisterEffect(e3)
end
function c14801049.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c14801049.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14801049.desop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end