--阿拉德 艾丽丝
function c14801978.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,99,c14801978.lcheck)
    c:EnableReviveLimit()
    --atk gain
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c14801978.atktg)
    e1:SetValue(1000)
    c:RegisterEffect(e1)
    --control
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801978,2))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c14801978.cttg)
    e2:SetOperation(c14801978.ctop)
    c:RegisterEffect(e2)
end
function c14801978.lcheck(g,lc)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x480e) and g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end
function c14801978.atktg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x480e)
end
function c14801978.ctfilter1(c)
    local tp=c:GetControler()
    return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c14801978.ctfilter2(c)
    local tp=c:GetControler()
    return c:IsFaceup() and (c:IsSetCard(0x480e) or c:IsType(TYPE_TOKEN)) and c:IsAbleToChangeControler()
        and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c14801978.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c14801978.ctfilter1,tp,0,LOCATION_MZONE,1,nil)
        and Duel.IsExistingTarget(c14801978.ctfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g1=Duel.SelectTarget(tp,c14801978.ctfilter1,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g2=Duel.SelectTarget(tp,c14801978.ctfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c14801978.ctop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local a=g:GetFirst()
    local b=g:GetNext()
    if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
        Duel.SwapControl(a,b)
    end
end