--风炎使·芙蕾雅
function c10969997.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10969997,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10969997.descon)
	e1:SetTarget(c10969997.destg)
	e1:SetOperation(c10969997.desop)
	c:RegisterEffect(e1)	  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10969997,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10969997)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c10969997.tg)
	e3:SetOperation(c10969997.op)
	c:RegisterEffect(e3)
end
function c10969997.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c10969997.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	if ct1>ct2 then
		if ct2==0 then 
		local ct1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,ct1,ct1:GetCount(),0,0)
			else 
			local ct2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,ct2,ct2:GetCount(),0,0)
		end
		else if ct1==0 then
		local ct2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,ct2,ct2:GetCount(),0,0)
			else
			local ct1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,ct1,ct1:GetCount(),0,0)
		end
	end
end
function c10969997.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)
	if ct1==ct2 then return false end
	if ct1>ct2 then
		if ct2==0 then 
		local ct1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SendtoDeck(ct1,nil,2,REASON_EFFECT)
			else 
			local ct2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
			Duel.SendtoDeck(ct2,nil,2,REASON_EFFECT)
		end
		else if ct1==0 then 
		local ct2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
		Duel.SendtoDeck(ct2,nil,2,REASON_EFFECT)
			else 
			local ct1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			Duel.SendtoDeck(ct1,nil,2,REASON_EFFECT)
		end
	end
end
function c10969997.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if Duel.GetTurnPlayer()==tp then
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) 
	else local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0) end
end
function c10969997.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetControler()==tp then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else Duel.Destroy(tc,REASON_EFFECT) end
end