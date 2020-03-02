--华丽偶像 我们不是天使
function c14801115.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,3,c14801115.ovfilter,aux.Stringid(14801115,0),99,c14801115.xyzop)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c14801115.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e2)
    --xyz material
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801115,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,14801115)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c14801115.cost)
    e3:SetTarget(c14801115.target)
    e3:SetOperation(c14801115.operation)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801115,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,14801115)
    e4:SetCondition(c14801115.spcon)
    e4:SetTarget(c14801115.sptg)
    e4:SetOperation(c14801115.spop)
    c:RegisterEffect(e4)
end
function c14801115.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and not c:IsCode(14801115)
end
function c14801115.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,14801115)==0 end
    Duel.RegisterFlagEffect(tp,14801115,RESET_PHASE+PHASE_END,0,1)
end
function c14801115.atkval(e,c)
    return c:GetOverlayCount()*500
end
function c14801115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801115.filter(c,tp)
    return c:IsPosition(POS_FACEUP) and not c:IsType(TYPE_TOKEN)
        and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c14801115.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c14801115.filter(chkc,tp) and chkc~=e:GetHandler() end
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingTarget(c14801115.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c14801115.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
end
function c14801115.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c14801115.cfilter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c14801115.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c14801115.cfilter,1,nil,1-tp)
end
function c14801115.filter2(c,e,tp,mc)
    return c:IsSetCard(0x4801)
        and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c14801115.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
        and Duel.IsExistingMatchingCard(c14801115.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetChainLimit(c14801115.chlimit)
end
function c14801115.chlimit(e,ep,tp)
    return tp==ep
end
function c14801115.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsFaceup()
        and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c14801115.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
        local tc=g:GetFirst()
        if tc then
            local mg=c:GetOverlayGroup()
            if mg:GetCount()~=0 then
                Duel.Overlay(tc,mg)
            end
            tc:SetMaterial(Group.FromCards(c))
            Duel.Overlay(tc,Group.FromCards(c))
            Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
            tc:CompleteProcedure()
        end
    end
end