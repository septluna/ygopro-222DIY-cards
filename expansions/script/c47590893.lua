--罐子
function c47590893.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1,1)
    c:EnableReviveLimit()  
    --open
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCountLimit(1,47590893)
    e1:SetOperation(c47590893.operation)
    c:RegisterEffect(e1)
end
function c47590893.operation(e,tp,eg,ep,ev,re,r,rp)
    local d1,d2=Duel.TossDice(tp,2)
    if d1==1 or d2==1 then
        Duel.Draw(1-tp,2,REASON_EFFECT)
    end
    if d1==2 or d2==2 then
        Duel.Draw(tp,2,REASON_EFFECT) 
    end
    if d1==3 or d2==3 then
        local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
    if d1==4 or d2==4 then
        local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
    if d1==5 or d2==5 then
        Duel.SetLP(1-tp,Duel.GetLP(1-tp)-4000)
    end
    if d1==6 or d2==6 then
        Duel.SetLP(tp,Duel.GetLP(tp)-4000)
    end
end