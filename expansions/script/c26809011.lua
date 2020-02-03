--春诗映雪·诗岸
function c26809011.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCountLimit(1)
	e2:SetTarget(c26809011.indtg)
	e2:SetValue(c26809011.indval)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c26809011.splimita)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e6:SetValue(c26809011.splimitb)
	c:RegisterEffect(e6)
end
function c26809011.indtg(e,c)
	return c:IsCode(26806009) or (c:IsLocation(LOCATION_MZONE) and (c:IsAttack(2200) and c:IsDefense(600)) or (c:IsAttack(3200) and c:IsType(TYPE_LINK)))
end
function c26809011.indval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c26809011.splimita(e,c)
	if not c then return false end
	return not (c:IsAttack(2200) and c:IsDefense(600))
end
function c26809011.splimitb(e,c)
	if not c then return false end
	return not (c:IsAttack(3200) and c:IsType(TYPE_LINK))
end
