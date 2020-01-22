--康娜卡姆依
require("expansions/script/c81000000")
function c81014004.initial_effect(c)
	Tenka.MaidDragon(c)
	--cannot trigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c81014004.distg)
	c:RegisterEffect(e3)
end
function c81014004.distg(e,c)
	return c:IsFacedown()
end
