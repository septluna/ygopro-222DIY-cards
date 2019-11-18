--寒冻之独影
function c65040045.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65040045,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetOperation(c65040045.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c65040045.con)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
end
function c65040045.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) 
end
function c65040045.op(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_DRAW then
		Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if ph==PHASE_STANDBY then
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if ph==PHASE_MAIN1 then
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
	if ph==PHASE_MAIN2 then
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end