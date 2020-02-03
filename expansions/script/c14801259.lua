--黑蜜街道
local m=14801259
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e0)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)
    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_DRAW)
    e2:SetOperation(cm.recop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4802))
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function cm.filter(c)
    return c:IsSetCard(0x4802) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
    if ep~=tp then 
        Duel.Recover(tp,200,REASON_EFFECT)
    end
end