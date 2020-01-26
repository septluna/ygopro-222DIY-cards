--渺奏迷景曲-沙漏过指
function c65072023.initial_effect(c)
	aux.AddCodeList(c,65072016)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072023+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65072023.cost)
	e1:SetTarget(c65072023.target)
	e1:SetOperation(c65072023.activate)
	c:RegisterEffect(e1)
end
function c65072023.costfil(c)
	return aux.IsCodeListed(c,65072016) and c:IsAbleToRemoveAsCost()
end
function c65072023.thfil(c)
	return c:IsSetCard(0xcda7) and c:IsAbleToHand()
end
function c65072023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072023.costfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c65072016.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65072023,0))
	local num1=Duel.GetMatchingGroup(c65072023.costfil,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	local num2=Duel.GetMatchingGroupCount(c65072023.thfil,tp,LOCATION_DECK,0,nil)
	if num1>num2 then num1=num2 end
	local g=Duel.GetMatchingGroup(c65072023.costfil,tp,LOCATION_GRAVE,0,nil):SelectSubGroup(tp,aux.dncheck,false,1,num1)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c65072023.filter(c)
	return c:IsSetCard(0xcda7) and c:IsAbleToHand()
end
function c65072023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function c65072023.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65072023.thfil,tp,LOCATION_DECK,0,num,num,nil)
	if g:GetCount()==num then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
