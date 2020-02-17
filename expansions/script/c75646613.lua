--最讨厌科学了
function c75646613.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646613,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c75646613.condition)
	e1:SetTarget(c75646613.target)
	e1:SetOperation(c75646613.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646613,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c75646613.setcon)
	e2:SetTarget(c75646613.settg)
	e2:SetOperation(c75646613.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c75646613.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c75646613.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c75646613.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.GetFlagEffect(tp,75646600)~=0
	local op=0
	if b1 and not b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(75646613,2),aux.Stringid(75646613,3),aux.Stringid(75646613,4))
	elseif not b1 and not b2 then op=Duel.SelectOption(tp,aux.Stringid(75646613,2),aux.Stringid(75646613,3))
	elseif b2 then op=3
	end
	if op==0 then Duel.NegateAttack()
	elseif op==1 then Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	elseif op==2 then Duel.Draw(tp,2,REASON_EFFECT)
	elseif op==3 then Duel.NegateAttack()
					  Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
					  Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c75646613.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c75646613.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c75646613.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
	if Duel.GetFlagEffect(tp,75646600)~=0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end