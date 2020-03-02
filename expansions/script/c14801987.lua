--阿拉德 奥菲利亚
function c14801987.initial_effect(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801987,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801987)
    e1:SetCost(c14801987.thcost)
    e1:SetTarget(c14801987.thtg)
    e1:SetOperation(c14801987.thop)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetDescription(aux.Stringid(14801987,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(TIMING_DAMAGE_STEP)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCountLimit(1,14801987)
    e2:SetCondition(c14801987.condition2)
    e2:SetCost(aux.bfgcost)
    e2:SetOperation(c14801987.operation2)
    c:RegisterEffect(e2)
end
function c14801987.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c14801987.thfilter(c)
    return (c:IsSetCard(0x480e) and c:IsRace(RACE_WARRIOR)) or (c:IsSetCard(0x4809) and c:IsType(TYPE_EQUIP)) and c:IsAbleToHand()
end
function c14801987.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14801987.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801987.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c14801987.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c14801987.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function c14801987.condition2(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsSetCard(0x480e) and a:IsRelateToBattle())
        or (d:GetControler()==tp and d:IsSetCard(0x480e) and d:IsRelateToBattle()))
end
function c14801987.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetOwnerPlayer(tp)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    if a:GetControler()==tp then
        e1:SetValue(d:GetAttack())
        a:RegisterEffect(e1)
    else
        e1:SetValue(a:GetAttack())
        d:RegisterEffect(e1)
    end
end