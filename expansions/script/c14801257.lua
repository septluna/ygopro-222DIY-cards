--白玉 红音
local m=14801257
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.cona)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_RECOVER)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.descon)
    e3:SetTarget(cm.destg)
    e3:SetOperation(cm.desop)
    c:RegisterEffect(e3)
    --to defense
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
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
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function cm.thfilter(c)
    return c:IsSetCard(0x480a) or c:IsSetCard(0x4802) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and e:GetHandler():IsDefensePos()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
    end
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