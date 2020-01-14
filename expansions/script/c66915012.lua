--唤生星曜·生息
local m=66915012
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m) 
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.sumlimit)
    c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0x1374)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp
        and chkc:IsCanBeSpecialSummoned(e,0,tp,true,true) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.filters(c)
    return c:IsCode(66915010) or c:IsCode(66915009) and c:IsAbleToHand()
end
function cm.cfilter(c)
    return c:IsCode(66915019)  and c:IsFaceup()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
        and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
        c:SetCardTarget(tc)
        Duel.SpecialSummonComplete()
        if  Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
          Duel.BreakEffect()
          Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
          local g=Duel.SelectMatchingCard(tp,cm.filters,tp,LOCATION_DECK,0,1,1,nil)
          if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
          end
        end       
    end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end