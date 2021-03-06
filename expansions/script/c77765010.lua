local m=77765010
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=true
function cm.initial_effect(c)
	local function transform_trigger_filter(c,tp)
		return c:GetSummonPlayer()==tp and c:GetSummonLocation()==LOCATION_EXTRA and c:IsControlerCanBeChanged() and c:IsLocation(LOCATION_MZONE)
	end
	Kaguya.ContinuousCommonEffect(c,EVENT_SPSUMMON_SUCCESS,function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(transform_trigger_filter,1,nil,tp)
	end,nil,nil,function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(transform_trigger_filter,nil,tp)
		return Duel.GetControl(g,1-tp)>0
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--[[e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(function(c)
			return c:IsFaceup() and not c:IsCode(77765001)
		end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(RACE_DRAGON)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end)]]
	c:RegisterEffect(e1)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
		return not c:IsCode(77765001)
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(cm.condition2)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
		e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_DAMAGE,0,1)
	end)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:IsCode(77765001) and a:IsRelateToBattle())
		or (d:IsCode(77765001) and d:IsRelateToBattle()))
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	--e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	if a:IsCode(77765001) then
		e1:SetValue(d:GetAttack())
		if d:IsCode(77765001) then
			local e2=e1:Clone()
			e2:SetValue(a:GetAttack())
			d:RegisterEffect(e2)
		end
		a:RegisterEffect(e1)
	elseif d:IsCode(77765001) then
		e1:SetValue(a:GetAttack())
		d:RegisterEffect(e1)
	end
end
