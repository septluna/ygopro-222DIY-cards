--地球联邦宇宙军
local m=47530159
local cm=_G["c"..m]
function c47530159.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47530159+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)   
    --E.F.S.F
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530159,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetTarget(c47530159.thtg)
    e2:SetOperation(c47530159.thop)
    c:RegisterEffect(e2)     
end
c47530159.is_named_with_EFSF=1
function c47530159.IsEFSF(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_EFSF
end
function c47530159.gfilter(c)
    return c:IsSetCard(0x5d5) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c47530159.thfilter(c,e,tp)
    return (c:IsSetCard(0x5d4) or c:IsSetCard(0x5d6)) and (c:IsAbleToHand() or (gchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c47530159.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local gchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetMatchingGroupCount(c47530159.gfilter,tp,LOCATION_MZONE,0,nil)>=1
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c47530159.thfilter(chkc,e,tp,gchk) end
    if chk==0 then return Duel.IsExistingTarget(c47530159.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,gchk) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47530159.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,gchk)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47530159.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.GetMatchingGroupCount(c47530159.gfilter,tp,LOCATION_MZONE,0,nil)>=1
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
            and Duel.SelectOption(tp,1190,1152)==1 then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
        end
    end
end