--独角兽高达
local m=47530113
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+1
function c47530113.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
    c:EnableReviveLimit() 
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --BEAM MAGNUM
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN+CATEGORY_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47530113)
    e3:SetCondition(c47530113.bmcon)
    e3:SetTarget(c47530113.bmtg)
    e3:SetOperation(c47530113.bmop)
    c:RegisterEffect(e3) 
    --NT-D
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1)
    e4:SetCondition(c47530113.ntdcon)
    e4:SetTarget(c47530113.ntdtg)
    e4:SetOperation(c47530113.ntdop)
    c:RegisterEffect(e4)
    --spsummon bgm
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetOperation(c47530113.sumsuc)
    c:RegisterEffect(e5) 
end
function c47530113.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47530113,0))
end 
function c47530113.bmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
end
function c47530113.bmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,5)
    Duel.SetChainLimit(c47530113.chlimit)
end
function c47530113.chlimit(e,ep,tp)
    return tp==ep
end
function c47530113.desfilter(c,g)
    return g:IsContains(c)
end
function c47530113.bmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local cg=tc:GetColumnGroup()
    local c1,c2,c3,c4,c5=Duel.TossCoin(tp,5)
    local ct=c1+c2+c3+c4+c5
    if ct==0 then return end
    if ct>0 and c:IsRelateToEffect(e) then
        local g=Duel.GetMatchingGroup(c47530113.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
        Duel.Destroy(g,REASON_EFFECT)
        Duel.Damage(1-tp,ct*750,REASON_EFFECT)
    end
end
function c47530113.spfilter(c,sp)
    return c:GetSummonPlayer()==sp and c:IsType(TYPE_LINK)
end
function c47530113.ntdcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530113.spfilter,1,nil,1-tp)
end
function c47530113.ntdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47530113.ntdop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    if c:ReplaceEffect(tcode,0,0) then
        Duel.Hint(HINT_MUSIC,0,aux.Stringid(47530113,2)) 
    end
end