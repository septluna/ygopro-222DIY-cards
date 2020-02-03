--崩坏神格 亚巴顿·Live
function c75646262.initial_effect(c)
	aux.AddCodeList(c,75646154)
	c:EnableCounterPermit(0x1b)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c75646262.eqlimit)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetCondition(c75646262.atkcon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c75646262.con)
	e3:SetTarget(c75646262.tg)
	e3:SetOperation(c75646262.op)
	c:RegisterEffect(e3)   
	--back
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(c75646262.backon)
	e4:SetOperation(c75646262.backop)
	c:RegisterEffect(e4)
end
function c75646262.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646262.atkcon(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646262.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return (Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc)
		and e:GetHandler():GetCounter(0x1b)>0
end
function c75646262.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c75646262.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(75646262,0))
			e1:SetCategory(CATEGORY_DEFCHANGE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetCost(c75646262.efcost)
			e1:SetTarget(c75646262.eftg)
			e1:SetOperation(c75646262.efop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EVENT_CHAINING)
			e2:SetCondition(c75646262.efcon)
			sc:RegisterEffect(e2,true)
			if not sc:IsType(TYPE_EFFECT) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_ADD_TYPE)
				e3:SetValue(TYPE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e3,true)
			end
			--halve damage
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CHANGE_DAMAGE)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetRange(LOCATION_MZONE)
			e4:SetTargetRange(1,0)
			e4:SetValue(c75646262.val)
			sc:RegisterEffect(e4)
			sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75646262,1))
			sc=g:GetNext()
		end
	end
end
function c75646262.efcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and (re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND) 
end
function c75646262.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c75646262.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c75646262.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local predef=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if predef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c75646262.val(e,re,dam,r,rp,rc)
	return math.floor(dam*1.5)
end
function c75646262.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c75646262.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end