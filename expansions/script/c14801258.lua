--白玉 黑蜜大树
local m=14801258
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --recover 1
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_FZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.recon1)
    e2:SetTarget(cm.retg1)
    e2:SetOperation(cm.reop1)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,3))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.spcon)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3)
    --draw
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(cm.drcon)
    e4:SetTarget(cm.drtg)
    e4:SetOperation(cm.drop)
    c:RegisterEffect(e4)
    --recover
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(cm.reccon)
    e5:SetOperation(cm.recop)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e7)
end
function cm.thfilter(c)
    return c:IsSetCard(0x4802) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function cm.recon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>=5
end
function cm.retg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(200)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,200)
end
function cm.reop1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(200)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    Duel.RegisterEffect(e2,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>=1
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x4802) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>=3
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function cm.cfilter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsLevel(1)
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,200,REASON_EFFECT)
end