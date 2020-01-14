--虚拟YouTuber 猫宫Hinata
local m=33700352
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,function(c) return c:IsAttackAbove(2000) end,function(c) return c:IsAttackBelow(2000) end,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	local function v_filter(c)
		return (c:IsLocation(LOCATION_HAND) and not c:IsPublic()) or (c:IsOnField() and c:IsFacedown())
	end
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(v_filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local g=Duel.SelectMatchingCard(tp,v_filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.ConfirmCards(tp,g)
		end
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLPCost(tp,1000) end
		Duel.PayLPCost(tp,1000)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(v_filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		cm.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
		local ac=Duel.AnnounceCardFilter(tp,table.unpack(cm.announce_filter))
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local g=Duel.GetMatchingGroup(v_filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil):Filter(Card.IsCode,nil,ac)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
end
function cm.rfilter(c,tp,sc)
	return c:IsFaceup() and c:IsAttack(2000) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function cm.mzfilter(c,tp,sc)
	return c:IsFaceup() and c:IsAttack(2000) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct>2 then return false end
	if ct>0 and not Duel.IsExistingMatchingCard(cm.mzfilter,tp,LOCATION_MZONE,0,ct,nil) then return false end
	return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct<0 then ct=0 end
	local g=Group.CreateGroup()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,cm.mzfilter,tp,LOCATION_MZONE,0,ct,ct,nil)
		g:Merge(sg)
	end
	if ct<2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2-ct,2-ct,g:GetFirst())
		g:Merge(sg)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end