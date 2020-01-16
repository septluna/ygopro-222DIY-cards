--月神坦克
function c47530035.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)     
    --splimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetRange(LOCATION_PZONE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c47530035.splimit)
    c:RegisterEffect(e0)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,47530035)
    e1:SetCondition(c47530035.spcon)
    e1:SetOperation(c47530035.spop)
    c:RegisterEffect(e1) 
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47530036)
    e2:SetTarget(c47530035.tetg)
    e2:SetOperation(c47530035.teop)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530035,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530035.xyzcon)
    e3:SetTarget(c47530035.xyztg)
    e3:SetOperation(c47530035.xyzop)
    c:RegisterEffect(e3)
end
function c47530035.splimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530035.cfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function c47530035.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530035.cfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c47530035.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c47530035.cfilter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c47530035.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE) and c:IsLevel(10)
end
function c47530035.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530035.tefilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_PZONE)
end
function c47530035.teop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47530035,3))
    local g=Duel.SelectMatchingCard(tp,c47530035.tefilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SendtoExtraP(c,tp,REASON_EFFECT)
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47530035.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530035.xyzfilter,1,nil,tp)
end
function c47530035.xyzfilter(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_XYZ) and c:IsRace(RACE_MACHINE)
end
function c47530035.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530035.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c47530035.xyzop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530035.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_XYZ)
    end
end