--华丽偶像 地平线
function c14801101.initial_effect(c)
    --move
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801101,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801101)
    e1:SetTarget(c14801101.seqtg)
    e1:SetOperation(c14801101.seqop)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801101,1))
    e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetCondition(c14801101.con)
    e2:SetTarget(c14801101.mttg)
    e2:SetOperation(c14801101.mtop)
    c:RegisterEffect(e2)
end
function c14801101.seqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and c:IsType(TYPE_XYZ)
end
function c14801101.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801101.seqfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801101.seqfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801101,2))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c14801101.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c14801101.seqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(tc,nseq)  
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c14801101.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOriginalRace()==RACE_SPELLCASTER and Duel.GetTurnPlayer()==tp
end
function c14801101.mtfilter(c)
    return c:IsSetCard(0x4801) and c:IsType(TYPE_MONSTER)
end
function c14801101.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c14801101.mtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c14801101.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c14801101.mtfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end