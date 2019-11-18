--如月千早的试音准备
function c26810019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,26810019+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26810019.activate)
	c:RegisterEffect(e1)
	--release replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_RELEASE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c26810019.reptg)
	e2:SetValue(c26810019.repval)
	e2:SetOperation(c26810019.repop)
	c:RegisterEffect(e2)
	if c26810019.counter==nil then
		c26810019.counter=true
		c26810019[0]=0
		c26810019[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c26810019.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_RELEASE)
		e3:SetOperation(c26810019.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c26810019.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c26810019[0]=0
	c26810019[1]=0
end
function c26810019.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pl=tc:GetPreviousLocation()
		if pl==LOCATION_MZONE and tc:IsPreviousSetCard(0x601) then
			local p=tc:GetReasonPlayer()
			c26810019[p]=c26810019[p]+1
		end
		tc=eg:GetNext()
	end
end
function c26810019.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c26810019.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c26810019.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26810019)
	Duel.Draw(tp,c26810019[tp],REASON_EFFECT)
end
function c26810019.repfilter(c,tp,re)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x601) and c:IsReason(REASON_COST)
		and not c:IsReason(REASON_REPLACE) and re:IsHasType(0x7f0)
end
function c26810019.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c26810019.repfilter,1,nil,tp,re)
		and e:GetHandler():IsAbleToRemoveAsCost() end
	return Duel.SelectYesNo(tp,aux.Stringid(26810019,0))
end
function c26810019.repval(e,c)
	return c26810019.repfilter(c,e:GetHandlerPlayer(),c:GetReasonEffect())
end
function c26810019.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST+REASON_REPLACE)
end
