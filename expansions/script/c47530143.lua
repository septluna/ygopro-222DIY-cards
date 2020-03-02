--联邦战线
function c47530143.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47530143+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)   
    --E.F.S.F
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530143,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c47530143.thtg)
    e2:SetOperation(c47530143.thop)
    c:RegisterEffect(e2) 
end
c47530143.is_named_with_EFSF=1
function c47530143.IsEFSF(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_EFSF
end
function c47530143.thfilter(c)
    return c:IsSetCard(0x5d6) and c:IsAbleToHand()
end
function c47530143.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530143.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47530143.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47530143.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end