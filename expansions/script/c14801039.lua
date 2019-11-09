--灾厄魍魉 巴尔坦
function c14801039.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4800),4,2)
    c:EnableReviveLimit()
    --token
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetDescription(aux.Stringid(14801039,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCountLimit(1)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c14801039.spcost)
    e1:SetTarget(c14801039.sptg)
    e1:SetOperation(c14801039.spop)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetCondition(c14801039.indcon)
    e2:SetValue(aux.indoval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801039,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetCountLimit(1,14801039)
    e5:SetCondition(c14801039.spcon2)
    e5:SetTarget(c14801039.sptg2)
    e5:SetOperation(c14801039.spop2)
    c:RegisterEffect(e5)
end
function c14801039.indcon(e)
    return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c14801039.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,14801036,0,0x4011,1000,1000,3,RACE_FIEND,ATTRIBUTE_WIND) end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c14801039.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,14801036,0,0x4011,1000,1000,3,RACE_FIEND,ATTRIBUTE_WIND) then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
        local fid=e:GetHandler():GetFieldID()
        local g=Group.CreateGroup()
        for i=1,ft do
            local token=Duel.CreateToken(tp,14801036)
            Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
            token:RegisterFlagEffect(14801039,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
            g:AddCard(token)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UNRELEASABLE_SUM)
            e1:SetValue(1)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            token:RegisterEffect(e1,true)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
            token:RegisterEffect(e2,true)
            local e3=e2:Clone()
            e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
            token:RegisterEffect(e3,true)
        end
        Duel.SpecialSummonComplete()
        g:KeepAlive()
        local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EVENT_PHASE+PHASE_END)
        e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e4:SetReset(RESET_PHASE+PHASE_END)
        e4:SetCountLimit(1)
        e4:SetLabel(fid)
        e4:SetLabelObject(g)
        e4:SetCondition(c14801039.descon)
        e4:SetOperation(c14801039.desop)
        Duel.RegisterEffect(e4,tp)
end
function c14801039.desfilter(c,fid)
    return c:GetFlagEffectLabel(14801039)==fid
end
function c14801039.descon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g:IsExists(c14801039.desfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c14801039.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(c14801039.desfilter,nil,e:GetLabel())
    g:DeleteGroup()
    Duel.Destroy(tg,REASON_EFFECT)
end
function c14801039.spcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp))
        and c:IsPreviousPosition(POS_FACEUP)
end
function c14801039.spfilter2(c,e,tp)
    return c:IsSetCard(0x4800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801039.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801039.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14801039.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801039.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end