--阿拉德 莎兰
function c14801979.initial_effect(c)
     --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c14801979.lcheck,2,99)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801979,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,14801979)
    e1:SetTarget(c14801979.target)
    e1:SetOperation(c14801979.operation)
    c:RegisterEffect(e1)
    --immune spell
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c14801979.efilter)
    c:RegisterEffect(e2)
    --disable all
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801979,1))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c14801979.con)
    e3:SetTarget(c14801979.target)
    e3:SetOperation(c14801979.operation)
    c:RegisterEffect(e3)
end
function c14801979.lcheck(c)
    return c:IsLinkSetCard(0x480e) or (c:IsType(TYPE_TOKEN) and c:IsRace(RACE_SPELLCASTER))
end
function c14801979.filter(c,e,tp,ec)
    return c:IsSetCard(0x4809) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c14801979.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c14801979.filter(chkc,e,tp,e:GetHandler()) end
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        return Duel.IsExistingMatchingCard(c14801979.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
    end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetMatchingGroup(c14801979.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801979,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
        g1:Merge(g2)
        if ft>2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801979,2)) then
        g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        end
    end
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c14801979.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c14801979.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c14801979.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x4809)
end
function c14801979.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsLevelAbove(3) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14801979,2))
end
function c14801979.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end