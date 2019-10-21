function c82221012.initial_effect(c)  
	--effect gain  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,82221012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c82221012.target)  
	e1:SetOperation(c82221012.activate)  
	c:RegisterEffect(e1)  
end
function c82221012.filter(c)  
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST) and c:IsType(TYPE_FUSION) 
end  
function c82221012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82221012.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82221012.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,c82221012.filter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c82221012.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_IMMUNE_EFFECT)  
		e1:SetValue(c82221012.efilter)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
		e2:SetValue(1)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)  
		tc:RegisterEffect(e2)  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_UPDATE_ATTACK)  
		e3:SetValue(2000)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)  
		tc:RegisterEffect(e3)  
	end  
end  
function c82221012.efilter(e,re)  
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()	
end  