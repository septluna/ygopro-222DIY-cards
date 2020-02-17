--魅魔的后辈是手冲魔女
local m=4241002
local cm=_G["c"..m]
function cm.initial_effect(c)
	iFunc(c).c("RegisterEffect",iFunc(c)
		.e("SetDescription",aux.Stringid(m,0))
		.e("SetCategory",CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
		.e("SetType",EFFECT_TYPE_QUICK_O)
		.e("SetCode",EVENT_SPSUMMON)
		.e("SetRange",LOCATION_HAND)
		.e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
			return tp~=ep and Duel.GetCurrentChain()==0 end)
		.e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return e:GetHandler():IsDiscardable() end
			Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD) end)
		.e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chk==0 then return Duel.IsPlayerCanDraw(1-tp,2) end
			Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,2)end)
		.e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp,chk)
			Duel.Draw(1-tp,2,REASON_EFFECT)
			Duel.NegateSummon(eg)
			Duel.Destroy(eg,REASON_EFFECT) end)
	.Return()).c("RegisterEffect",iFunc(c)
		.e("SetType",EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		.e("SetCode",EVENT_CHAIN_SOLVED)
		.e("SetRange",LOCATION_GRAVE)
		.e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.GetFlagEffect(tp,m)>0 end)
		.e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp,chk)
			local n=Duel.GetFlagEffect(tp,m)
			Duel.ResetFlagEffect(tp,m)
			Duel.Draw(1-tp,n,REASON_EFFECT) end)
	.Clone("RegisterEffect")
		.e("SetCategory",CATEGORY_TOHAND)
		.e("SetType",EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		.e("SetCode",EVENT_SPSUMMON_SUCCESS)
		.e("SetProperty",EFFECT_FLAG_DELAY)
		.e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp,chk)
			return eg:IsExists(cm.filter,1,nil,1-tp) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))end)
		.e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp,chk)
			Duel.Draw(1-tp,1,REASON_EFFECT) end)
	.Clone("RegisterEffect")
		.e("SetProperty",0)
		.e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp,chk)
			return eg:IsExists(cm.filter,1,nil,1-tp) and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS) end)
		.e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp,chk)
			Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) end)
	.Return())
end
function cm.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function cm.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW)
end
function iFunc(c,x)
	local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
	local fe = function(name,...) if name =="RegisterEffect" then c:RegisterEffect(__this:Clone()) else (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) end return iFunc(c,__this) end
	local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
	local func ={e = fe,Clone = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
	return func
end