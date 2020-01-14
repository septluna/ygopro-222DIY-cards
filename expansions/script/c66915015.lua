--时空星曜·时钟
local m=66915015
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_ACTIVATE)
    e11:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e11)  
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCost(cm.cost)
    e1:SetCondition(cm.con)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)    
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.sumlimit)
    c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
    if Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
       Duel.SetChainLimit(aux.FALSE)
    end
end
function cm.cfilters(c)
    return c:IsFaceup() and c:IsCode(66915020)
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsCode(66915001)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) 
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e1:SetCountLimit(1)
    e1:SetOperation(cm.spop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.filter(c,e,tp,id)
    return c:IsReason(REASON_DESTROY) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0x1374)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e,tp,Duel.GetTurnCount())
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,m) then ft=1 end
    local g=nil
    if tg:GetCount()>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=tg:Select(tp,ft,ft,nil)
    else
        g=tg
    end
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)        
    end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end