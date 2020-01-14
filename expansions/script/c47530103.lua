--德天使高达
local m=47530103
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c47530103.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1) 
    --cannot diabled
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)   
    --GN Cannon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DAMAGE_STEP_END)
    e3:SetCondition(c47530103.bustercon)
    e3:SetOperation(c47530103.busterop)
    c:RegisterEffect(e3)
    --Purge
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c47530103.changetg)
    e4:SetOperation(c47530103.changeop)
    c:RegisterEffect(e4)  
    local e5=e4:Clone()
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_DESTROYED)
    c:RegisterEffect(e5)  
end
function c47530103.bustercon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()
end
function c47530103.desfilter(c,g)
    return g:IsContains(c)
end
function c47530103.busterop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    local cg=tc:GetColumnGroup()
    if tc then
        local g=Duel.GetMatchingGroup(c47530103.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
        if g:GetCount()>0 then
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end
function c47530103.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47530103.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    if c:ReplaceEffect(tcode,0,0) then   
    end
end