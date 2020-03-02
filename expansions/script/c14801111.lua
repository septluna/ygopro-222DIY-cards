--华丽偶像 进化论
function c14801111.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,3,c14801111.ovfilter,aux.Stringid(14801111,0),99,c14801111.xyzop)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c14801111.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e2)
    --xyz material
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801111,1))
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,14801111)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c14801111.cost)
    e3:SetTarget(c14801111.target)
    e3:SetOperation(c14801111.operation)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801111,3))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,14801111)
    e4:SetCondition(c14801111.spcon)
    e4:SetTarget(c14801111.sptg)
    e4:SetOperation(c14801111.spop)
    c:RegisterEffect(e4)
end
function c14801111.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and not c:IsCode(14801111)
end
function c14801111.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,14801111)==0 end
    Duel.RegisterFlagEffect(tp,14801111,RESET_PHASE+PHASE_END,0,1)
end
function c14801111.atkval(e,c)
    return c:GetOverlayCount()*500
end
function c14801111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801111.filter1(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c14801111.filter2(c)
    return c:IsSetCard(0x4801) and c:IsType(TYPE_MONSTER)
end
function c14801111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c14801111.filter1,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(c14801111.filter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801111,2))
    Duel.SelectTarget(tp,c14801111.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectTarget(tp,c14801111.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c14801111.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local tc1=g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
    local g2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if tc1 and tc1:IsFaceup() and not tc1:IsImmuneToEffect(e) and g2:GetCount()>0 then
        Duel.Overlay(tc1,g2)
    end
end
function c14801111.cfilter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c14801111.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c14801111.cfilter,1,nil,1-tp)
end
function c14801111.filter(c,e,tp,mc)
    return c:IsSetCard(0x4801)
        and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c14801111.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
        and Duel.IsExistingMatchingCard(c14801111.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetChainLimit(c14801111.chlimit)
end
function c14801111.chlimit(e,ep,tp)
    return tp==ep
end
function c14801111.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsFaceup()
        and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c14801111.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
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