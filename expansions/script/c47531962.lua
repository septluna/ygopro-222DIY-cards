--独角兽高达2号机 报丧女妖（NT-D）
local m=47531962
local cm=_G["c"..m]
function c47531962.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c47531962.efilter)
    c:RegisterEffect(e1)
    --Armed Arm VN
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c47531962.vntg)
    e1:SetOperation(c47531962.vnop)
    c:RegisterEffect(e1)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_UNRELEASABLE_SUM)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e7:SetValue(c47531962.fuslimit)
    c:RegisterEffect(e7)
    local e8=e5:Clone()
    e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e8)
    local e9=e5:Clone()
    e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    c:RegisterEffect(e9) 
    local e10=e5:Clone()
    e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e10)    
end
function c47531962.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER)
end
function c47531962.fuslimit(e,c,sumtype)
    return sumtype==SUMMON_TYPE_FUSION
end
function c47531962.vntg(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup():Filter(aux.TRUE,nil)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil,e,tp,lg) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,lg,lg:GetCount(),0,0)
end
function c47531962.cfilter(c,g)
    return g:IsContains(c)
end
function c47531962.vnop(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup():Filter(aux.TRUE,nil)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<lg:GetCount() then return end
    local c=e:GetHandler()
    local tc=sg:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,false,true)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c47531962.eqlimit)
        tc:RegisterEffect(e1)
        tc:RegisterFlagEffect(47531962,RESET_EVENT+RESETS_STANDARD,0,1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetCountLimit(1)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetLabelObject(tc)
        e2:SetCondition(c47531962.descon)
        e2:SetOperation(c47531962.desop)
        Duel.RegisterEffect(e2,tp)
        tc=sg:GetNext()
    end
    Duel.EquipComplete()
end
function c47531962.eqlimit(e,c)
    return e:GetOwner()==c
end
function c47531962.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(47531962)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function c47531962.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    local atk=tc:GetBaseAttack()
    Duel.Destroy(tc,REASON_EFFECT)
    Duel.Damage(atk/2,1-tp,REASON_EFFECT)
end