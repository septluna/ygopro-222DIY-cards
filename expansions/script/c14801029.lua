--灾厄机甲 英普莱扎
function c14801029.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2)
    c:EnableReviveLimit()
    --destroy replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801029.reptg)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801029,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c14801029.cost)
    e2:SetTarget(c14801029.target)
    e2:SetOperation(c14801029.operation)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetOperation(c14801029.spr)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801029,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetCountLimit(1,14801029)
    e4:SetCondition(c14801029.spcon)
    e4:SetTarget(c14801029.sptg)
    e4:SetOperation(c14801029.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c14801029.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end
function c14801029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function c14801029.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK_FINAL)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        e2:SetValue(math.ceil(atk/2))
        tc:RegisterEffect(e2)
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_UPDATE_ATTACK)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
            e3:SetValue(math.ceil(atk/2))
            c:RegisterEffect(e3)
        end
    end
end
function c14801029.spr(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not (c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY)) then return end
    if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(14801029,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
    else
        e:SetLabel(0)
        c:RegisterFlagEffect(14801029,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
    end
end
function c14801029.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(14801029)>0
end
function c14801029.filter(c)
    return c:IsSetCard(0x4800)
end
function c14801029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:ResetFlagEffect(14801029)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801029.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c14801029.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
       if  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
           Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
           local c=e:GetHandler()
           local g=Duel.SelectMatchingCard(tp,c14801029.filter,tp,LOCATION_GRAVE,0,1,1,nil)
           local tc=g:GetFirst()
           if tc and (tc:IsAbleToHand() and Duel.SelectOption(tp,1190,aux.Stringid(14801029,2))==0) then
               Duel.SendtoHand(tc,nil,REASON_EFFECT)
               Duel.ConfirmCards(1-tp,tc)
           else
               Duel.Overlay(c,Group.FromCards(tc))
           end
       end
    end
end