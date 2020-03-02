--全装甲ZZ高达
local m=47530132
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+1 
function c47530132.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c47530132.lfilter,2,2,c47530132.lcheck)  
    --Full Armor
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(aux.indoval)
    c:RegisterEffect(e2) 
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_RELEASE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetTarget(c47530132.rellimit)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_REMOVE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Full Burst
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c47530132.destg)
    e5:SetOperation(c47530132.desop)
    c:RegisterEffect(e5)
    --Purge
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DESTROY_REPLACE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTarget(c47530132.desreptg)
    e6:SetOperation(c47530132.desrepop)
    c:RegisterEffect(e6)    
end
function c47530132.lfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK)
end
function c47530132.lcheck(g)
    local ec=g:GetFirst()
    local lm=0
    while ec do
        if ec:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then lm=lm+0x001 end
        if ec:IsLinkMarker(LINK_MARKER_TOP_LEFT) then lm=lm+0x008 end
        if ec:IsLinkMarker(LINK_MARKER_TOP) then lm=lm+0x002 end
        if ec:IsLinkMarker(LINK_MARKER_LEFT) then lm=lm+0x001 end
        if ec:IsLinkMarker(LINK_MARKER_RIGHT) then lm=lm+0x01 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then lm=lm+0x040 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM) then lm=lm+0x080 end
        if ec:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then lm=lm+0x100 end
        ec=g:GetNext()
    end
    return lm==0x1ca
end
function c47530132.rellimit(e,c,tp,sumtp)
    return c==e:GetHandler()
end
function c47530132.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,5,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,5,5,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,5,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,5,0,0)
end
function c47530132.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end
function c47530132.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        return true
    else return false end
end
function c47530132.desrepop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,47530132)
    local c=e:GetHandler()
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    if c:ReplaceEffect(tcode,0,0)~=0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_ADJUST)
        e1:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
        e1:SetCondition(c47530132.backon)
        e1:SetOperation(c47530132.backop)
        c:RegisterEffect(e1)
    end
end
function c47530132.backon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c47530132.backop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode)
    Duel.ConfirmCards(tp,Group.FromCards(c))
    Duel.ConfirmCards(1-tp,Group.FromCards(c))
    c:ReplaceEffect(tcode,0,0)
end