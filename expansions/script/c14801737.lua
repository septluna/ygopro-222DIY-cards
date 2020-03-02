--星际战舰 空间震荡炸弹
local m=14801737
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(cm.handcon)
    c:RegisterEffect(e2)
    --counter
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,m+1)
    e3:SetCondition(aux.exccon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(cm.cttg)
    e3:SetOperation(cm.ctop)
    c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0x480b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rfilter(c,e,tp,ft)
    return c:IsReleasableByEffect() and c:IsCanBeEffectTarget(e)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and c:IsRace(RACE_MACHINE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.rfilter(chkc,e,tp,ft) end
    if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,e,tp,ft)
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    local g=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil,e,tp,ft)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
        if Duel.Release(tc,REASON_EFFECT)==0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
        if sg:GetCount()==0 then return end
        if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==0 then return end
        local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local des=dg:Select(tp,1,1,nil)
            Duel.HintSelection(des)
            Duel.BreakEffect()
            Duel.Remove(des,POS_FACEUP,REASON_EFFECT)
        end
    end
end
function cm.filter2(c)
    return c:IsFaceup() and c:IsSetCard(0x480b) 
end
function cm.handcon(e)
    return Duel.IsExistingMatchingCard(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.ctfilters(c)
    return c:IsFaceup() and c:IsCanAddCounter(0x48f,2)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.ctfilters(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.ctfilters,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.ctfilters,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x48f)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        tc:AddCounter(0x48f,2)
    end
end