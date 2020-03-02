--高达试作1号机 玉兰
function c47530165.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2)
    c:EnableReviveLimit()
    --Full Boost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47530165)
    e1:SetTarget(c47530165.desreptg)
    e1:SetOperation(c47530165.desrepop)
    c:RegisterEffect(e1)      
    --Gundam VS Gundam
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(1)
    e2:SetCondition(c47530165.actcon)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCondition(c47530165.atkcon)
    e3:SetOperation(c47530165.atkop)
    c:RegisterEffect(e3)    
    --sps voice
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetCondition(c47530165.spscon)
    e5:SetOperation(c47530165.spssuc)
    c:RegisterEffect(e5)
    --atk voice
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetCondition(c47530165.atkcon2)
    e6:SetOperation(c47530165.atksuc)
    c:RegisterEffect(e6)  
end
function c47530165.mfilter(c,xyzc)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(5)
end
function c47530165.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c47530165.actcon(e)
    local bc=e:GetHandler():GetBattleTarget()
    return bc and bc:IsSetCard(0x5d5) and bc:IsRace(RACE_MACHINE)
end
function c47530165.atkcon(e)
    local ph=Duel.GetCurrentPhase()
    local bc=e:GetHandler():GetBattleTarget()
    return bc and bc:IsRace(RACE_MACHINE)
end
function c47530165.atkop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
    e1:SetValue(math.ceil(a:GetAttack()/2))
    a:RegisterEffect(e1)
end
function c47530165.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        return true
    else return false end
end
function c47530165.spfilter(c,e,tp,mc)
    return c:IsSetCard(0x5d5) and mc:IsCanBeXyzMaterial(c) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c47530165.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_CARD,0,47530165)
    local g=Duel.SelectMatchingCard(tp,c47530165.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
    local tc=g:GetFirst()
    if tc then
        local mg=c:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(tc,mg)
        end
        tc:SetMaterial(Group.FromCards(c))
        Duel.Overlay(tc,Group.FromCards(c))
        Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c47530165.spscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47530165.spssuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47530165,0))
end
function c47530165.atkcon2(e)
    local bc=e:GetHandler():GetBattleTarget()
    return bc and bc:IsCode(47530163)
end
function c47530165.atksuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47530165,1))  
end