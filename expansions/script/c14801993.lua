--阿拉德的剑圣 巴恩
function c14801993.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801993,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,14801993)
    e1:SetTarget(c14801993.target)
    e1:SetOperation(c14801993.operation)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c14801993.val)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801993,1))
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c14801993.cost)
    e3:SetTarget(c14801993.target2)
    e3:SetOperation(c14801993.operation2)
    c:RegisterEffect(e3)
end
function c14801993.filter(c,e,tp,ec)
    return c:IsSetCard(0x4809) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c14801993.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c14801993.filter(chkc,e,tp,e:GetHandler()) end
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        return Duel.IsExistingMatchingCard(c14801993.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
    end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetMatchingGroup(c14801993.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801993,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
        g1:Merge(g2)
        if ft>2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801993,2)) then
        g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        end
    end
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c14801993.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if ft<g:GetCount() then return end
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local tc=g:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,true,true)
        tc=g:GetNext()
    end
    Duel.EquipComplete()
end
function c14801993.val(e,c)
    return c:GetEquipCount()*500
end
function c14801993.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c14801993.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c14801993.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetValue(c14801993.efilter)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end
function c14801993.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end