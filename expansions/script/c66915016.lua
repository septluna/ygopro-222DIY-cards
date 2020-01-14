--星曜武神·灿辉
local m=66915016
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)    
    --atkup
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_SINGLE)
    e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e22:SetRange(LOCATION_MZONE)
    e22:SetCode(EFFECT_UPDATE_ATTACK)
    e22:SetValue(cm.val)
    c:RegisterEffect(e22) 
    --
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_QUICK_O)
    e11:SetCode(EVENT_FREE_CHAIN)
    e11:SetRange(LOCATION_MZONE)
    e11:SetHintTiming(TIMING_BATTLE_START)
    e11:SetCondition(cm.condition)
    e11:SetTarget(cm.thtg)
    e11:SetOperation(cm.thop)
    c:RegisterEffect(e11)
end
function cm.filter(c)
    return c:IsSetCard(0x374) and c:IsType(TYPE_SPELL) or  c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function cm.val(e,c)
    return  Duel.GetMatchingGroupCount(cm.filter,c:GetControler(),LOCATION_SZONE,0,nil)*800
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_BATTLE_START and Duel.GetTurnPlayer()==tp
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetHandler():GetAttack()
    local lp=Duel.GetLP(1-tp)
    if Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)>0 and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_HAND)>0 then
     if ct>=lp then ct=lp end
     Duel.SetLP(1-tp,lp-ct)
    else
     if ct>=lp then ct=lp end
     Duel.SetLP(1-tp,lp-2*ct)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end