local scard=c77702002
local id=77702002
local m=id
local cm=scard
function scard.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(scard.regtg)
	e0:SetOperation(function()
		Duel.Hint(HINT_MUSIC,0,id*16+math.random(0,1))
	end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot set/activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.setlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.actlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,m)
	e4:SetCost(scard.cost)
	e4:SetTarget(scard.target)
	e4:SetOperation(scard.activate)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(m*16+2)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1)
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==tp
	end)
	e5:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return scard[tp]>0 and Duel.IsPlayerCanDraw(tp,scard[tp]) end
		local ct=scard[tp]
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(ct)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	end)
	e5:SetOperation(scard.activate)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(aux.bfgcost)
	e6:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_IMMUNE_EFFECT)
		e7:SetTargetRange(LOCATION_MZONE,0)
		e7:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
		e7:SetValue(function(e,re)
			return e:GetOwner()~=re:GetOwner() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		end)
		e7:SetReset(RESET_PHASE+PHASE_MAIN2)
		Duel.RegisterEffect(e7,tp)
	end)
	c:RegisterEffect(e6)
	--local e8=Effect.CreateEffect(c)
	--e8:SetDescription(m*16+4)
	--e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	--e8:SetRange(LOCATION_FZONE)
	--e8:SetCountLimit(1)
	--e8:SetCode(EVENT_PHASE+PHASE_END)
	--e8:SetCondition(cm.descon)
	--e8:SetOperation(cm.desop)
	--c:RegisterEffect(e8)
	if scard.counter==nil then
		scard.counter=true
		scard[0]=0
		scard[1]=0
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e9:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e9:SetOperation(scard.resetcount)
		Duel.RegisterEffect(e9,0)
		local ea=Effect.CreateEffect(c)
		ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ea:SetCode(EVENT_RELEASE)
		ea:SetOperation(scard.addcount)
		Duel.RegisterEffect(ea,0)
	end
end
function scard.resetcount(e,tp,eg,ep,ev,re,r,rp)
	scard[0]=0
	scard[1]=0
end
function scard.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local p=tc:GetReasonPlayer()
		scard[p]=scard[p]+1
		tc=eg:GetNext()
	end
end
function scard.filter(c)
	return c:IsLevelAbove(7) and c:IsType(TYPE_RITUAL) and c:IsDiscardable()
end
function scard.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,scard.filter,1,1,REASON_COST+REASON_DISCARD)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function scard.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function scard.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16+3)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(scard.gycon)
	e1:SetOperation(scard.gyop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function scard.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function scard.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.SendtoGrave(c,REASON_RULE)
	else if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
		else
			Duel.SendtoGrave(c,REASON_COST)
		end
	end
end
--function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	--local c=e:GetHandler()
	--return Duel.GetTurnPlayer()==tp and 
--end
--function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	--local c=e:GetHandler()
	--Duel.HintSelection(Group.FromCards(c))
	--if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		--Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
	--else Duel.SendtoGrave(c,REASON_COST) end
--end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
