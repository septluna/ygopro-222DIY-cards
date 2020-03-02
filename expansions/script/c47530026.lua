--吉姆强袭型改
function c47530026.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47530026.psplimit)
    c:RegisterEffect(e1) 
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530026,1))
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetTarget(c47530026.sumtg)
    e2:SetOperation(c47530026.sumop)
    c:RegisterEffect(e2)   
    --spsummon proc
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c47530026.ttcon)
    e1:SetOperation(c47530026.ttop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c47530026.setcon)
    c:RegisterEffect(e2)
    --tribute check
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MATERIAL_CHECK)
    e5:SetValue(c47530026.valcheck)
    c:RegisterEffect(e5)
    --buff
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47530026.advcon)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetCode(EFFECT_IMMUNE_EFFECT)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47530026.advcon)
    e7:SetValue(c47530026.efilter)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetCode(EFFECT_EXTRA_ATTACK)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c47530026.advcon)
    e8:SetValue(1)
    c:RegisterEffect(e8) 
    --actlimit
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e9:SetCode(EFFECT_CANNOT_ACTIVATE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(0,1)
    e9:SetValue(c47530026.aclimit)
    e9:SetCondition(c47530026.actcon)
    c:RegisterEffect(e9)  
    --remove
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(47530026,0))
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_DAMAGE_STEP_END)
    e10:SetCondition(c47530026.rmcon)
    e10:SetOperation(c47530026.rmop)
    c:RegisterEffect(e10)
end
function c47530026.IsEFSF(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_EFSF
end
function c47530026.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    e:SetLabelObject(bc)
    return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function c47530026.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=e:GetLabelObject()
    local atk1=bc:GetAttack()
    local atk2=c:GetAttack()
    local atk=atk1+atk2
    if bc:IsRelateToBattle() then
        local lp=Duel.GetLP(1-tp)
        Duel.SetLP(1-tp,lp-atk) 
    end
end
function c47530026.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47530026.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c47530026.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c47530026.advcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c47530026.psplimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530026.setfilter(c)
    return c47530026.IsEFSF(c) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) 
end
function c47530026.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsSummonable(true,nil,1) and Duel.IsExistingMatchingCard(c47530026.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c47530026.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.Summon(tp,c,true,nil,1)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local g=Duel.SelectMatchingCard(tp,c47530026.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,false)
        if g:GetCount()>0 then
            Duel.SSet(tp,g:GetFirst())
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function c47530026.otfilter(c)
    return c:GetSummonLocation()==LOCATION_EXTRA and c:IsRace(RACE_MACHINE)
end
function c47530026.ttcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47530026.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=2 and Duel.CheckTribute(c,2,2,mg)
end
function c47530026.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47530026.otfilter,0,LOCATION_MZONE,0,nil)
    local sg=Duel.SelectTribute(tp,c,2,2,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47530026.setcon(e,c,minc)
    if not c then return true end
    return false
end
function c47530026.valcheck(e,c)
    local g=c:GetMaterial()
    local tc=g:GetFirst()
    local atk=0
    local def=0
    while tc do
        local catk=tc:GetTextAttack()
        local cdef=tc:GetTextDefense()
        atk=atk+(catk>=0 and catk or 0)
        def=def+(cdef>=0 and cdef or 0)
        tc=g:GetNext()
    end
    if e:GetLabel()==1 then
        e:SetLabel(0)
        --atk continuous effect
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e1)
        --def continuous effect
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(def)
        c:RegisterEffect(e2)
    end
end