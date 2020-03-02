--阿拉德 赛丽亚
function c14801977.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c14801977.lcheck,2,99,c14801977.lcheck1)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --reflect battle dam
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --return
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801977,0))
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,14801977)
    e4:SetTarget(c14801977.rettg)
    e4:SetOperation(c14801977.retop)
    c:RegisterEffect(e4)
end
function c14801977.lcheck(c)
    return c:IsLinkType(TYPE_EFFECT) or c:IsLinkType(TYPE_TOKEN)
end
function c14801977.lcheck1(g,lc)
    return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end
function c14801977.retfilter1(c)
    return c:IsSetCard(0x480e) and c:IsAbleToDeck()
end
function c14801977.retfilter2(c)
    return c:IsAbleToHand()
end
function c14801977.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c14801977.retfilter1,tp,LOCATION_GRAVE,0,2,nil)
        and Duel.IsExistingTarget(c14801977.retfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectTarget(tp,c14801977.retfilter1,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g2=Duel.SelectTarget(tp,c14801977.retfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c14801977.retop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)~=0 then
        local og=Duel.GetOperatedGroup()
        if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
        local g2=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
        Duel.SendtoHand(g2,nil,REASON_EFFECT)
    end
end