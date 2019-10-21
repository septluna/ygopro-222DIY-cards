--灾厄 安魂曲
function c14801085.initial_effect(c)
    --Activate(effect)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801085,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c14801085.condition)
    e1:SetCost(c14801085.cost)
    e1:SetTarget(c14801085.target)
    e1:SetOperation(c14801085.activate)
    c:RegisterEffect(e1)
    --destroy all
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801085,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(c14801085.decon)
    e2:SetTarget(c14801085.destg)
    e2:SetOperation(c14801085.desop)
    c:RegisterEffect(e2)
end
function c14801085.condition(e,tp,eg,ep,ev,re,r,rp)
    return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c14801085.cfilter(c)
    return c:IsSetCard(0x4800) and c:IsAbleToRemoveAsCost()
end
function c14801085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801085.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801085.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801085.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c14801085.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c14801085.cfilter2(c)
    return c:IsFaceup() and c:IsCode(14801053)
end
function c14801085.decon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c14801085.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c14801085.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c14801085.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end