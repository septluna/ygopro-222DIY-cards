--星曜女神·乐音
local m=66915007
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(cm.spcon)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
   --tograve
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.tgtg)
    e3:SetOperation(cm.tgop)
    c:RegisterEffect(e3)
end
function cm.spfilter(c)
    return  c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x374) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c)
    return ((c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS or c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS)and c:IsSetCard(0x374)) and c:IsSSetable() or c:IsCode(66915001)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and cm.filter(chkc) end
    local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
    if chk==0 then return ct>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsSSetable() then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end