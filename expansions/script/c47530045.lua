--卡贝拉·迪特拉
function c47530045.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    --splimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c47530045.psplimit)
    c:RegisterEffect(e0)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,47530045)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(c47530045.condition)
    e1:SetTarget(c47530045.sptg)
    e1:SetOperation(c47530045.spop)
    c:RegisterEffect(e1) 
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530045,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetRange(LOCATION_EXTRA+LOCATION_HAND)
    e2:SetTargetRange(POS_FACEUP_DEFENSE,0)
    e2:SetCountLimit(1,47530049)
    e2:SetCondition(c47530045.spcon)
    e2:SetValue(c47530045.spval)
    c:RegisterEffect(e2) 
    --effect gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(c47530045.effcon)
    e3:SetOperation(c47530045.effop)
    c:RegisterEffect(e3) 
end
function c47530045.psplimit(e,c,tp,sumtp,sumpos)
    return not c:IsRace(RACE_MACHINE)
end
function c47530045.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=eg:GetFirst()
    return eg:GetCount()==1 and c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c47530045.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsRace(RACE_MACHINE)
end
function c47530045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c47530045.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47530045.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and zone~=0 then
        local tc=eg:GetFirst()
        local zone=tc:GetLinkedZone(tp)
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c47530045.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local zone=Duel.GetLinkedZone(tp)
    return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c47530045.spval(e,c)
    return 0,Duel.GetLinkedZone(c:GetControler())
end
function c47530045.effcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetReasonCard()
    return r==REASON_XYZ and c:IsRace(RACE_MACHINE)
end
function c47530045.effop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(47530045,2))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c47530045.mdtg)
    e1:SetOperation(c47530045.mdop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
end
function c47530045.mdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    nseq=math.log(s,2)
    Duel.MoveSequence(c,nseq)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,1,1,0,0)
end
function c47530045.desfilter(c,g)
    return g:IsContains(c) and c:GetSequence()<5
end
function c47530045.mdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local seq=4-c:GetSequence()
    local cg=c:GetColumnGroup()
    if c:IsRelateToEffect(e) then
        local g=Duel.GetMatchingGroup(c47530045.desfilter,tp,0,LOCATION_MZONE,nil,cg)
        if g:GetCount()>0 then
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end