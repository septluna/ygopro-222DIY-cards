--星月转夜 圣耀之星
function c65050224.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65050224.condition)
	e1:SetCost(c65050224.cost)
	e1:SetTarget(c65050224.target)
	e1:SetOperation(c65050224.operation)
	c:RegisterEffect(e1)
	--lvup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65050224.lvcon)
	e2:SetOperation(c65050224.lvop)
	c:RegisterEffect(e2)
	--RaiseEvent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEVEL_UP)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c65050224.raop)
	c:RegisterEffect(e3)
end
c65050224.material_type=TYPE_SYNCHRO
function c65050224.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c65050224.lvcfil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetLevel()>0 and c:GetPreviousControler()==1-tp
end
function c65050224.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050224.lvcfil,1,nil,tp)
end
function c65050224.lvofil(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c65050224.lvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c65050224.lvofil,tp,LOCATION_MZONE,0,nil)<=0 then return end
	local rlg=eg:Filter(c65050224.lvcfil,nil,tp)
	local rlv=0
	local rlc=rlg:GetFirst()
	while rlc do
		rlv=rlv+rlc:GetLevel()
		rlc=rlg:GetNext()
	end
	local lg=Duel.GetMatchingGroup(c65050224.lvofil,tp,LOCATION_MZONE,0,nil)
	while rlv>0 do
		local lcg=lg:FilterSelect(tp,aux.TRUE,1,1,nil)
		Duel.HintSelection(lcg)
		local lc=lcg:GetFirst()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(-1)
		lc:RegisterEffect(e2)
		rlv=rlv-1
	end
end

function c65050224.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rc:GetLevel()>0 and ep~=tp
end
function c65050224.lvfil(c)
	return c:IsFaceup() and c:GetLevel()>1
end
function c65050224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Duel.GetMatchingGroup(c65050224.lvfil,tp,LOCATION_MZONE,0,nil)
	local lv=0
	local lc=lg:GetFirst()
	while lc do
		lv=lv+(lc:GetLevel()-1)
		lc=lg:GetNext()
	end
	local rc=re:GetHandler()
	local rlv=rc:GetLevel()
	if chk==0 then return lv>=rlv end
	while rlv>0 do
		lg=Duel.GetMatchingGroup(c65050224.lvfil,tp,LOCATION_MZONE,0,nil)
		local lcg=lg:FilterSelect(tp,aux.TRUE,1,1,nil)
		Duel.HintSelection(lcg)
		lc=lcg:GetFirst()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(-1)
		lc:RegisterEffect(e2)
		rlv=rlv-1
	end
end
function c65050224.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65050224.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end