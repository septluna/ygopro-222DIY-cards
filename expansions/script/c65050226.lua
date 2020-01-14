--星月转夜 噩兆之月
function c65050226.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5da9),4,2)
	c:EnableReviveLimit()
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65050226)
	e1:SetCost(c65050226.cost)
	e1:SetTarget(c65050226.target)
	e1:SetOperation(c65050226.operation)
	c:RegisterEffect(e1)
end
function c65050226.clvfil(c)
	return c:IsFaceup() and c:IsLevelAbove(2)
end
function c65050226.lvfil(c)
	return c:IsFaceup() and c:IsLevelAbove(3)
end
function c65050226.costfil(c)
	return Duel.IsExistingMatchingCard(c65050226.thfil,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and c:IsSetCard(0x5da9) and c:IsAbleToHand()
end
function c65050226.ccostfil(c)
	return c:IsSetCard(0x5da9) and c:IsAbleToHand()
end
function c65050226.thfil(c,code)
	return c:IsSetCard(0x5da9) and c:IsAbleToHand() and not c:IsCode(code)
end
function c65050226.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 local b1=Duel.IsExistingMatchingCard(c65050226.costfil,tp,LOCATION_DECK,0,1,nil)
	local b01=Duel.IsExistingMatchingCard(c65050226.ccostfil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65050226.lvfil,tp,LOCATION_MZONE,0,1,nil)
	local b02=Duel.IsExistingMatchingCard(c65050226.clvfil,tp,LOCATION_MZONE,0,1,nil)
	local b3=e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
	local b03=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	if chk==0 then return b01 and b02 and b03 end
	local announce=0
	if b1 and b2 and b3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65050226,0))
		announce=Duel.AnnounceNumber(tp,1,2)
	else
		announce=1
	end
	e:GetHandler():RemoveOverlayCard(tp,announce,announce,REASON_COST)
	e:SetLabel(announce)
end
function c65050226.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=e:GetLabel()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,num,tp,LOCATION_DECK)
end
function c65050226.operation(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	local lab1=Duel.IsExistingMatchingCard(c65050226.lvfil,tp,LOCATION_MZONE,0,1,nil)
	local mg=Duel.GetMatchingGroup(c65050226.clvfil,tp,LOCATION_MZONE,0,nil)
	if mg:GetCount()>0 then
	local gc=mg:GetFirst()
	while gc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(0-num)
		gc:RegisterEffect(e2)
		gc=mg:GetNext()
	end
	if not lab1 then num=1 end
	 local og=Duel.GetMatchingGroup(c65050226.ccostfil,tp,LOCATION_DECK,0,nil)
	local g=og:SelectSubGroup(tp,aux.dncheck,false,num,num)
	if g:GetCount()==num then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
end
