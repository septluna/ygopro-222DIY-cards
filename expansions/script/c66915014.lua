--掠夺星曜·贪狼
local m=66915014
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)     
    --draw
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(97616504,0))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(cm.drcon)
    e4:SetTarget(cm.drtg)
    e4:SetOperation(cm.drop)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(cm.eftg)
    e5:SetLabelObject(e4)
    --recover
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_RECOVER)
    e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e11:SetCode(EVENT_BATTLE_DESTROYING)
    e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e11:SetCondition(cm.reccon)
    e11:SetTarget(cm.rectg)
    e11:SetOperation(cm.recop)
    local e55=Effect.CreateEffect(c)
    e55:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e55:SetRange(LOCATION_MZONE)
    e55:SetTargetRange(LOCATION_MZONE,0)
    e55:SetTarget(cm.eftg)
    e55:SetLabelObject(e11)
    --spsummon limit
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_FIELD)
    e22:SetRange(LOCATION_SZONE)
    e22:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e22:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e22:SetTargetRange(1,0)
    e22:SetTarget(cm.sumlimit)
    c:RegisterEffect(e22)
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsCode(66915001)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return  Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil) and eg:GetFirst()==ec and Duel.GetAttacker()==ec
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function cm.eftg(e,c)
    local seq=c:GetSequence()
    return  c:IsSetCard(0x1374)
    and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)<=1
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local t=Duel.GetAttackTarget()
    if ev==1 then t=Duel.GetAttacker() end
    if not c:IsRelateToBattle() or c:IsFacedown() then return false end
    e:SetLabel(t:GetAttack())
    return t:GetLocation()==LOCATION_GRAVE and t:IsType(TYPE_MONSTER)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end