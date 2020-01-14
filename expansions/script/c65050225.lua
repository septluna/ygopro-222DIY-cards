--星月转夜 统括之星
function c65050225.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c65050225.immval)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65050225.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c65050225.discon)
	e3:SetOperation(c65050225.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c65050225.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_SET_ATTACK)
	e8:SetValue(0)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e9)
	--RaiseEvent
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEVEL_UP)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c65050225.raop)
	c:RegisterEffect(e0)
end
c65050225.material_type=TYPE_SYNCHRO
function c65050225.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c65050225.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5da9) and c:IsControler(tp)
end
function c65050225.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	local b=Duel.GetAttacker()
	if not c then return false end
	if c:IsControler(1-tp) then 
		c=Duel.GetAttacker() 
		b=Duel.GetAttackTarget()
	end
	local clv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then clv=c:GetRank() end
	local blv=b:GetLevel()
	if b:IsType(TYPE_XYZ) then blv=b:GetRank() end
	return c and c65050225.cfilter(c,tp) and clv>blv and clv>0 and blv>0
end
function c65050225.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	tc:RegisterFlagEffect(65050225,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c65050225.distg(e,c)
	return c:GetFlagEffect(65050225)~=0
end

function c65050225.eftg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x5da9) and c:IsType(TYPE_EFFECT)
end
function c65050225.immval(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:GetHandlerPlayer()~=e:GetHandlerPlayer() then
		local lv=e:GetHandler():GetLevel()
		if e:GetHandler():IsType(TYPE_XYZ) then lv=e:GetHandler():GetRank() end
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK) then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<=lv
		else
			return ec:GetOriginalLevel()<=lv
		end
	else
		return false
	end
end