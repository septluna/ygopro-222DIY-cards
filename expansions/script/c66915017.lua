--光辉降临
local m=66915017
local cm=_G["c"..m]
function cm.initial_effect(c)
     --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end
function cm.tgfilter(c)
    return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.cfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil,c)
end
function cm.cfilter(c,tc)
    return c:IsSetCard(0x1374) and not c:IsCode(tc:GetCode()) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
    if g:GetCount()>0 then
        local gc=g:GetFirst()
        if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_CODE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(gc:GetCode())
            tc:RegisterEffect(e1)
            tc:CopyEffect(gc:GetCode(),RESET_EVENT+RESETS_STANDARD)
        end
    end
end