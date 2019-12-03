local m=82207003
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),11,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)  
	c:EnableReviveLimit() 
	--atk up  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_ATKCHANGE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(cm.atkcon)  
	e1:SetTarget(cm.atktg)  
	e1:SetOperation(cm.atkop)  
	c:RegisterEffect(e1)
end
function cm.cfilter(c)  
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToRemoveAsCost()  
end  
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsCode(82207000)  
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,82207003)==0 end  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,82207003,RESET_PHASE+PHASE_END,0,1)  
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)  
end  
function cm.atkfilter(c)  
	return c:IsFaceup()  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,0,LOCATION_MZONE,1,nil) end  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)  
	local tc=g:GetFirst()  
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() then  
		local atk=tc:GetAttack()  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(atk)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_EXTRA_ATTACK)  
		e2:SetValue(1)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e2)   
	end  
end  