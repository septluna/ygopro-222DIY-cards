--主天使高达
function c47530104.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47530104.mfilter,c47530104.xyzcheck,2,2)
    --GN Beam Submachine Gun
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c47530104.cost)
    e1:SetTarget(c47530104.target)
    e1:SetOperation(c47530104.operation)
    c:RegisterEffect(e1)     
end
function c47530104.mfilter(c,xyzc)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(4)
end
function c47530104.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c47530104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47530104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)   
end
function c47530104.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
        if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,RACE_MACHINE)>=2 then
        local ct=3
            while ct>0 do
                Duel.Damage(1-tp,500,REASON_EFFECT)
                ct=ct-1
            end
        end
    end
end