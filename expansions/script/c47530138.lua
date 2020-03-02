--吉姆狙击型2
function c47530138.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,47530138)
    e1:SetCondition(c47530138.spcon)
    e1:SetOperation(c47530138.spop)
    c:RegisterEffect(e1) 
    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,47530139)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c47530138.tgtg)
    e2:SetOperation(c47530138.tgop)
    c:RegisterEffect(e2) 
end
function c47530138.spfilter(c)
    return c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function c47530138.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530138.spfilter,tp,LOCATION_GRAVE,0,1,c)
end
function c47530138.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47530138.spfilter,tp,LOCATION_GRAVE,0,1,1,c)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47530138.tgfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47530138.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c47530138.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47530138.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47530138.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c47530138.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCountLimit(1)
        e2:SetOperation(c47530138.desop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
end
function c47530138.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end