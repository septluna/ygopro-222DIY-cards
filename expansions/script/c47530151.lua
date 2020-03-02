--吉姆特装型
function c47530151.initial_effect(c)
    --SpecialSummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530151,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,47530151)
    e1:SetTarget(c47530151.target)
    e1:SetOperation(c47530151.operation)
    c:RegisterEffect(e1)   
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530151,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47530151)
    e2:SetTarget(c47530151.target2)
    e2:SetOperation(c47530151.operation2)
    c:RegisterEffect(e2)   
end
function c47530151.filter(c,lv)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(1) and c:IsFaceup() and not c:IsLevel(lv) 
end
function c47530151.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47530151.filter(chkc) end
    local c=e:GetHandler()
    local lv=c:GetLevel()
    if chk==0 then return lv>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c47530151.filter,tp,LOCATION_MZONE,0,1,c,lv) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c47530151.filter,tp,LOCATION_MZONE,0,1,1,c,lv)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47530151.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsLevel(c:GetLevel()) then
        local g=Group.FromCards(c,tc)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47530151,2))
        local sg=g:Select(tp,1,1,nil)
        local tc=sg:GetFirst()
        g:RemoveCard(tc)
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(tc:GetLevel())
        g:GetFirst():RegisterEffect(e1)
    end
end
function c47530151.filter2(c)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(1) and c:IsFaceup() 
end
function c47530151.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47530151.filter2(chkc) end
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c47530151.filter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c47530151.filter2,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47530151.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) then return end
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local lv=c:GetOriginalLevel()+tc:GetOriginalLevel()
        c47530151.setlv(c,c,lv)
        c47530151.setlv(c,tc,lv)
    end
end
function c47530151.setlv(c,ec,lv)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LEVEL)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e1:SetValue(lv)
    ec:RegisterEffect(e1)
end