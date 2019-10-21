--灾厄异人 梅特龙
function c14801043.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801043,2))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801043)
    e1:SetCondition(c14801043.spcon)
    e1:SetTarget(c14801043.sptg)
    e1:SetOperation(c14801043.spop)
    c:RegisterEffect(e1)
    --effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(c14801043.efcon)
    e2:SetOperation(c14801043.efop)
    c:RegisterEffect(e2)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801043,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_REMOVE)
    e3:SetCountLimit(1,14801043)
    e3:SetTarget(c14801043.thtg)
    e3:SetOperation(c14801043.thop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c14801043.thcon)
    c:RegisterEffect(e4)
end
function c14801043.cfilter(c,tp)
    return c:IsSetCard(0x4800) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c14801043.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c14801043.cfilter,1,nil,tp)
end
function c14801043.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14801043.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c14801043.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x4800)
end
function c14801043.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801043,1))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetLabel(ep)
    e1:SetValue(c14801043.tgval)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
end
function c14801043.tgval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
        and te:IsActiveType(TYPE_SPELL)
end
function c14801043.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c14801043.thfilter(c)
    return c:IsSetCard(0x4800) and not c:IsCode(14801043) and c:IsAbleToHand()
end
function c14801043.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801043.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801043.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801043.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end