--毁灭之迪美利亚
function c14801801.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,3,c14801801.ovfilter,aux.Stringid(14801801,0))
    c:EnableReviveLimit()
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801801,1))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,14801801)
    e1:SetCost(c14801801.cost)
    e1:SetCondition(c14801801.descon1)
    e1:SetTarget(c14801801.destg)
    e1:SetOperation(c14801801.desop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_BECOME_TARGET)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c14801801.descon2)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801801,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,148018011)
    e3:SetCondition(c14801801.condition)
    e3:SetTarget(c14801801.target)
    e3:SetOperation(c14801801.operation)
    c:RegisterEffect(e3)
    --get effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_XMATERIAL)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e5)
end
function c14801801.ovfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
function c14801801.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801801.tgfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c14801801.descon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c14801801.tgfilter,1,nil,tp)
end
function c14801801.descon2(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and eg:IsExists(c14801801.tgfilter,1,nil,tp)
end
function c14801801.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
         and not e:GetHandler():IsStatus(STATUS_CHAINING) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c14801801.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end
function c14801801.condition(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c14801801.filter(c,e,tp)
    return c:IsType(TYPE_XYZ) and c:IsRace(RACE_BEASTWARRIOR) and c:IsRank(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801801.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14801801.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c14801801.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c14801801.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c14801801.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.BreakEffect()
        Duel.Overlay(tc,Group.FromCards(c))
    end
end