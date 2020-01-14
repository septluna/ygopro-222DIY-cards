--星光指引之路
local m=66915010
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.tdcon)
    e2:SetTarget(cm.tdtg)
    e2:SetOperation(cm.tdop)
    c:RegisterEffect(e2)    
end
function cm.filter(c)
    return  (c:IsSetCard(0x1374) and c:IsType(TYPE_MONSTER)) or          (c:IsSetCard(0x374) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,5,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,5,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.filters(c)
    return   c:IsCode(66915001) or (c:IsSetCard(0x374) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==5 then
      Duel.BreakEffect()
      if  Duel.Draw(tp,1,REASON_EFFECT)>0 then
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
       local g=Duel.SelectMatchingCard(tp,cm.filters,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
       if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
       end
      end
    end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL) and re and re:GetHandler():IsCode(66915008)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,e:GetHandler())
    end
end