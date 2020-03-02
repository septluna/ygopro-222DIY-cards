--华丽偶像 时差密码
function c14801113.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,3,c14801113.ovfilter,aux.Stringid(14801113,0),99,c14801113.xyzop)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c14801113.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e2)
    --xyz material
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801113,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,14801113)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c14801113.con)
    e3:SetTarget(c14801113.target)
    e3:SetOperation(c14801113.operation)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801113,3))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,14801113)
    e4:SetCondition(c14801113.spcon)
    e4:SetTarget(c14801113.sptg)
    e4:SetOperation(c14801113.spop)
    c:RegisterEffect(e4)
end
function c14801113.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and not c:IsCode(14801113)
end
function c14801113.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,14801113)==0 end
    Duel.RegisterFlagEffect(tp,14801113,RESET_PHASE+PHASE_END,0,1)
end
function c14801113.atkval(e,c)
    return c:GetOverlayCount()*500
end
function c14801113.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()==0
end
function c14801113.filter(c)
    return c:IsSetCard(0x4801)
end
function c14801113.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801113.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c14801113.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c14801113.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc and (tc:IsAbleToHand() and Duel.SelectOption(tp,1190,aux.Stringid(14801113,2))==0) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    else
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c14801113.cfilter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c14801113.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c14801113.cfilter,1,nil,1-tp)
end
function c14801113.filter2(c,e,tp,mc)
    return c:IsSetCard(0x4801)
        and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c14801113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
        and Duel.IsExistingMatchingCard(c14801113.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetChainLimit(c14801113.chlimit)
end
function c14801113.chlimit(e,ep,tp)
    return tp==ep
end
function c14801113.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsFaceup()
        and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c14801113.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
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