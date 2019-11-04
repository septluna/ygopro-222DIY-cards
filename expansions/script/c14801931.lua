--阿拉德武装备 月光之刃
function c14801931.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c14801931.target)
    e1:SetOperation(c14801931.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c14801931.eqlimit)
    c:RegisterEffect(e2)
    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801904,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c14801931.ctcon1)
    e3:SetOperation(c14801931.atkop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --counter2
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_SZONE)
    e5:SetOperation(aux.chainreg)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_CHAIN_SOLVED)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCondition(c14801931.ctcon2)
    e6:SetOperation(c14801931.atkop)
    c:RegisterEffect(e6)
    --token
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(14801931,0))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_LEAVE_FIELD)
    e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e7:SetCountLimit(1,14801931)
    e7:SetCondition(c14801931.spcon)
    e7:SetTarget(c14801931.sptg)
    e7:SetOperation(c14801931.spop)
    c:RegisterEffect(e7)
end
function c14801931.eqlimit(e,c)
    return c:IsSetCard(0x480e)
end
function c14801931.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x480e)
end
function c14801931.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c14801931.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801931.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c14801931.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c14801931.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c14801931.cfilter(c,tp)
    return c:GetSummonPlayer()==tp
end
function c14801931.ctcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipTarget() and eg:IsExists(c14801931.cfilter,1,nil,1-tp)
end
function c14801931.ctcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipTarget() and ep~=tp and e:GetHandler():GetFlagEffect(1)>0
end
function c14801931.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup()  then
        Duel.Hint(HINT_CARD,0,14801931)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_EQUIP)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(500)
        c:RegisterEffect(e1)
    end
end
function c14801931.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c14801931.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c14801931.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,14801867,0,0x4011,2000,2000,4,RACE_WARRIOR,ATTRIBUTE_WATER) then
        local token=Duel.CreateToken(tp,14801867)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end