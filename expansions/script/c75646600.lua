--创造之匙
function c75646600.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c75646600.condition)
	e1:SetTarget(c75646600.target)
	e1:SetOperation(c75646600.activate)
	c:RegisterEffect(e1)
end
function c75646600.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=500
end
function c75646600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c75646600.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>500 then return end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(75646600,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(c75646600.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c75646600.intg)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)  
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(c75646600.spintg)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	Duel.RegisterEffect(e5,tp)
	Duel.RegisterFlagEffect(tp,75646600,0,0,1)
end
function c75646600.intg(e,c)
	return c:IsSetCard(0x2c5)
end
function c75646600.effectfilter(e,ct)
	local p=e:GetOwner():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and aux.IsCodeListed(te:GetHandler(),75646600)
end
function c75646600.spintg(e,c)
	return aux.IsCodeListed(c,75646600)
end