--座天使高达一型
local m=47530106
local cm=_G["c"..m]
function c47530106.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47530106.mfilter,c47530106.xyzcheck,2,2)    
    --
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e0)
    --GN Launcher
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530106,1))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c47530106.launchercost)
    e1:SetTarget(c47530106.launchertg)
    e1:SetOperation(c47530106.launcherop)
    c:RegisterEffect(e1)
    --GN Launcher MAX
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530106,2))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c47530106.maxcost)
    e2:SetCondition(c47530106.maxcon)
    e2:SetTarget(c47530106.maxtg)
    e2:SetOperation(c47530106.maxop)
    c:RegisterEffect(e2)
end
function c47530106.mfilter(c,xyzc)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(4)
end
function c47530106.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c47530106.launchercost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47530106.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47530106.dfilter,tp,0,LOCATION_MZONE,1,e:GetLabel())
end
function c47530106.desfilter(c,s,tp)
    local seq=c:GetSequence()
    return seq<5 and math.abs(seq-s)==1 and c:IsControler(tp)
end
function c47530106.launchertg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)   
end   
function c47530106.launcherop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local lg=tc:GetColumnGroup()
    local seq=tc:GetSequence()
    local dg=Group.CreateGroup()
    if seq<5 then dg=Duel.GetMatchingGroup(c47530106.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,tc:GetControler()) end
    dg:AddCard(tc)
    local ct=dg:GetCount()
    if ct>0 then
        Duel.Destroy(dg,REASON_EFFECT)
        Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
    end
end
function c47530106.maxcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c47530106.cfilter(c)
    return c:IsCode(47530108) and c:IsType(TYPE_MONSTER)
end
function c47530106.maxcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47530106.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47530106.maxtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function c47530106.maxop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
    Duel.Damage(1-tp,4000,REASON_EFFECT)
end