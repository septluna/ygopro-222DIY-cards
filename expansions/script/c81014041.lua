--蓝色花园·梦前菜菜
local m=81014041
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,false)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_FUSION)
	--act limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,1)
	e0:SetValue(cm.limval)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(Senya.order_table_new({}))
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(m)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
	local ey=Effect.CreateEffect(c)
	ey:SetType(EFFECT_TYPE_SINGLE)
	ey:SetCode(m-1000)
	ey:SetRange(LOCATION_MZONE)
	ey:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ey)
	--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCost(cm.spcost)
	e3:SetOperation(cm.spcop)
	c:RegisterEffect(e3)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFaceup() and c:IsFusionType(TYPE_EFFECT) and c:GetSummonLocation()==LOCATION_EXTRA  and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function cm.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsType(TYPE_EFFECT) and rc:IsStatus(STATUS_SPSUMMON_TURN) and not rc:IsCode(m)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsHasEffect(m)
end
function cm.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function cm.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(cm.gfilter2,1,nil,c:GetOriginalCode())
end
function cm.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=Senya.order_table[e:GetLabel()]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetMatchingGroup(cm.copyfilter,tp,0,LOCATION_MZONE,nil)
	local dg=exg:Filter(cm.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(cm.gfilter1,nil,exg)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		e:SetCondition(cm.rcon(e:GetCondition(),tc,copyt))
		e:SetCost(cm.rcost(e:GetCost()))
		if e:IsHasType(EFFECT_TYPE_IGNITION) then
			e:SetType((e:GetType()-EFFECT_TYPE_IGNITION | EFFECT_TYPE_QUICK_O))
			e:SetCode(EVENT_FREE_CHAIN)
			e:SetHintTiming(0,0x1c0)
		end
		f(tc,e,forced)
	end
	for tc in aux.Next(cg) do
		copyt[tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
	Card.RegisterEffect=f
end
function cm.rcon(con,tc,copyt)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsHasEffect(m-1000) then
			c:ResetEffect(c,copyt[tc],RESET_COPY)
			copyt[tc]=nil
			return false
		end
		return not con or con(e,tp,eg,ep,ev,re,r,rp) or e:IsHasType(0x7e0)
	end
end
function cm.rcost(cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not cost or cost(e,tp,eg,ep,ev,re,r,rp,0) or e:IsHasType(0x7e0) end
		return not cost or e:IsHasType(0x7e0) or cost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function cm.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return c~=e:GetHandler()
end
