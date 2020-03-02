--华丽偶像 梦想的旗帜
function c14801118.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,3,c14801118.ovfilter,aux.Stringid(14801118,0),99,c14801118.xyzop)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c14801118.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801118,1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,14801118)
    e3:SetCost(c14801118.drcost)
    e3:SetTarget(c14801118.drtg)
    e3:SetOperation(c14801118.drop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801118,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,14801118)
    e4:SetCondition(c14801118.spcon)
    e4:SetTarget(c14801118.sptg)
    e4:SetOperation(c14801118.spop)
    c:RegisterEffect(e4)
end
function c14801118.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and not c:IsCode(c)
end
function c14801118.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,c)==0 end
    Duel.RegisterFlagEffect(tp,c,RESET_PHASE+PHASE_END,0,1)
end
function c14801118.atkval(e,c)
    return c:GetOverlayCount()*500
end
function c14801118.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801118.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c14801118.ofilter(c,tp)
    return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c14801118.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local td=Duel.Draw(tp,1,REASON_EFFECT)
    local ed=Duel.Draw(1-tp,1,REASON_EFFECT)
    local cp=c:GetControler()
    if td+ed>0 and c:IsRelateToEffect(e) then
        local sg=Group.CreateGroup()
        local tg1=Duel.GetMatchingGroup(c14801118.ofilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e),cp)
        if td>0 and tg1:GetCount()>0 then
            Duel.ShuffleHand(tp)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
            local tc1=tg1:Select(tp,1,1,nil):GetFirst()
            if tc1 and not tc1:IsImmuneToEffect(e) then
                tc1:CancelToGrave()
                sg:AddCard(tc1)
            end
        end
        local tg2=Duel.GetMatchingGroup(c14801118.ofilter,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e),cp)
        if ed>0 and tg2:GetCount()>0 then
            Duel.ShuffleHand(1-tp)
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
            local tc2=tg2:Select(1-tp,1,1,nil):GetFirst()
            if tc2 and not tc2:IsImmuneToEffect(e) then
                tc2:CancelToGrave()
                sg:AddCard(tc2)
            end
        end
        if sg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.Overlay(c,sg)
        end
    end
end
function c14801118.cfilter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c14801118.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c14801118.cfilter,1,nil,1-tp)
end
function c14801118.filter(c,e,tp,mc)
    return c:IsSetCard(0x4801)
        and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c14801118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
        and Duel.IsExistingMatchingCard(c14801118.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetChainLimit(c14801118.chlimit)
end
function c14801118.chlimit(e,ep,tp)
    return tp==ep
end
function c14801118.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsFaceup()
        and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c14801118.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
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