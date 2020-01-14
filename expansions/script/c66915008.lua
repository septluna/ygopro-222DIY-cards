--无垠的星空
local m=66915008
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1) 
    --move
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e11:SetRange(LOCATION_FZONE)
    e11:SetCountLimit(1)
    e11:SetTarget(cm.mvtg)
    e11:SetOperation(cm.mvop)
    c:RegisterEffect(e11)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.sumlimit)
    c:RegisterEffect(e2)      
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5)
        and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.filter(c)
    return (c:IsSetCard(0x374) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)) or c:IsCode(66915001) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerCanDiscardDeck(tp,5) then
        Duel.ConfirmDecktop(tp,5)
        local g=Duel.GetDecktopGroup(tp,5)
        if g:GetCount()>0 then
            if g:IsExists(cm.filter,1,nil) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local sg=g:FilterSelect(tp,cm.filter,1,1,nil)
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
                Duel.ShuffleHand(tp)
                g:Sub(sg)
                Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
            else
                Duel.ShuffleDeck(tp)
            end
        end
    end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end
function cm.filters(c)
    return c:IsSetCard(0x1374) and c:IsType(TYPE_MONSTER)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.filters,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
    Duel.SelectTarget(tp,cm.filters,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(tc,nseq)
end