function c82224006.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,nil,9,2)  
	c:EnableReviveLimit()  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(c82224006.indtg)  
	e1:SetValue(aux.indoval)  
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)   
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(c82224006.indtg)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2) 
end  
function c82224006.indtg(e,c)  
	return c:IsType(TYPE_MONSTER)
end  