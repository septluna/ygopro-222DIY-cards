--谨贺新年 森永Miu
function c81003007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81003007)
	e1:SetCost(c81003007.atkcost)
	e1:SetTarget(c81003007.atktg)
	e1:SetOperation(c81003007.atkop)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c81003007.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function c81003007.indfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetOwner()==1-tp
end
function c81003007.indcon(e)
	return Duel.IsExistingMatchingCard(c81003007.indfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c81003007.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81003007.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c81003007.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81003007.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c81003007.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81003007.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e0:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e0:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e0,true)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
