--白玉 雪见
local m=14801255
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.cona)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.tga)
    e2:SetOperation(cm.opa)
    c:RegisterEffect(e2)
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetOperation(cm.regop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVED)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(cm.damcon)
    e4:SetOperation(cm.damop)
    c:RegisterEffect(e4)
    --to defense
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,1))
    e5:SetCategory(CATEGORY_POSITION)
    e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(cm.potg)
    e5:SetOperation(cm.poop)
    c:RegisterEffect(e5)
end
function cm.cona(e)
    return e:GetHandler():IsAttackPos()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function cm.tga(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
        local g=Duel.GetDecktopGroup(tp,ct)
        return g:FilterCount(cm.thfilters,nil)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.thfilters(c)
    return c:IsSetCard(0x4802) or c:IsSetCard(0x480a) and c:IsAbleToHand()
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    Duel.ConfirmDecktop(tp,ct)
    local g=Duel.GetDecktopGroup(tp,ct)
    if g:GetCount()>0 then
        local tg=g:Filter(cm.thfilters,nil)
        if tg:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=tg:Select(tp,1,1,nil)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
        end
        Duel.ShuffleDeck(tp)
    end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetFlagEffect(m)~=0 and ep~=tp and e:GetHandler():IsDefensePos()
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,200,REASON_EFFECT)
end
function cm.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAttackPos() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function cm.poop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end