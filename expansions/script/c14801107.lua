--华丽偶像 浪漫关系
function c14801107.initial_effect(c)
    --material
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801107,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801107)
    e1:SetTarget(c14801107.mattg)
    e1:SetOperation(c14801107.matop)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801107,1))
    e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c14801107.damcon)
    e2:SetOperation(c14801107.damop)
    c:RegisterEffect(e2)
end
function c14801107.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4801) and c:IsType(TYPE_XYZ)
end
function c14801107.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801107.matfilter(chkc) end
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingTarget(c14801107.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c14801107.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c14801107.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c14801107.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetOriginalRace()==RACE_SPELLCASTER and ep==tp and c:IsRelateToBattle() and eg:GetFirst()==c:GetBattleTarget()
end
function c14801107.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(1-ep,ev,false)
end
