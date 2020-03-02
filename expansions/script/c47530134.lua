--龟霸（雷霆宙域）
function c47530134.initial_effect(c)
    --synchro level
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
    e1:SetTarget(c47530134.syntg)
    e1:SetValue(1)
    e1:SetOperation(c47530134.synop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(89818984)
    e2:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e2)    
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCountLimit(1,47530134)
    e3:SetCondition(c47530134.xyzcon)
    e3:SetTarget(c47530134.xyztg)
    e3:SetOperation(c47530134.xyzop)
    c:RegisterEffect(e3)
end
function c47530134.cardiansynlevel(c)
    return 4
end
function c47530134.synfilter(c,syncard,tuner,f)
    return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c47530134.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
    g:AddCard(c)
    local ct=g:GetCount()
    local res=c47530134.syngoal(g,tp,lv,syncard,minc,ct)
        or (ct<maxc and mg:IsExists(c47530134.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
    g:RemoveCard(c)
    return res
end
function c47530134.syngoal(g,tp,lv,syncard,minc,ct)
    return ct>=minc and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
        and (g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
            or g:CheckWithSumEqual(c47530134.cardiansynlevel,lv,ct,ct,syncard))
end
function c47530134.syntg(e,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local tp=syncard:GetControler()
    local lv=syncard:GetLevel()
    if lv<=c:GetLevel() and lv<=c47530134.cardiansynlevel(c) then return false end
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c47530134.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    return mg:IsExists(c47530134.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c47530134.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local lv=syncard:GetLevel()
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c47530134.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    for i=1,maxc do
        local cg=mg:Filter(c47530134.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
        if cg:GetCount()==0 then break end
        local minct=1
        if c47530134.syngoal(g,tp,lv,syncard,minc,i) then
            minct=0
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local sg=cg:Select(tp,minct,1,nil)
        if sg:GetCount()==0 then break end
        g:Merge(sg)
    end
    Duel.SetSynchroMaterial(g)
end
function c47530134.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c47530134.xyzfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(5) and Duel.IsExistingMatchingCard(c47530134.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c47530134.spfilter(c,e,tp,lv)
    return c:IsRank(lv) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c47530134.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47530134.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c47530134.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47530134.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local mg=Group.FromCards(c,tc) 
    local lv=tc:GetLevel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530134.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
    local hc=g:GetFirst()
    if hc then
        Duel.SpecialSummon(hc,0,tp,tp,false,false,POS_FACEUP)
    end  
    Duel.Overlay(hc,mg)
end