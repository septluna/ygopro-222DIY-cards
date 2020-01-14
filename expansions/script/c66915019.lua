--闪珖女神·曦茵
local m=66915019
local cm=_G["c"..m]
function cm.initial_effect(c)
    cm.dfc_front_side=66915020 
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --search
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_DRAW)
    e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    e11:SetCondition(cm.condition)
    e11:SetTarget(cm.target)
    e11:SetOperation(cm.operation)
    c:RegisterEffect(e11)
    --atkup
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_SINGLE)
    e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e22:SetRange(LOCATION_MZONE)
    e22:SetCode(EFFECT_UPDATE_ATTACK)
    e22:SetCondition(cm.discon)
    e22:SetValue(cm.val)
    c:RegisterEffect(e22) 
    --Destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetCondition(cm.discons)
    e2:SetTarget(cm.desreptg)
    e2:SetOperation(cm.desrepop)
    c:RegisterEffect(e2)
    --cannot trigge   
    local e111=Effect.CreateEffect(c)
    e111:SetType(EFFECT_TYPE_FIELD)
    e111:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e111:SetCode(EFFECT_CANNOT_ACTIVATE)
    e111:SetRange(LOCATION_MZONE)
    e111:SetCondition(cm.disconss)
    e111:SetTargetRange(1,1)
    e111:SetValue(cm.aclimit)
    c:RegisterEffect(e111)
    --Activate
    local e1111=Effect.CreateEffect(c)
    e1111:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e1111:SetType(EFFECT_TYPE_IGNITION)
    e1111:SetRange(LOCATION_MZONE)
    e1111:SetCode(EVENT_FREE_CHAIN)
    e1111:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1111:SetCondition(cm.disconsss)
    e1111:SetTarget(cm.targets)
    e1111:SetOperation(cm.operations)
    c:RegisterEffect(e1111)
end
function cm.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0x374)  and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function cm.discon(e)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,1,nil)
end
function cm.discons(e)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,2,nil)
end
function cm.disconss(e)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,3,nil)
end
function cm.disconsss(e)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,4,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsCode(66915018)
end
function cm.filter(c)
    return (c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS) and c:IsSSetable() or c:IsCode(66915001)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and cm.filter(chkc) end
    local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
    if chk==0 then return ct>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsSSetable() then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function cm.filtercc(c)
    return c:IsSetCard(0x374) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function cm.val(e,c)
    return  Duel.GetMatchingGroupCount(cm.filtercc,c:GetControler(),LOCATION_SZONE,0,nil)*800
end
function cm.repfilter(c)
    return (c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) or c:IsCode(66915001)) and c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) 
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
        return not c:IsReason(REASON_REPLACE) and g:IsExists(cm.repfilter,1,nil)
    end
    if Duel.SelectEffectYesNo(tp,c,96) then
        local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:FilterSelect(tp,cm.repfilter,1,1,nil)
        Duel.SetTargetCard(sg)
        return true
    else return false end
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    Duel.SendtoHand(tg,nil,REASON_REPLACE)
end
function cm.aclimit(e,re,tp)
    return re:GetHandler():IsType(TYPE_TRAP+TYPE_CONTINUOUS) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.filters(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0x1374) and not c:IsCode(66915019) and not c:IsCode(66915020)
end
function cm.targets(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp
        and chkc:IsCanBeSpecialSummoned(e,0,tp,true,true) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(cm.filters,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.filters,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operations(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
        and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
        c:SetCardTarget(tc)
        Duel.SpecialSummonComplete()
    end
end