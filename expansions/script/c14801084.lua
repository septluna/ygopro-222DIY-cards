--灾厄 暴君之怒
function c14801084.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCost(c14801084.cost)
    e1:SetTarget(c14801084.target)
    e1:SetOperation(c14801084.activate)
    c:RegisterEffect(e1)
end
function c14801084.cfilter(c,tp)
    local lv=c:GetLevel()
    return lv>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
        and Duel.IsExistingTarget(c14801084.filter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c14801084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801084.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801084.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabel(g:GetFirst():GetLevel())
end
function c14801084.filter(c,lv)
    return c:IsFaceup() and not c:IsLevel(lv) and c:IsSetCard(0x4800)
end
function c14801084.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801084.filter(chkc,e:GetLabel()) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c14801084.filter,tp,LOCATION_MZONE,0,1,1,nil,e:GetLabel())
end
function c14801084.activate(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsLevel(lv) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(lv)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetValue(lv*500)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end
