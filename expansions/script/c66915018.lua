--伴随星光而生的阴影
local m=66915018
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetCost(cm.atkcost)
    e1:SetCondition(cm.spcon)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)    
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(cm.tg)
    e2:SetOperation(cm.op)
    c:RegisterEffect(e2)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c,e,tp)
    return  c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(66915019) or c:IsCode(66915020) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.filters,tp,LOCATION_SZONE,0,1,nil)
end
function cm.filters(c,e,tp)
    return c:IsSetCard(0x374) and c:IsFaceup() 
end
function cm.cfilter(c)
    return c:IsCode(66915001) and c:IsAbleToGraveAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end
function cm.tfilter(c)
    return c:IsFaceup() and c:IsCanTurnSet() and c:IsCode(66915019) or c:IsCode(66915020)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.tobirafilter(c)
    return c.dfc_front_side and not c:IsType(TYPE_FLIP) 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local tc=g:GetFirst()
    e:SetLabel(tc.dfc_front_side)
    local c=e:GetHandler()
    local mcode=tc:GetOriginalCode()
    if Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,POS_FACEDOWN_DEFENSE,POS_FACEDOWN_ATTACK,POS_FACEDOWN_DEFENSE)>0 then
        local tcode=e:GetLabel()
        tc:SetEntityCode(tcode,true)
        tc:ReplaceEffect(tcode,0,0)
        Duel.SetMetatable(tc,_G["c"..tcode])
        Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_LEAVE_FIELD)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            if not mcode then return end
            c:SetEntityCode(mcode)
            c:ReplaceEffect(mcode,0,0)
            Duel.SetMetatable(c,_G["c"..mcode])
        end)
        tc:RegisterEffect(e2)
    end
end