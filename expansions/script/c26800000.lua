--Used By Amana
Amana=Amana or {}
--Mogami Shizuka, 81018xxx, 0x81b
function Amana.AttackBelow(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_ATTACK)
	e0:SetCondition(Amana.atcon)
	c:RegisterEffect(e0)
end
function Amana.atcon(e)
	return e:GetHandler():GetAttack()>=2000
end
--majsoul
function Amana.Majsoul(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	aux.AddCodeList(c,26818000,26818001)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_SELF_TOGRAVE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(Amana.tgcon)
	c:RegisterEffect(e0)
end
function Amana.cfilter(c)
	return c:IsFaceup() and c:IsCode(26818000,26818001)
end
function Amana.tgcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_END
		and not Duel.IsExistingMatchingCard(Amana.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--momoka
function Amana.Momoka(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,m+900)
	e0:SetValue(Amana.matval)
	c:RegisterEffect(e0)
end
function Amana.mfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function Amana.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(m)
end
function Amana.matval(e,c,mg)
	return c:IsSetCard(0x3603) and mg:IsExists(Amana.mfilter,1,nil) and not mg:IsExists(Amana.exmfilter,1,nil)
end
--majsoulGirl/Boy
function Amana.MajsoulGirl(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(Amana.namecon)
	e0:SetValue(26818000)
	c:RegisterEffect(e0)
end
function Amana.MajsoulBoy(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(Amana.namecon)
	e0:SetValue(26818001)
	c:RegisterEffect(e0)
end
function Amana.namecon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_END
end
