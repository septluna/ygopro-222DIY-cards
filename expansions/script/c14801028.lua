--灾厄帝龙 壬龙
function c14801028.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,3,c14801028.ovfilter,aux.Stringid(14801028,0))
    c:EnableReviveLimit()
    --xyzlimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801028,1))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c14801028.cost)
    e1:SetTarget(c14801028.target)
    e1:SetOperation(c14801028.operation)
    c:RegisterEffect(e1)
    --cannot target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.indoval)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801028,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,14801028)
    e4:SetCondition(c14801028.spcon2)
    e4:SetTarget(c14801028.sptg2)
    e4:SetOperation(c14801028.spop2)
    c:RegisterEffect(e4)
end
function c14801028.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4800) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
function c14801028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801028.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c14801028.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801028.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c14801028.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetChainLimit(c14801028.climit)
end
function c14801028.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c14801028.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end
function c14801028.climit(e,lp,tp)
    return lp==tp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c14801028.spcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp))
        and c:IsPreviousPosition(POS_FACEUP)
end
function c14801028.spfilter2(c,e,tp)
    return c:IsSetCard(0x4800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801028.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801028.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14801028.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801028.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end