--科学的原点 SMILE
function c75646614.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75646614.target)
	e1:SetOperation(c75646614.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1833916,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,75646614)
	e2:SetTarget(c75646614.tg)
	e2:SetOperation(c75646614.op)
	c:RegisterEffect(e2)
end
function c75646614.filter(c,e,tp)
	return c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646614.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646614.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c75646614.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75646614.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 
			and Duel.GetFlagEffect(tp,75646600)~=0 then
			Duel.Recover(tp,g:GetFirst():GetDefense(),REASON_EFFECT)
		end
	end
end
function c75646614.tdfilter(c)
	return aux.IsCodeListed(c,75646600) and c:IsAbleToDeck()
end
function c75646614.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75646614.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646614.tdfilter,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c75646614.tdfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c75646614.tgfilter(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_MONSTER) 
		and c:IsAbleToGrave()
end
function c75646614.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	 local sg=Duel.GetMatchingGroup(c75646614.tgfilter,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local rg=Group.FromCards(c,tc)
		if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)>0 and (tc:IsCode(75646600) or Duel.GetFlagEffect(tp,75646600)>0) and Duel.SelectYesNo(tp,aux.Stringid(75646614,2)) and sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=sg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end