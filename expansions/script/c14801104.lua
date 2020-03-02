--华丽偶像 化学超女子
function c14801104.initial_effect(c)
    --material
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801104,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801104)
    e1:SetTarget(c14801104.mattg)
    e1:SetOperation(c14801104.matop)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801104,1))
    e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_REVERSE_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1,0)
    e2:SetCondition(c14801104.con)
    e2:SetValue(c14801104.rev)
    c:RegisterEffect(e2)
end
function c14801104.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and c:IsType(TYPE_XYZ)
end
function c14801104.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801104.matfilter(chkc) end
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingTarget(c14801104.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c14801104.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c14801104.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c14801104.con(e)
    return e:GetHandler():GetOriginalRace()==RACE_SPELLCASTER 
end
function c14801104.rev(e,re,r,rp,rc)
    local c=e:GetHandler()
    return bit.band(r,REASON_BATTLE)~=0
        and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
