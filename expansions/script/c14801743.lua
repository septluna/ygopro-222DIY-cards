--星际战舰 跃迁之门
local m=14801743
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableCounterPermit(0x48f)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetCategory(CATEGORY_COUNTER)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetTarget(cm.target)
    e0:SetOperation(cm.activate)
    c:RegisterEffect(e0)
    --extra summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.sumcon)
    e3:SetCost(cm.cost)
    e3:SetTarget(cm.sumtg)
    e3:SetOperation(cm.sumop)
    c:RegisterEffect(e3)
    --activate
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,m)
    e4:SetCondition(cm.con3)
    e4:SetTarget(cm.target3)
    e4:SetOperation(cm.activate3)
    c:RegisterEffect(e4)
    --Pos Change
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_SET_POSITION)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTarget(cm.target2)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetValue(POS_FACEUP_DEFENSE)
    c:RegisterEffect(e6)
    --
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_DEFENSE_ATTACK)
    e7:SetRange(LOCATION_FZONE)
    e7:SetTargetRange(LOCATION_MZONE,0)
    e7:SetTarget(cm.target2)
    e7:SetValue(1)
    c:RegisterEffect(e7)
end
function cm.target2(e,c)
    return c:IsSetCard(0x480b) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanAddCounter(tp,0x48f,3,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x48f)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:AddCounter(0x48f,3)
    end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function cm.filter3(c,tp)
    return c:IsType(TYPE_FIELD) and c:IsSetCard(0x480b) and not c:IsCode(m) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp,true,true))
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
    if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
    if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
    local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.ResetFlagEffect(tp,15248873)
    local tc=g:GetFirst()
    if tc then
        local te=tc:GetActivateEffect()
        local b1=tc:IsAbleToHand()
        if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
        local b2=te:IsActivatable(tp,true,true)
        Duel.ResetFlagEffect(tp,15248873)
        if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
            if fc then
                Duel.SendtoGrave(fc,REASON_RULE)
                Duel.BreakEffect()
            end
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            te:UseCountLimit(tp,1,true)
            local tep=tc:GetControler()
            local cost=te:GetCost()
            if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
            Duel.RaiseEvent(tc,m,te,0,tp,tp,Duel.GetCurrentChain())
        end
    end
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,8567955)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48f,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x48f,1,REASON_COST)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end