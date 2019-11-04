--创世神 卡罗索 毁灭模式
function c14801914.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,12,3,c14801914.ovfilter,aux.Stringid(14801914,0),3,c14801914.xyzop)
    c:EnableReviveLimit()
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c14801914.efilter)
    c:RegisterEffect(e3)
    --to grave
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801914,1))
    e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c14801914.sgcost)
    e4:SetTarget(c14801914.sgtg)
    e4:SetOperation(c14801914.sgop)
    c:RegisterEffect(e4)
end
function c14801914.ovfilter(c)
    return c:IsFaceup() and c:IsCode(14801913)
end
function c14801914.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,14801914)==0 end
    Duel.RegisterFlagEffect(tp,14801914,RESET_PHASE+PHASE_END,0,1)
end
function c14801914.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c14801914.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801914.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*600)
end
function c14801914.sgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,aux.ExceptThisCard(e))
    if g:GetCount()==0 then return end
    Duel.SendtoGrave(g,nil,REASON_EFFECT)
    local og=Duel.GetOperatedGroup()
    local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
    Duel.Damage(1-tp,ct*600,REASON_EFFECT)
end