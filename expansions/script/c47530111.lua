--强化型ZZ高达
function c47530111.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c47530111.lfilter,2,2,c47530111.lcheck) 
    --gurad taisei
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetCondition(c47530111.gdcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)     
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47530111.gdcon)
    e2:SetValue(c47530111.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530111.dmcon)
    e3:SetOperation(c47530111.dmop)
    c:RegisterEffect(e3)
    --Mega Cannon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e4:SetTarget(c47530111.mgtg)
    e4:SetOperation(c47530111.mgop)
    c:RegisterEffect(e4)
    --pierce
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_PIERCE)
    e5:SetValue(DOUBLE_DAMAGE)
    c:RegisterEffect(e5)
end
function c47530111.lfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK)
end
function c47530111.lcheck(g)
    local ec=g:GetFirst()
    local lm=0
    while ec do
        if ec:IsLinkMarker(LINK_MARKER_LEFT) then lm=lm+0x008 end
        if ec:IsLinkMarker(LINK_MARKER_RIGHT) then lm=lm+0x020 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then lm=lm+0x040 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM) then lm=lm+0x080 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then lm=lm+0x100 end
        ec=g:GetNext()
    end
    return lm==0x1e8
end
function c47530111.dmcon(e,tp,eg,ep,ev,re,r,rp)
    if ep~=tp then return false end
    return e:GetHandler():IsRelateToBattle() and ev>=1000
end
function c47530111.dmop(e,tp)
    Duel.RegisterFlagEffect(tp,47530111,RESET_PHASE+PHASE_END,0,1)
end
function c47530111.gdcon(e,tp)
    return Duel.GetFlagEffect(tp,47530111)==0
end
function c47530111.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47530111.posfilter(c)
    return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c47530111.disfilter(c)
    return c:IsPosition(POS_FACEUP_DEFENSE)
end
function c47530111.mgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530111.posfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c47530111.posfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c47530111.mgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47530111.posfilter,tp,0,LOCATION_MZONE,nil)
    if #g>0 and Duel.ChangePosition(g,POS_FACEUP_DEFENSE,true)~=0 then
        Duel.BreakEffect()
        local tg=Duel.GetMatchingGroup(c47530111.disfilter,tp,0,LOCATION_MZONE,nil)
        local tc=tg:GetFirst()
        while tc do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
            tc=tg:GetNext()
        end
    end
end