--破土种光的生命树
function c65071158.initial_effect(c)
	--atc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cont
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c65071158.acop)
	c:RegisterEffect(e2)
	--ef
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65071158,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c65071158.scon)
	e3:SetCost(c65071158.scost)
	e3:SetOperation(c65071158.sop)
	c:RegisterEffect(e3)
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65071158,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c65071158.con)
	e4:SetCost(c65071158.cost)
	e4:SetTarget(c65071158.tg)
	e4:SetOperation(c65071158.op)
	c:RegisterEffect(e4)
end
function c65071158.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandlerPlayer()~=e:GetHandlerPlayer() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local c=g:GetFirst()
		while c do
			c:AddCounter(0x1da0,1)
			c=g:GetNext()
		end
	end
end

function c65071158.scon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandlerPlayer()~=tp
end
function c65071158.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1da0)>=2 and e:GetHandler():GetFlagEffect(65071158)==0 end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1da0,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(65071158,RESET_CHAIN,0,1)
end
function c65071158.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c65071158.efilter)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
end
function c65071158.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end

function c65071158.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65071158.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1da0)>=10 and e:GetHandler():GetFlagEffect(65071159)==0 end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1da0,10,REASON_COST)
	e:GetHandler():RegisterFlagEffect(65071159,RESET_CHAIN,0,1)
end
function c65071158.tgfil(c,tp)
	return (c:IsAbleToGrave() or (c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c65071158.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65071158.tgfil,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65071158.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65071158.tgfil,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g then
		local tc=g:GetFirst()
		if tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(65071158,2)) then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end