--灾厄魔鸟 贝蒙斯坦
function c14801026.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2)
    c:EnableReviveLimit()
    --destroy replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801026.reptg)
    c:RegisterEffect(e1)
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801026,0))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCost(c14801026.cost)
    e2:SetTarget(c14801026.target)
    e2:SetOperation(c14801026.operation)
    c:RegisterEffect(e2)
    --actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(1)
    e3:SetCondition(c14801026.actcon)
    c:RegisterEffect(e3)
end
function c14801026.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end
function c14801026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801026.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if chk==0 then return tc and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
end
function c14801026.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c14801026.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end