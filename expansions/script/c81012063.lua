--特别礼物·爱米莉
function c81012063.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81012063.matfilter,4,4)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c81012063.tgcon)
	e0:SetValue(c81012063.efilter)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81012063.regcon)
	e1:SetOperation(c81012063.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c81012063.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=aux.AddRitualProcGreater2(c,c81012063.filter,LOCATION_DECK)
	e3:SetDescription(aux.Stringid(81012063,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetCountLimit(1,81012063)
	e3:SetRange(LOCATION_MZONE)
	--cannot be link material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81012063,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMING_DRAW_PHASE)
	e6:SetCountLimit(1,81012963)
	e6:SetCost(c81012063.actcost)
	e6:SetOperation(c81012063.actop)
	c:RegisterEffect(e6)
end
function c81012063.matfilter(c)
	return c:IsLinkRace(RACE_PYRO) and c:IsLinkType(TYPE_PENDULUM) and c:IsLevelAbove(8)
end
function c81012063.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c81012063.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(81012063,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81012063,2))
end
function c81012063.valfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81012063.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c81012063.valfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c81012063.tgcon(e)
	return e:GetHandler():GetFlagEffect(81012063)>0
end
function c81012063.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c81012063.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_PYRO)
end
function c81012063.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81012063.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c81012063.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c81012063.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c81012063.actop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c81012063.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81012063.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return (loc==LOCATION_SZONE and not re:IsHasType(EFFECT_TYPE_ACTIVATE)) or (loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER))
end
