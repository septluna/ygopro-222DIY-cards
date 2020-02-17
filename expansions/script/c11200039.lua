--丰作之地
function c11200039.initial_effect(c)
	aux.AddCodeList(c,11200029)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c11200039.drcon)
	e2:SetTarget(c11200039.drtg)
	e2:SetOperation(c11200039.drop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,11200039)
	e3:SetTarget(c11200039.reptg)
	e3:SetValue(c11200039.repval)
	e3:SetOperation(c11200039.repop)
	c:RegisterEffect(e3)
end
function c11200039.cfilter(c)
	return aux.IsCodeListed(c,11200029) and not c:IsCode(11200039) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c11200039.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11200039.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function c11200039.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local turnp=Duel.GetTurnPlayer()
	Duel.SetTargetPlayer(turnp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,turnp,1200)
end
function c11200039.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c11200039.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetCounter(0x1620)>0
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c11200039.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_DESTROY_CONFIRMED) and eg:IsExists(c11200039.repfilter,1,nil,tp) and Duel.IsCanRemoveCounter(tp,1,1,0x1620,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c11200039.repval(e,c)
	return c11200039.repfilter(c,e:GetHandlerPlayer())
end
function c11200039.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,1,0x1620,1,REASON_EFFECT+REASON_REPLACE)
end
