--座天使高达二型
function c47530107.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47530107.mfilter,c47530107.xyzcheck,2,2)    
    --fang
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetOperation(c47530107.atkop)
    c:RegisterEffect(e1)    
end
function c47530107.mfilter(c,xyzc)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(4)
end
function c47530107.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c47530107.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=6
    if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(47530107,0)) then
        e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        while ct>0 do
            Duel.Damage(1-tp,300,REASON_EFFECT)
            ct=ct-1
        end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetValue(1500)
        c:RegisterEffect(e1)
    else
        while ct>0 do
            Duel.Damage(1-tp,150,REASON_EFFECT)
            ct=ct-1
        end
    end
end