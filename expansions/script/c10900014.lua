--I
function c10900014.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DISCARD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10900014.con)
	e1:SetOperation(c10900014.op)
	c:RegisterEffect(e1)
	--dis
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10900014,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,10900014)
	e2:SetTarget(c10900014.distg)
	e2:SetOperation(c10900014.disop)
	c:RegisterEffect(e2)
end
function c10900014.filter(c,tp)
	return c:GetOwner()==tp
end
function c10900014.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c10900014.filter,nil,tp)>0
end
function c10900014.op(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c10900014.filter,nil,tp)>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(e:GetHandler():GetAttack()*2)
	e1:SetReset(RESET_EVENT+0xff0000)
	e:GetHandler():RegisterEffect(e1) 
	end
end
function c10900014.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD)  and chkc:IsFaceup()  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c10900014.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and c:IsFaceup() and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e)  then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c10900014.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone() 
		c:RegisterEffect(e2)
	end
end
function c10900014.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
