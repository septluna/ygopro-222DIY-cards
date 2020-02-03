--白玉 羽二重兔
local m=14801256
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    --extra summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.cona)
    c:RegisterEffect(e2)
    local e5=e2:Clone()
    e5:SetCode(EFFECT_EXTRA_SET_COUNT)
    c:RegisterEffect(e5)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_RECOVER)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.cond)
    e3:SetTarget(cm.thtg)
    e3:SetOperation(cm.thop)
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
function cm.cona(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsAttackPos()
end
function cm.cond(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and e:GetHandler():IsDefensePos()
end
function cm.thfilter(c)
    return c:IsSetCard(0x4802) or c:IsSetCard(0x480a) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
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