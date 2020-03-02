--高达强夺作战
local m=47530161
local cm=_G["c"..m]
function c47530161.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetCountLimit(1,47530161)
    e1:SetTarget(c47530161.target)
    e1:SetOperation(c47530161.operation)
    c:RegisterEffect(e1)
    --StarDust
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetTarget(c47530161.sdtg)
    e2:SetValue(1)
    c:RegisterEffect(e2) 
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UNRELEASABLE_SUM)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e4)
    local e6=e4:Clone()
    e6:SetCode(EFFECT_MUST_ATTACK)
    c:RegisterEffect(e6)
    local e7=e2:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e7)    
    local e8=e2:Clone()
    e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e8)   
    local e9=e2:Clone()
    e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    c:RegisterEffect(e9)   
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_SET_POSITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(c47530161.sdtg)
    e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e5:SetValue(POS_FACEUP_ATTACK)
    c:RegisterEffect(e5)
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e10:SetTargetRange(1,1)
    e10:SetRange(LOCATION_SZONE)
    e10:SetCondition(c47530161.gcon)
    e10:SetValue(DOUBLE_DAMAGE)
    c:RegisterEffect(e10)  
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetRange(LOCATION_SZONE)
    e11:SetCode(EVENT_ATTACK_ANNOUNCE)
    e11:SetCondition(c47530161.gundamcon)
    e11:SetOperation(c47530161.gundamop)
    c:RegisterEffect(e11) 
end
c47530161.is_named_with_EFSF=1
function c47530161.IsEFSF(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_EFSF
end
function c47530161.sdtg(e,c)
    return c:IsRace(RACE_MACHINE)
end
function c47530161.gp01filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCode(47530165) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c47530161.gp02filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCode(47530163) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c47530161.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530161.gp02filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c47530161.gp01filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0 end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
    Duel.SetChainLimit(aux.FALSE)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47530161,0))
end
function c47530161.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        local ag=Duel.GetMatchingGroup(c47530161.gp02filter,tp,LOCATION_EXTRA,0,nil,e,tp)     
        local tc1=ag:GetFirst()
        if tc1 then
            Duel.SpecialSummon(tc1,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
            Duel.BreakEffect()
            local sg=Duel.GetMatchingGroup(c47530161.gp01filter,tp,LOCATION_EXTRA,0,nil,e,tp)    
            local tc2=sg:GetFirst()
            if tc2 then
                Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP_ATTACK)
            end
        end
    end
end
function c47530161.gcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return a and d and a:IsFaceup() and a:IsRace(RACE_MACHINE) and d:IsFaceup() and d:IsRace(RACE_MACHINE)
end
function c47530161.gundamcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return a and d and a:IsFaceup() and a:IsSetCard(0x5d5) and a:IsRace(RACE_MACHINE) and d:IsFaceup() and d:IsRace(RACE_MACHINE) and d:IsSetCard(0x5d5)
end
function c47530161.gundamop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget() 
    a:RegisterFlagEffect(47530161,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,true)    
    d:RegisterFlagEffect(47530161,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,true) 
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,1)
    e1:SetValue(c47530161.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47530161.aclimit(e,re,tp)
    return e:GetHandler():GetFlagEffect(47530161)==0
end