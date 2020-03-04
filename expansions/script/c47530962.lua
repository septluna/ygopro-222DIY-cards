--独角兽高达2号机 报丧女妖
local m=47530962
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+1000
function c47530962.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
    c:EnableReviveLimit()
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c47530962.efilter)
    c:RegisterEffect(e1)  
    --Armed Arm BS
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetTarget(c47530962.bstg)
    e2:SetOperation(c47530962.bsop)
    c:RegisterEffect(e2) 
    --NT-D
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530962.ntdcon)
    e3:SetTarget(c47530962.ntdtg)
    e3:SetOperation(c47530962.ntdop)
    c:RegisterEffect(e3)    
end
function c47530962.efilter(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
    else return aux.qlifilter(e,te) end
end
function c47530962.bstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,bc) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,1,1,0,0)
end
function c47530962.bsop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    local atk=tc:GetAttack()
    if tc then
        Duel.SendtoGrave(tc,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        e1:SetValue(atk)
        c:RegisterEffect(e1)
    end
end
function c47530962.ntdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<=4000
end
function c47530962.ntdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47530962.ntdop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    if c:ReplaceEffect(tcode,0,0) then
        Duel.Hint(HINT_MUSIC,0,aux.Stringid(47530962,0)) 
    end
end