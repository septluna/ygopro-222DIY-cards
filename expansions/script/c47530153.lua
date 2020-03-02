--吉姆II
function c47530153.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,47530153)
    e1:SetCondition(c47530153.spcon)
    c:RegisterEffect(e1) 
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530153,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47530154)
    e2:SetCost(c47530153.spcost)
    e2:SetTarget(c47530153.target)
    e2:SetOperation(c47530153.operation)
    c:RegisterEffect(e2)  
end
function c47530153.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5d6)
end
function c47530153.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c47530153.spfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c47530153.cfilter(c,ft)
    return c:IsRace(RACE_MACHINE) and (ft>0 or c:GetSequence()<5)
end
function c47530153.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c47530153.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c47530153.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c47530153.filter(c,e,tp)
    return c:IsCode(47530144) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530153.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530153.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47530153.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local sc=Duel.GetFirstMatchingCard(c47530153.filter,tp,LOCATION_DECK,0,nil,e,tp)
    if sc then
        Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
    end
end