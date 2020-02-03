--纯粹的试炼之光
function c75646266.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646266,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75646266)
	e1:SetCondition(c75646266.con)
	e1:SetTarget(c75646266.tg)
	e1:SetOperation(c75646266.op)
	c:RegisterEffect(e1)
end
function c75646266.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(TYPE_SPELL) and re:IsActiveType(TYPE_EQUIP)
		and re:GetHandler():IsSetCard(0x2c0)
end
function c75646266.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75646266.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end