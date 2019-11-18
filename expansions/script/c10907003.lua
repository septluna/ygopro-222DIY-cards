--花寄女生 花丸晴琉
function c10907003.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c10907003.spcon)
    e1:SetOperation(c10907003.ntop)
    c:RegisterEffect(e1)        
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCondition(c10907003.repcon)
    e1:SetOperation(c10907003.repop)
    c:RegisterEffect(e1)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetDescription(aux.Stringid(10907003,2))
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCountLimit(1,10907003)
    e6:SetCondition(c10907003.spcon)
    e6:SetTarget(c10907003.tg3)
    e6:SetOperation(c10907003.op3)
    c:RegisterEffect(e6)
end
function c10907003.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsEnvironment(10907000)
end
function c10907003.ntop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(10907003,RESET_EVENT+RESETS_REDIRECT,0,1)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(10907003,0))
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
    e:GetHandler():RegisterEffect(e1)
end
function c10907003.repcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and e:GetHandler():GetFlagEffect(10907003)==0
end
function c10907003.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
end
function c10907003.filter3(c,e,tp)
    return c:IsSetCard(0x23a) and c:IsType(TYPE_MONSTER) and not c:IsCode(10907003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10907003.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10907003.filter3(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c10907003.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c10907003.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10907003.op3(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
    local code=tc:GetOriginalCode()
    tc:RegisterFlagEffect(code,RESET_EVENT+RESETS_REDIRECT,0,1)
    local e1=Effect.CreateEffect(tc)
    e1:SetDescription(aux.Stringid(10907003,0))
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
    tc:RegisterEffect(e1)
    end
end