--阿拉德武装备 贤者之杖
function c14801950.initial_effect(c)
    c:EnableCounterPermit(0x1)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c14801950.target)
    e1:SetOperation(c14801950.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c14801950.eqlimit)
    c:RegisterEffect(e2)
    --atk/def
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(c14801950.atkval)
    c:RegisterEffect(e3)
    --destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetTarget(c14801950.desreptg)
    e4:SetOperation(c14801950.desrepop)
    c:RegisterEffect(e4)
    --add counter
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_SZONE)
    e5:SetOperation(aux.chainreg)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e6:SetCode(EVENT_CHAIN_SOLVING)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetRange(LOCATION_SZONE)
    e6:SetOperation(c14801950.acop)
    c:RegisterEffect(e6)
    --token
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(14801950,0))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_LEAVE_FIELD)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCountLimit(1,14801950)
    e7:SetCondition(c14801950.spcon)
    e7:SetTarget(c14801950.sptg)
    e7:SetOperation(c14801950.spop)
    c:RegisterEffect(e7)
end
function c14801950.eqlimit(e,c)
    return c:IsSetCard(0x480e)
end
function c14801950.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x480e)
end
function c14801950.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c14801950.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801950.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c14801950.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c14801950.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c14801950.atkval(e,c)
    return e:GetHandler():GetCounter(0x1)*500
end
function c14801950.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tg=c:GetEquipTarget()
    if chk==0 then return not c:IsStatus(STATUS_DESTROY_CONFIRMED)
        and tg and tg:IsReason(REASON_BATTLE+REASON_EFFECT) and not tg:IsReason(REASON_REPLACE)
        and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_EFFECT) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function c14801950.desrepop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RemoveCounter(tp,1,0,0x1,1,REASON_EFFECT+REASON_REPLACE)
end
function c14801950.acop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
        e:GetHandler():AddCounter(0x1,1)
    end
end
function c14801950.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP)
end
function c14801950.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c14801950.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,14801885,0,0x4011,2000,2000,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
        local token=Duel.CreateToken(tp,14801885)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end