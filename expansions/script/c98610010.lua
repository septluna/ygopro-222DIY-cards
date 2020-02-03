--少女分形·萤火之幻
function c98610010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98610010,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c98610010.target)
	e1:SetOperation(c98610010.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98610010,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98610010)
	e2:SetCondition(c98610010.tpcon)
	e2:SetTarget(c98610010.tptg)
	e2:SetOperation(c98610010.tpop)
	c:RegisterEffect(e2)
end
function c98610010.filter(c)
	return c:IsSetCard(0x980) and c:IsAbleToRemove()
end
function c98610010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil,REASON_EFFECT)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,0,0)
end
function c98610010.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then 
		    local g1=g:Filter(c98610010.filter,nil)
			if g1:GetCount()>0 then
				Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
                Duel.ShuffleDeck(tp)	
			else
				Duel.DisableShuffleCheck()
			end
		end
	end
end
function c98610010.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)and re and re:GetHandler():IsSetCard(0x980)
end
function c98610010.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rg1=Duel.GetDecktopGroup(tp,5)
	local rg2=Duel.GetDecktopGroup(1-tp,5)
    if chk==0 then return rg1:FilterCount(Card.IsAbleToRemove,nil)==5 and rg2:FilterCount(Card.IsAbleToRemove,nil)==5 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,0,PLAYER_ALL,5)
end
function c98610010.tpop(e,tp,eg,ep,ev,re,r,rp)
    local rg1=Duel.GetDecktopGroup(tp,5)
	local rg2=Duel.GetDecktopGroup(1-tp,5)
	if rg1:GetCount()<=0 and rg2:GetCount()<=0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)
	Duel.Remove(rg2,POS_FACEUP,REASON_EFFECT)
end