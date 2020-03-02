--华丽偶像 潘多拉的音乐盒
function c14801116.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,3,c14801116.ovfilter,aux.Stringid(14801116,0),99,c14801116.xyzop)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c14801116.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e2)
    --move
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801116,1))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,14801116)
    e3:SetCost(c14801116.mvcost)
    e3:SetTarget(c14801116.tdtg)
    e3:SetOperation(c14801116.tdop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801116,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,14801116)
    e4:SetCondition(c14801116.spcon)
    e4:SetTarget(c14801116.sptg)
    e4:SetOperation(c14801116.spop)
    c:RegisterEffect(e4)
end
function c14801116.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and not c:IsCode(14801116)
end
function c14801116.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,14801116)==0 end
    Duel.RegisterFlagEffect(tp,14801116,RESET_PHASE+PHASE_END,0,1)
end
function c14801116.atkval(e,c)
    return c:GetOverlayCount()*500
end
function c14801116.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801116.tdfilter(c)
    return c:IsSetCard(0x4801) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c14801116.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801116.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(c14801116.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c14801116.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c14801116.tdfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c14801116.cfilter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c14801116.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c14801116.cfilter,1,nil,1-tp)
end
function c14801116.filter(c,e,tp,mc)
    return c:IsSetCard(0x4801)
        and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c14801116.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
        and Duel.IsExistingMatchingCard(c14801116.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetChainLimit(c14801116.chlimit)
end
function c14801116.chlimit(e,ep,tp)
    return tp==ep
end
function c14801116.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsFaceup()
        and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c14801116.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
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