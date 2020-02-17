--调度魔女
local m=12009060
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009060,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12009060)
	e1:SetCost(c12009060.cost)
	e1:SetOperation(c12009060.operation)
	c:RegisterEffect(e1)
end
function c12009060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12009060.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetHandler():GetFieldID()
	local og=Group.CreateGroup()
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetLabel(fid)
	e1:SetLabelObject(og)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c12009060.hdop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	--public
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_FIELD)
	ex:SetCode(EFFECT_CANNOT_TRIGGER)
	ex:SetValue(1)
	ex:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	ex:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ex:SetTarget(function(e,c)
			return c:GetFlagEffect(12009060)>0 and c:IsPublic()
		end)
	Duel.RegisterEffect(ex,tp)
end
function c12009060.hdfilter(c)
	return c:IsLocation(LOCATION_HAND) --and c:IsControler(tp)
end
function c12009060.hdop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=eg:Filter(c12009060.hdfilter,nil)
	if g:GetCount()>0 then
	   Duel.Hint(HINT_CARD,0,12009060)
	end
	local tc=g:GetFirst()
	while tc do
		  local e2=Effect.CreateEffect(e:GetHandler())
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_PUBLIC)
		  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		  tc:RegisterEffect(e2)
		  tc=g:GetNext()
	end
	e:GetLabelObject():Merge(g)
	for tc in aux.Next(g) do
		   tc:RegisterFlagEffect(12009060,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
	end
end		
   
function c12009060.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--public
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetTargetRange(1,1)
	e2:SetOperation(c12009060.drop)
	e2:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e2,tp)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(c12009060.pubcon)
	e3:SetTarget(c12009060.pubtg)
	e3:SetLabelObject(g)
	Duel.RegisterEffect(e3,tp)
	--public
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_FIELD)
	ex:SetCode(EFFECT_CANNOT_TRIGGER)
	ex:SetValue(1)
	ex:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	ex:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ex:SetTarget(function(e,c)
			return c:GetFlagEffect(12009060)>0 and c:IsPublic()
		end)
	Duel.RegisterEffect(ex,tp)
end
function c12009060.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=e:GetLabelObject()
	if c:GetFlagEffect(12009060)==0 then
		c:RegisterFlagEffect(12009060,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,1)
		pg:Clear()
	end
	local tc=eg:GetFirst()
	while tc do
		pg:AddCard(tc)
		tc:RegisterFlagEffect(12009060+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c12009060.pubcon(e)
	return e:GetHandler():GetFlagEffect(12009060)~=0
end
function c12009060.pubtg(e,c)
	return e:GetLabelObject():IsContains(c) and c:GetFlagEffect(12009060+100)~=0
end