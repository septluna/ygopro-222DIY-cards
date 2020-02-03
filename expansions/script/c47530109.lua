--高达试作3号机石斛兰
function c47530109.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c47530109.lfilter,2,2,c47530109.lcheck)  
    --spsummon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.linklimit)
    c:RegisterEffect(e0)
    --I FIELD
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c47530109.efilter)
    c:RegisterEffect(e1)
    --Missile Container
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c47530109.mctg)
    e2:SetOperation(c47530109.mcop)
    c:RegisterEffect(e2)
    --Purge
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_LEAVE_FIELD)   
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1)
    e3:SetTarget(c47530109.sptg)
    e3:SetOperation(c47530109.spop)
    c:RegisterEffect(e3)
end
function c47530109.lfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK)
end
function c47530109.lcheck(g)
    local ec=g:GetFirst()
    local lm=0
    while ec do
        if ec:IsLinkMarker(LINK_MARKER_TOP) then lm=lm+0x002 end
        if ec:IsLinkMarker(LINK_MARKER_LEFT) then lm=lm+0x008 end
        if ec:IsLinkMarker(LINK_MARKER_RIGHT) then lm=lm+0x020 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then lm=lm+0x040 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM) then lm=lm+0x080 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then lm=lm+0x100 end
        ec=g:GetNext()
    end
    return lm==0x1ea
end
function c47530109.efilter(e,te)
    return not te:GetOwner():IsRace(RACE_MACHINE)
end
function c47530109.mctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,47530110,0,0x4011,0,0,2,RACE_MACHINE,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c47530109.mcop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,47530110,0,0x4011,0,0,2,RACE_MACHINE,ATTRIBUTE_EARTH) then
        for i=1,2 do
            local token=Duel.CreateToken(tp,47530110)
            Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        end
        Duel.SpecialSummonComplete()
    end
end
function c47530109.spfilter(c,e,tp,g)
    return g:IsContains(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c47530109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530109.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,g) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47530109.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,c47530109.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g)
    if sg:GetCount()>0 then
        Duel.SpecialSummon(sg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
    end
end