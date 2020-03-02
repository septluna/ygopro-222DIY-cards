--艾尔美斯
function c47530131.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
    c:EnableReviveLimit()
    --BIT
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530131,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,47530131)
    e1:SetTarget(c47530131.eqtg)
    e1:SetOperation(c47530131.eqop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c47530131.efop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530131,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCondition(c47530131.condition)
    e3:SetTarget(c47530131.target)
    e3:SetOperation(c47530131.operation)
    c:RegisterEffect(e3)
end
function c47530131.eqfilter(c)
    return c:IsFaceup()
end
function c47530131.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47530131.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c47530131.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c47530131.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Equip(tp,tc,c,false)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c47530131.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function c47530131.eqlimit(e,c)
    return e:GetOwner()==c
end
function c47530131.rtgfilter(c)
    return c:GetOriginalType(TYPE_MONSTER) and c:GetOriginalType(TYPE_EFFECT) and c:GetOriginalRace(RACE_MACHINE)
end
function c47530131.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local eq=c:GetEquipGroup(c47530131.rtgfilter,1,nil,tp)
    local wg=eq:Filter(c47530131.rtgfilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
        wbc=wg:GetNext()
    end  
end
function c47530131.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
        and (c:IsReason(REASON_EFFECT) and rp==1-tp or c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))
        and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c47530131.filter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530131.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c47530131.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47530131.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47530131.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47530131.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local rc=re:GetHandler()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47530131.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(1000)
        tc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e4)
    end
    Duel.SpecialSummonComplete()
end
function c47530131.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end