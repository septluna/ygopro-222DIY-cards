--光辉星曜·圣芒
function c66915005.initial_effect(c)
    c:SetUniqueOnField(1,0,66915005)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)   
    --immune
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_SINGLE)
    e22:SetCode(EFFECT_IMMUNE_EFFECT)
    e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e22:SetRange(LOCATION_MZONE)
    e22:SetValue(c66915005.efilter)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c66915005.eftg)
    e5:SetLabelObject(e22)
    --Activate
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DESTROY)
    e11:SetType(EFFECT_TYPE_QUICK_O)
    e11:SetCode(EVENT_CHAINING)
    e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCondition(c66915005.condition)
    e11:SetTarget(c66915005.target)
    e11:SetOperation(c66915005.activate)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c66915005.eftg)
    e5:SetLabelObject(e11)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c66915005.sumlimit)
    c:RegisterEffect(e2)   
end
function c66915005.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end
function c66915005.eftg(e,c)
    local seq=c:GetSequence()
    return  c:IsSetCard(0x1374)
    and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)==0
end
function c66915005.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x1374)
end
function c66915005.efilter(e,re,tp)
    return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c66915005.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x374) and c:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c66915005.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c57831349.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c66915005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
    end
end
function c66915005.desfilter(c)
    return c:IsFaceup() and c:IsCode(66915001)
end
function c66915005.activate(e,tp,eg,ep,ev,re,r,rp)
    local ec=re:GetHandler()
    if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
        ec:CancelToGrave()
        if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
            local g=Duel.GetMatchingGroup(c66915005.desfilter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
            if g:GetCount()>0 then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local sg=g:Select(tp,1,1,nil)
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
            end
        end
    end
end