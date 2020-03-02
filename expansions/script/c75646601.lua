--博士 伊瑟琳
function c75646601.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,75646601)
	e1:SetTarget(c75646601.thtg)
	e1:SetOperation(c75646601.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646008,0))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c75646601.recost)
	e3:SetTarget(c75646601.retg)
	e3:SetOperation(c75646601.reop)
	c:RegisterEffect(e3)
end
function c75646601.thfilter(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75646601.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646601.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646601.spfilter(c,e,tp)
	return aux.IsCodeListed(c,75646600) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646601.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c75646601.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.GetFlagEffect(tp,75646600)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75646601,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75646601.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c75646601.cfilter1(c,e,tp)
	if c:IsLocation(LOCATION_HAND) then return c==e:GetHandler() and c:IsDiscardable() end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp)
end
function c75646601.cfilter2(c,tp)
	if c:IsLocation(LOCATION_HAND) then return aux.IsCodeListed(c,75646600) and c:IsDiscardable() end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp)
end
function c75646601.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75646601.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return g and Duel.IsExistingMatchingCard(c75646601.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,g:GetFirst(),tp) end
	local g1=Duel.GetMatchingGroup(c75646601.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	if not g1:IsExists(Card.IsHasEffect,1,nil,75646628,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=g1:Select(tp,1,1,c)		
		if dg:GetFirst():IsCode(75646600) then e:SetLabel(1) end
		dg:AddCard(c)
		Duel.SendtoGrave(dg,REASON_DISCARD+REASON_COST)
	else			
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local dc=Duel.SelectMatchingCard(tp,c75646601.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		local dg=Duel.SelectMatchingCard(tp,c75646601.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,dc,tp)
		dg:AddCard(dc)
		local tc=dg:GetFirst()
		while tc do
			local te=tc:IsHasEffect(75646628,tp)
			if te then
				e:SetLabel(1)
				Duel.Remove(tc,POS_FACEUP,REASON_COST)
			else
				if tc:IsCode(75646600) then e:SetLabel(1) end
				Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
			end
		tc=dg:GetNext()
		end 
	end
end
function c75646601.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c75646601.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)~=0) and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(75646601,3)) then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end