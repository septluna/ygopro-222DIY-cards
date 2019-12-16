--土著神的顶点
function c11200047.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,c11200047.ovfilter,aux.Stringid(11200047,0),2,c11200047.xyzop)
	c:EnableReviveLimit()
	--atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c11200047.atkval)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11200047)
	e1:SetCondition(c11200047.thcon)
	e1:SetTarget(c11200047.thtg)
	e1:SetOperation(c11200047.thop)
	c:RegisterEffect(e1)
end
function c11200047.ovfilter(c)
	return c:IsFaceup() and c:IsCode(11200029)
end
function c11200047.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11200047)==0 end
	Duel.RegisterFlagEffect(tp,11200047,RESET_PHASE+PHASE_END,0,1)
end
function c11200047.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c11200047.dtfilter(c)
	return c:IsRace(RACE_AQUA) and c:IsType(TYPE_XYZ)
end
function c11200047.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c11200047.dtfilter,1,nil)
end
function c11200047.filter(c)
	return c:IsRace(RACE_AQUA) and c:IsRank(2) and c:IsType(TYPE_XYZ) and not c:IsCode(11200047) and c:IsAbleToGrave()
end
function c11200047.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c11200047.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c11200047.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11200047.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetCode()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetValue(code)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
end
