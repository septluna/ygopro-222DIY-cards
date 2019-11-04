--阿拉德的剑神 索德罗斯
function c14801986.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(c14801986.sfilter),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801986,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c14801986.con)
    e1:SetTarget(c14801986.target)
    e1:SetOperation(c14801986.operation)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c14801986.val)
    c:RegisterEffect(e2)
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801986,3))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c14801986.decost)
    e3:SetTarget(c14801986.detg)
    e3:SetOperation(c14801986.deop)
    c:RegisterEffect(e3)
end
function c14801986.sfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_SYNCHRO)
end
function c14801986.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c14801986.efilter(c)
    return c:IsFaceup() and c:IsSetCard(0x480e) and c:IsRace(RACE_WARRIOR)
end
function c14801986.eqfilter(c,g)
    return c:IsType(TYPE_EQUIP) and g:IsExists(c14801986.eqcheck,1,nil,c)
end
function c14801986.eqcheck(c,ec)
    return ec:CheckEquipTarget(c)
end
function c14801986.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        local g=Duel.GetMatchingGroup(c14801986.efilter,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(c14801986.eqfilter,tp,LOCATION_GRAVE,0,1,nil,g)
    end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c14801986.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft<=0 then return end
    local g=Duel.GetMatchingGroup(c14801986.efilter,tp,LOCATION_MZONE,0,nil)
    local eq=Duel.GetMatchingGroup(c14801986.eqfilter,tp,LOCATION_GRAVE,0,nil,g)
    if ft>eq:GetCount() then ft=eq:GetCount() end
    if ft==0 then return end
    for i=1,ft do
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801986,1))
        local ec=eq:Select(tp,1,1,nil):GetFirst()
        eq:RemoveCard(ec)
        local tc=g:FilterSelect(tp,c14801986.eqcheck,1,1,nil,ec):GetFirst()
        Duel.Equip(tp,ec,tc,true,true)
    end
    Duel.EquipComplete()
end
function c14801986.val(e,c)
    return c:GetEquipCount()*1000
end
function c14801986.decost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c14801986.detg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c14801986.deop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end