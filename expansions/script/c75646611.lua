--科学的原点 PAIN
function c75646611.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c75646611.handcon)
	c:RegisterEffect(e4)
	--cannot material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetTarget(c75646611.tg)
	e5:SetValue(1)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e8)
end
function c75646611.handcon(e)
	local f=Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)
	return f and f~=0
end
function c75646611.tg(e,c)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,75646600)>0 then
		return c:GetControler()==1-tp
	else return 1
	end
end







