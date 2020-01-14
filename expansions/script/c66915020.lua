--幽冥女神·暮夕
local m=66915020
local cm=_G["c"..m]
function cm.initial_effect(c)
    cm.dfc_front_side=66915019
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --search
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_DRAW)
    e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    e11:SetCondition(cm.condition)
    e11:SetTarget(cm.tftg)
    e11:SetOperation(cm.tfop)
    c:RegisterEffect(e11)
    --Trap activate in set turn
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.discon)
    e2:SetTargetRange(LOCATION_SZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x374))
    c:RegisterEffect(e2)
    --atkup
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_SINGLE)
    e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e22:SetRange(LOCATION_MZONE)
    e22:SetCode(EFFECT_UPDATE_ATTACK)
    e22:SetCondition(cm.discons)
    e22:SetValue(cm.val)
    c:RegisterEffect(e22) 
    --Activate
    local e111=Effect.CreateEffect(c)
    e111:SetType(EFFECT_TYPE_QUICK_O)
    e111:SetCode(EVENT_FREE_CHAIN)
    e111:SetRange(LOCATION_MZONE)
    e111:SetHintTiming(TIMING_BATTLE_START)
    e111:SetCountLimit(1)
    e111:SetCondition(cm.disconss)
    e111:SetTarget(cm.target)
    e111:SetOperation(cm.activate)
    c:RegisterEffect(e111)
    --EN Blade
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(cm.disconsss)
    e7:SetCountLimit(1,m)
    e7:SetTarget(cm.blatg)
    e7:SetOperation(cm.blaop)
    c:RegisterEffect(e7)
end
function cm.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0x374) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.discon(e)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,1,nil)
end
function cm.discons(e)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,2,nil)
end
function cm.disconss(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,3,nil) and Duel.GetCurrentPhase()==PHASE_BATTLE_START and Duel.GetTurnPlayer()==tp
end
function cm.disconsss(e)
    return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,4,nil) and Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsCode(66915018)
end
function cm.tffilter(c,cc,tp)
    return c:IsType(TYPE_CONTINUOUS)
    and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_ONFIELD,cc) and c:IsType(TYPE_TRAP)
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,nil,tp):GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function cm.filtercc(c)
    return c:IsSetCard(0x374) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function cm.val(e,c)
    return  Duel.GetMatchingGroupCount(cm.filtercc,c:GetControler(),LOCATION_SZONE,0,nil)*1000
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetChainLimit(aux.FALSE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetCondition(cm.accon)
    e1:SetValue(cm.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.accon(e)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function cm.blatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
end
function cm.blaop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not ( Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) and c:IsRelateToEffect(e) ) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
    local g1=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_MZONE,1,1,nil,TYPE_MONSTER)
    local tc=g1:GetFirst()
    if not tc:IsPosition(POS_FACEUP_ATTACK) then
        Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
    end
    if not c:IsPosition(POS_FACEUP_ATTACK) then
        Duel.ChangePosition(c,POS_FACEUP_ATTACK)
    end
    if not ( tc:IsLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE) ) then return end
    Duel.CalculateDamage(c,tc)
end