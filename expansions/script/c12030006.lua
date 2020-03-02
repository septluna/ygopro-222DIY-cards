--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030006
local cm=_G["c"..m]
cm.rssetcode="yatori"
function c12030006.initial_effect(c)
	c:EnableReviveLimit()
	 --summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030006,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c12030006.ttcon1)
	e1:SetOperation(c12030006.ttop1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12030006,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetTargetRange(POS_FACEUP_ATTACK,1)
	e2:SetCondition(c12030006.ttcon2)
	e2:SetOperation(c12030006.ttop2)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(c12030006.setcon)
	c:RegisterEffect(e3)
	--return
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(12030006,2))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetTarget(c12030006.rettg)
	e7:SetOperation(c12030006.retop)
	c:RegisterEffect(e7)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
end
function c12030006.ttcon1(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c12030006.ttop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c12030006.ttcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg,1-tp)
end
function c12030006.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,3,3,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c12030006.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c12030006.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return h<5 and Duel.IsPlayerCanDraw(tp,5-h) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5-h)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-h)
end
function c12030006.retop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local h=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if h>=5 then return end
	Duel.Draw(p,5-h,REASON_EFFECT)
	Duel.BreakEffect()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.GetControl(e:GetHandler(),1-tp)
end
function c12030006.retop1(e,tp,eg,ep,ev,re,r,rp)
	local th=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local rh=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if not ( ( th~=5 and Duel.IsExistingMatchingCard(c12030006.ccfilter,tp,0,LOCATION_GRAVE,5-th,nil) ) or 
			 ( rh~=5 and Duel.IsExistingMatchingCard(c12030006.ccfilter,tp,LOCATION_GRAVE,0,5-rh,nil) ) ) then return end
	if th<5 then
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local rg=Duel.SelectMatchingCard(1-tp,c12030006.ccfilter,1-tp,0,LOCATION_GRAVE,5-th,5-th,nil)
		  if rg:GetCount()>0 then 
			 local upa=0
			 local tc=rg:GetFirst()
			 while tc do
			 local upa1=tc:GetAttack()
			 upa=upa+upa1
			 tc=rg:GetNext()
			 e:SetLabel(upa)
			 end
			 end
	Duel.SendtoHand(rg,1-tp,REASON_EFFECT)

	else
	rg=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,0,LOCATION_HAND,5-th,5-th,nil,TYPE_MONSTER)
		if rg:GetCount()>0 then 
	local upa=0
	local tc=rg:GetFirst()
	while tc do
		  local upa1=tc:GetAttack()
		  upa=upa+upa1
		  tc=rg:GetNext()
		  e:SetLabel(upa)
	end
	end
	Duel.SendtoGrave(rg,REASON_EFFECT)
	local dem1=e:GetLabel()
	Duel.Damage(1-tp,dem1,REASON_EFFECT)
	if rh<5 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c12030006.ccfilter,tp,LOCATION_GRAVE,0,5-rh,5-rh,nil)
	if tg:GetCount()>0 then 
	local upa=0
	local tc=tg:GetFirst()
	while tc do
		  local upa1=tc:GetAttack()
		  upa=upa+upa1
		  tc=tg:GetNext()
		  e:SetLabel(upa)
	end
	end
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	else
	tg=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,0,LOCATION_HAND,5-th,5-th,nil,TYPE_MONSTER)
		if tg:GetCount()>0 then 
	local upa=0
	local tc=tg:GetFirst()
	while tc do
		  local upa1=tc:GetAttack()
		  upa=upa+upa1
		  tc=tg:GetNext()
		  e:SetLabel(upa)
	end
	end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	local dem2=e:GetLabel()
	Duel.Damage(tp,dem2,REASON_EFFECT)
	end
	end
end
