--哈奈鲁的秋日之约
function c81010034.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81010034.target)
	e1:SetOperation(c81010034.activate)
	c:RegisterEffect(e1)
end
function c81010034.cfilter1(c,tp)
	return c:IsCode(81010011,81010016,81040035) and not c:IsForbidden() and ((c:CheckUniqueOnField(tp)
		and Duel.IsExistingMatchingCard(c81010034.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,1-tp))
		or (c:CheckUniqueOnField(1-tp)
		and Duel.IsExistingMatchingCard(c81010034.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,tp)))
end
function c81010034.cfilter2(c,p)
	return c:IsCode(81010011,81010016,81040035) and c:CheckUniqueOnField(p) and not c:IsForbidden()
end
function c81010034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010034.cfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c81010034.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c81010034.cfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	local b1=g1:IsExists(Card.CheckUniqueOnField,1,nil,tp)
	local b2=g1:IsExists(Card.CheckUniqueOnField,1,nil,1-tp)
	if not b1 and not b2 then return end
	local g2=Duel.GetMatchingGroup(c81010034.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	local g3=Duel.GetMatchingGroup(c81010034.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,1-tp)
	local tg1=nil
	local tg2=nil
	if b1 and not b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010034,0))
		tg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010034,1))
		tg2=g3:Select(tp,1,1,nil)
	end
	if not b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010034,0))
		tg1=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010034,1))
		tg2=g1:Select(tp,1,1,nil)
	end
	if b1 and b2 then
		local g=g1:Clone()
		g:Merge(g2)
		g:Merge(g3)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010034,0))
		tg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010034,1))
		tg2=g:Select(tp,1,1,nil)
	end
	Duel.MoveToField(tg1:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.MoveToField(tg2:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
end
