--阿拉德的剑圣 阿甘左
function c14801992.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801992,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,14801992)
    e1:SetTarget(c14801992.target)
    e1:SetOperation(c14801992.operation)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c14801992.val)
    c:RegisterEffect(e2)
    --destroy & damage
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e3:SetDescription(aux.Stringid(14801992,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c14801992.cost)
    e3:SetTarget(c14801992.target2)
    e3:SetOperation(c14801992.operation2)
    c:RegisterEffect(e3)
end
function c14801992.filter(c,e,tp,ec)
    return c:IsSetCard(0x4809) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c14801992.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c14801992.filter(chkc,e,tp,e:GetHandler()) end
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        return Duel.IsExistingMatchingCard(c14801992.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
    end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetMatchingGroup(c14801992.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801992,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
        g1:Merge(g2)
        if ft>2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801992,2)) then
        g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        end
    end
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c14801992.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c14801992.val(e,c)
    return c:GetEquipCount()*500
end
function c14801992.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c14801992.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    if g:GetFirst():IsType(TYPE_MONSTER) then
        local atk=g:GetFirst():GetTextAttack()
        if atk<0 then atk=0 end
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
    end
end
function c14801992.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
        local atk=tc:GetTextAttack()
        if atk<0 then atk=0 end
        if Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) then
            Duel.BreakEffect()
            Duel.Damage(1-tp,atk,REASON_EFFECT)
        end
    end
end