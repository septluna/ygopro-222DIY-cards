--幻世绘本录-柔情-
function c65020170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020170+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65020170.tg)
	e1:SetOperation(c65020170.op)
	c:RegisterEffect(e1)
	--gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c65020170.xmcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c65020170.xmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xcda8)
end

function c65020170.filter(c)
   return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xcda8) and c:GetOverlayCount()>0
end
function c65020170.filter1(c)
   return c:IsSetCard(0xcda8)  
end
function c65020170.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65020170.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020170.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SelectTarget(tp,c65020170.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65020170.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local og=Duel.GetOverlayGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if og:GetCount()>0 then
			local num=og:GetClassCount(Card.GetCode)
			local g=og:SelectSubGroup(tp,aux.dncheck,false,1,num)
			local dr=Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.Draw(tp,dr,REASON_EFFECT)
			--adjust
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c65020170.adjustop)
	Duel.RegisterEffect(e2,tp)
		end
	end
end
function c65020170.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65020170,0))
	   local g=g1:FilterSelect(tp,aux.TRUE,1,1,nil)
	   g1:RemoveCard(g:GetFirst())
		if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
		Duel.Readjust()
	end
	end

end