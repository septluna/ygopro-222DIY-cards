--原罪机械 希望的特普勒
local m=12004023
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,12004020,c12004023.fsfilter2,1,63,true,true)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c12004023.valcheck)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,12004023)
	e2:SetLabelObject(e1)
	e2:SetCondition(c12004023.descon)
	e2:SetTarget(c12004023.destg)
	e2:SetOperation(c12004023.desop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c12004023.condition)
	e3:SetValue(c12004023.efilter)
	c:RegisterEffect(e3)
	--Atk update
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c12004023.condition)
	e3:SetValue(4000)
	c:RegisterEffect(e3)  
end
function c12004023.valcheck(e,c)
	local g=c:GetMaterial()
	local tpe=0
	local tc=g:GetFirst()
	while tc do
			tpe=bit.bor(tpe,tc:GetType())
		tc=g:GetNext()
	end
	e:SetLabel(tpe)
end
function c12004023.atkval(e,c)
	local tp=c:GetControler()
	local lp1,lp2=Duel.GetLP(tp),Duel.GetLP(1-tp)
	return math.abs(lp1-lp2)
end
function c12004023.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil)
end
function c12004023.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12004023.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)==0
end
function c12004023.fsfilter1(c)
	return c:IsSetCard(0xfb1) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SYNCHRO) 
end
function c12004023.fsfilter2(c)
	return c:IsType(TYPE_MONSTER) and ( c:IsType(TYPE_LINK) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_RITUAL) or c:IsType(TYPE_PENDULUM) )
end
function c12004023.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c12004023.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local g=c:GetMaterial()
	local tpe=0
	local tc=g:GetFirst()
	while tc do
			tpe=bit.bor(tpe,tc:GetType())
		tc=g:GetNext()
	end
	local ct=tpe
	local cc=0
	if bit.band(ct,TYPE_FUSION)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_RITUAL)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_SYNCHRO)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_XYZ)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_PENDULUM)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_LINK)~=0 then cc=cc+1 end
	if cc>0 then
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_FIELD)
		   e2:SetRange(LOCATION_MZONE)
		   e2:SetCode(EFFECT_DISABLE_FIELD)
		   e2:SetOperation(c12004023.disop)
		   c:RegisterEffect(e2)
	end
end
function c12004023.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local tpe=0
	local tc=g:GetFirst()
	while tc do
			tpe=bit.bor(tpe,tc:GetType())
		tc=g:GetNext()
	end
	local ct=tpe
	local cc=0
	if bit.band(ct,TYPE_FUSION)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_RITUAL)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_SYNCHRO)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_XYZ)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_PENDULUM)~=0 then cc=cc+1 end
	if bit.band(ct,TYPE_LINK)~=0 then cc=cc+1 end
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,cc,0,LOCATION_MZONE,0)
	return dis1
end
