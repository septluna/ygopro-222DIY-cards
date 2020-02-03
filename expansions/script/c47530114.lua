--独角兽高达（NT-D）
local m=47530114
local cm=_G["c"..m]
function c47530114.initial_effect(c)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c47530114.imfilter)
    c:RegisterEffect(e1) 
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c47530114.discon)
    e2:SetTarget(c47530114.distg)
    e2:SetOperation(c47530114.disop)
    c:RegisterEffect(e2) 
    --back
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ADJUST)
    e3:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetCondition(c47530114.backcon)
    e3:SetOperation(c47530114.backop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c47530114.ntdcon)
    c:RegisterEffect(e4)
end
function c47530114.imfilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c47530114.discon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c47530114.lkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c47530114.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
    local tg=Group.CreateGroup()
    local lg=Duel.GetMatchingGroup(c47530114.lkfilter,tp,0,LOCATION_MZONE,nil)
    for tc in aux.Next(lg) do
        tg:Merge(tc:GetLinkedGroup())
    end
    if chk==0 then return tg:IsExists(Card.IsAbleToChangeControler,1,nil,e) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47530114.disop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Group.CreateGroup()
    local lg=Duel.GetMatchingGroup(c47530114.lkfilter,tp,0,LOCATION_MZONE,nil)
    for tc in aux.Next(lg) do
        tg:Merge(tc:GetLinkedGroup())
    end
    local g=tg:FilterSelect(tp,Card.IsAbleToChangeControler,1,1,nil,e)
    local sg=g:GetFirst()
    if sg and Duel.GetControl(sg,tp,PHASE_END,2) then
        Duel.NegateEffect(ev)
    end
end
function c47530114.backcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c47530114.ntdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side and Duel.GetTurnPlayer==1-tp
end
function c47530114.backop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode)
    Duel.ConfirmCards(tp,Group.FromCards(c))
    Duel.ConfirmCards(1-tp,Group.FromCards(c))
    c:ReplaceEffect(tcode,0,0)
end