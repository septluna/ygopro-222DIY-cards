--高达试作2号机
function c47530163.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47530163.mfilter,c47530163.xyzcheck,2,2)
    --MK-82
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530163,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47530163+EFFECT_COUNT_CODE_DUEL)
    e1:SetCost(c47530163.cost)
    e1:SetOperation(c47530163.abop)
    c:RegisterEffect(e1)    
    --Gundam VS Gundam
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(1)
    e2:SetCondition(c47530163.actcon)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_SET_ATTACK)
    e3:SetCondition(c47530163.atkcon)
    e3:SetValue(c47530163.atkval)
    c:RegisterEffect(e3) 
    --
    --sps voice
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetCondition(c47530163.spscon)
    e5:SetOperation(c47530163.spssuc)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetCondition(c47530163.spscon2)
    e6:SetOperation(c47530163.spssuc2)
    c:RegisterEffect(e6)
end
function c47530163.mfilter(c,xyzc)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(5)
end
function c47530163.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c47530163.atkcon(e)
    local ph=Duel.GetCurrentPhase()
    local bc=e:GetHandler():GetBattleTarget()
    return ph==PHASE_DAMAGE_CAL and bc and bc:IsRace(RACE_MACHINE)
end
function c47530163.actcon(e)
    local bc=e:GetHandler():GetBattleTarget()
    return bc and bc:IsSetCard(0x5d5) and bc:IsRace(RACE_MACHINE)
end
function c47530163.atkval(e,c)
    return c:GetAttack()*2
end
function c47530163.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
    local ab=Duel.GetOperatedGroup():GetSum(Card.GetLevel)
    e:SetLabel(ab)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47530163,5))
end
function c47530163.abop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47530163,4))
    local c=e:GetHandler()
    local ab=e:GetLabel()
    local g=Duel.GetMatchingGroup(aux.TRUE,0,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
    local tg=g:RandomSelect(tp,ab)
    Duel.Destroy(tg,REASON_EFFECT,LOCATION_REMOVED)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
end
function c47530163.spscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47530163.spssuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47530163,1))
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47530163,3))
end
function c47530163.spscon2(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47530163.spssuc2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47530163,3))
end