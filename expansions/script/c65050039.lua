--花物语-花映华阳-
function c65050039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050039)
	e1:SetTarget(c65050039.target)
	e1:SetOperation(c65050039.activate)
	c:RegisterEffect(e1)
end
function c65050039.filter1(c)
	return c:IsSetCard(0x6da7) and c:IsAbleToDeck()
end
function c65050039.filter2(c)
	return c:IsSetCard(0x6da7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65050039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(c65050039.filter1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65050039.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local m=2
	if b1 and b2 then
		m=Duel.SelectOption(tp,aux.Stringid(65050039,0),aux.Stringid(65050039,1))
	elseif b1 then
		m=0
	elseif b2 then
		m=1
	end
	e:SetLabel(m)
	if m==0 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c65050039.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	elseif m==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c65050039.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	if m==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			if tc:IsType(TYPE_MONSTER) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(65050039,2)) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			else
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		end
	elseif m==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c65050039.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end