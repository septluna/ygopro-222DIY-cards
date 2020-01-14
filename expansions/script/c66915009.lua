--来自星光的祝福
local m=66915009
local cm=_G["c"..m]
function cm.initial_effect(c)
  --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.condition)
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
function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1374) and c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilters(c)
    return   (c:IsSetCard(0x374) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))  and c:IsAbleToGraveAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_SZONE+LOCATION_HAND,0,2,nil) end
    if Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_SZONE+LOCATION_HAND,0,2,nil) then
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
       local g1=Duel.SelectMatchingCard(tp,cm.cfilters,tp,LOCATION_SZONE+LOCATION_HAND,0,2,2,nil)
       Duel.SendtoGrave(g1,REASON_COST)
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.filter(c)
    return   c:IsCode(66915001)  and c:IsSSetable()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)>0 then
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
       local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
       if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
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

