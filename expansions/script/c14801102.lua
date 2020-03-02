--华丽偶像 下一站是你
function c14801102.initial_effect(c)
    --material
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801102,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801102)
    e1:SetTarget(c14801102.mattg)
    e1:SetOperation(c14801102.matop)
    c:RegisterEffect(e1)
    --get effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801102,1))
    e2:SetType(EFFECT_TYPE_XMATERIAL)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(c14801102.con)
    e2:SetValue(c14801102.atkval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    e3:SetValue(c14801102.defval)
    c:RegisterEffect(e3)
end
function c14801102.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and c:IsType(TYPE_XYZ)
end
function c14801102.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801102.matfilter(chkc) end
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingTarget(c14801102.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c14801102.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c14801102.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c14801102.con(e)
    return e:GetHandler():GetOriginalRace()==RACE_SPELLCASTER 
end
function c14801102.atkval(e,c)
    return c:GetOverlayCount()*500
end
function c14801102.defval(e,c)
    return c:GetOverlayCount()*500
end