--星曜妖精·希纳
local m=66915006
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)    
    --move
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(m,0))
    e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EVENT_FREE_CHAIN)
    e11:SetCountLimit(1)
    e11:SetTarget(cm.tg)
    e11:SetOperation(cm.op)
    c:RegisterEffect(e11)
    local e111=Effect.CreateEffect(c)
    e111:SetDescription(aux.Stringid(m,1))
    e111:SetCategory(CATEGORY_TODECK)
    e111:SetType(EFFECT_TYPE_IGNITION)
    e111:SetRange(LOCATION_MZONE)
    e111:SetCode(EVENT_FREE_CHAIN)
    e111:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e111:SetCountLimit(1,m)
    e111:SetTarget(cm.targets)
    e111:SetOperation(cm.operations)
    c:RegisterEffect(e111)
end
function cm.seqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x374) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and cm.seqfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_SZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_CONTROL)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
    Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0)
    local nseq=math.log(s,2)-8
    Duel.MoveSequence(tc,nseq)  
end
function cm.filter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x374) and c:IsAbleToDeck()
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode()) and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function cm.spfilter(c,e,tp,code)
    return c:IsSetCard(0x374) and not c:IsCode(code) and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function cm.targets(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and cm.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.operations(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
    if g:GetCount()>0 then
        local ss=g:GetFirst()
        Duel.MoveToField(ss,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        if tc:IsRelateToEffect(e) and tc:IsFaceup() then
            Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
        end
    end
end