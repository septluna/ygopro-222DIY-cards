local m=82207001
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),11,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)  
	c:EnableReviveLimit()
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e3:SetValue(1)  
	c:RegisterEffect(e3) 
	--pos  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_SET_POSITION)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e4:SetCondition(cm.poscon)  
	e4:SetTarget(cm.postg)  
	e4:SetValue(POS_FACEUP_DEFENSE)  
	c:RegisterEffect(e4)  
end
function cm.cfilter(c)  
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToRemoveAsCost()  
end  
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsCode(82207000)  
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,82207001)==0 end  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,82207001,RESET_PHASE+PHASE_END,0,1)  
end  
function cm.poscon(e)  
	return e:GetHandler():IsDefensePos()  
end  
function cm.postg(e,c)  
	return c:IsFaceup()  
end  