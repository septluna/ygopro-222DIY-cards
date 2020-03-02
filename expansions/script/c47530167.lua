--高达试作1号机全方位推进器
function c47530167.initial_effect(c)
    --full boost
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530067,1))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c47530167.fbcon)
    e1:SetTarget(c47530167.fbtg)
    e1:SetOperation(c47530167.fbop)
    c:RegisterEffect(e1)   
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47530167.fbcon)
    e2:SetValue(c47530167.tglimit)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530167.fbcon)
    e3:SetValue(c47530167.efilter)
    c:RegisterEffect(e3) 
    --dash
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47530067,1))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCountLimit(2)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCondition(c47530167.fbcon)
    e4:SetOperation(c47530167.dpop)
    c:RegisterEffect(e4)
    --direct attack
    local e5=Effect.CreateEffect(c)
    e5:SetCondition(c47530167.fbcon)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e5)
end
function c47530167.fbcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,47530165)
end
function c47530167.fbtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c47530167.fbop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    if Duel.MoveSequence(c,nseq)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end
function c47530167.tglimit(e,c)
    return not c:GetBattleTarget():GetColumnGroup():IsContains(c)
end
function c47530167.efilter(e,te)
    local c=e:GetHandler()
    return not te:GetOwner():GetColumnGroup():IsContains(c) and te:GetOwner()~=e:GetOwner()
end
function c47530167.dpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(c,nseq)
end