--征伏龙王-狰狞
function c50218570.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c50218570.check,2,2,c50218570.lcheck)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,50218570)
    e1:SetTarget(c50218570.target)
    e1:SetOperation(c50218570.operation)
    c:RegisterEffect(e1)
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c50218570.matcon)
    e2:SetTarget(c50218570.mattg)
    e2:SetOperation(c50218570.matop)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(aux.bdocon)
    e3:SetTarget(c50218570.drtg)
    e3:SetOperation(c50218570.drop)
    c:RegisterEffect(e3)
end
function c50218570.check(c)
    return c:IsLevelAbove(1)
end
function c50218570.lcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c50218570.filter(c,e,tp)
    return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
        and Duel.IsExistingMatchingCard(c50218570.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c50218570.spfilter(c,e,tp,tc)
    return c:IsSetCard(0xcb5) and c:IsLevel(tc:GetLevel())
        and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50218570.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c50218570.filter(chkc,e,tp) and chkc~=c end
    if chk==0 then return Duel.IsExistingTarget(c50218570.filter,tp,LOCATION_MZONE,0,1,c,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c50218570.filter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50218570.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c50218570.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
        if g:GetCount()~=0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c50218570.matcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c50218570.matfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c50218570.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50218570.matfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218570.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c50218570.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c50218570.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c50218570.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50218570.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end