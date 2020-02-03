--108连装微型导弹荚舱衍生物
function c47530110.initial_effect(c)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(c47530110.destg)
    e3:SetOperation(c47530110.desop)
    c:RegisterEffect(e3)    
end
function c47530110.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):RandomSelect(tp,2)
    if g:GetCount()>0 then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    end
    Duel.SetTargetCard(g)
end
function c47530110.desop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
    if #sg>0 then
        Duel.Destroy(sg,REASON_EFFECT)
    end
end