--告白气球 鹿乃
function c75646426.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c75646426.matfilter,1,1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646426,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75646426)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c75646426.indcost)
	e1:SetTarget(c75646426.indtg)
	e1:SetOperation(c75646426.indop)
	c:RegisterEffect(e1)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c75646426.reccon)
	e3:SetOperation(c75646426.recop)
	c:RegisterEffect(e3)
end
function c75646426.matfilter(c)
	return c:IsLinkSetCard(0x32c4) and not c:IsLinkType(TYPE_LINK)
end
function c75646426.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646426.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c4)
end
function c75646426.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75646426.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646426.indfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c75646426.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c75646426.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c75646426.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c75646426.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c75646426.cfilter(c)
	return c:IsReason(REASON_COST)
end
function c75646426.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(0x7f0) and eg:IsExists(c75646426.cfilter,1,nil) and re:GetHandler():IsSetCard(0x32c4)
end
function c75646426.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,100,REASON_EFFECT)
end