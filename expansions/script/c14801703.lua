--武装神姬 歌姬型
function c14801703.initial_effect(c)
    --fusion summon
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_UNION),2,true)
    --spsummon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(c14801703.splimits)
    c:RegisterEffect(e0)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801703,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c14801703.eqtg)
    e1:SetOperation(c14801703.eqop)
    c:RegisterEffect(e1)
    --unequip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801703,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c14801703.sptg)
    e2:SetOperation(c14801703.spop)
    c:RegisterEffect(e2)
    --destroy sub
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e3:SetValue(c14801703.repval)
    c:RegisterEffect(e3)
    --eqlimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c14801703.eqlimit)
    c:RegisterEffect(e4)
    --Atk up
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(1000)
    c:RegisterEffect(e5)
    --Def up
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    e6:SetValue(1000)
    c:RegisterEffect(e6)
    --
        local e7=Effect.CreateEffect(c)
        e7:SetDescription(aux.Stringid(14801703,2))
        e7:SetCategory(CATEGORY_EQUIP)
        e7:SetType(EFFECT_TYPE_IGNITION)
        e7:SetRange(LOCATION_MZONE)
        e7:SetCountLimit(1)
        e7:SetTarget(c14801703.eqtg1)
        e7:SetOperation(c14801703.eqop1)
        local e10=Effect.CreateEffect(c)
        e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
        e10:SetRange(LOCATION_SZONE)
        e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e10:SetTarget(c14801703.eftg)
        e10:SetLabelObject(e7)
        c:RegisterEffect(e10)
    --special summon rule
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_SPSUMMON_PROC)
    e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e8:SetRange(LOCATION_EXTRA)
    e8:SetCondition(c14801703.spcons)
    e8:SetOperation(c14801703.spops)
    c:RegisterEffect(e8)
    --to hand
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(14801703,3))
    e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e9:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_DELAY)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetCountLimit(1,14801703)
    e9:SetTarget(c14801703.thtg)
    e9:SetOperation(c14801703.thop)
    c:RegisterEffect(e9)
end
function c14801703.splimits(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c14801703.spfilters(c)
    return c:IsFusionType(TYPE_UNION) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c14801703.fselect(c,tp,mg,sg)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<2 then
        res=mg:IsExists(c14801703.fselect,1,sg,tp,mg,sg)
    else
        res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
    end
    sg:RemoveCard(c)
    return res
end
function c14801703.spcons(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c14801703.spfilters,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    return mg:IsExists(c14801703.fselect,1,nil,tp,mg,sg)
end
function c14801703.spops(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c14801703.spfilters,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    while sg:GetCount()<2 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=mg:FilterSelect(tp,c14801703.fselect,1,1,sg,tp,mg,sg)
        sg:Merge(g)
    end
    local cg=sg:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.SendtoGrave(sg,nil,2,REASON_COST)
end
function c14801703.filter(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:IsType(TYPE_UNION) and ct2==0
end
function c14801703.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801703.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(14801703)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c14801703.filter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c14801703.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(14801703,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801703.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c14801703.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function c14801703.eftg(e,c)
    return e:GetHandler():GetEquipTarget()==c
end
function c14801703.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(14801703)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(14801703,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c14801703.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c14801703.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c14801703.eqlimit(e,c)
    return c:IsType(TYPE_MONSTER) or e:GetHandler():GetEquipTarget()==c
end
function c14801703.filter1(c)
    return c:IsType(TYPE_UNION) and not c:IsForbidden()
end
function c14801703.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c14801703.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c14801703.eqop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c14801703.filter1),tp,LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c14801703.eqlimit1)
        tc:RegisterEffect(e1)
    end
end
function c14801703.eqlimit1(e,c)
    return e:GetOwner()==c
end
function c14801703.thfilter(c)
    return c:IsSetCard(0x480c) and c:IsAbleToHand()
end
function c14801703.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801703.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801703.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801703.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end