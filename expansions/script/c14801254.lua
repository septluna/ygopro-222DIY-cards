--白玉 红叶
local m=14801254
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
    --avoid damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_RECOVER)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cm.cond)
    e3:SetOperation(cm.op)
    c:RegisterEffect(e3)
    --to defense
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_POSITION)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(cm.potg)
    e4:SetOperation(cm.poop)
    c:RegisterEffect(e4)
end
function cm.cona(e)
    return e:GetHandler():IsAttackPos()
end
function cm.cond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos() and tp==ep
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function cm.tga(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function cm.filter(c)
    return c:IsSetCard(0x4802) or c:IsSetCard(0x480a) and c:IsAbleToHand()
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    local dc=Duel.TossDice(tp,1)
    Duel.ConfirmDecktop(tp,dc)
    local dg=Duel.GetDecktopGroup(tp,dc)
    local g=dg:Filter(cm.filter,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
    Duel.ShuffleDeck(tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,200,REASON_EFFECT)
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