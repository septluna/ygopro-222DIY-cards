--星月转夜 暗冥之月
function c65050228.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050228,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65050228.discon)
	e1:SetTarget(c65050228.distg)
	e1:SetOperation(c65050228.disop)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c65050228.aclimit)
	c:RegisterEffect(e2)
end
function c65050228.aclfil(c,g)
	return g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c65050228.aclimit(e,re,tp)
	local g=e:GetHandler():GetOverlayGroup()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and c65050228.aclfil(re:GetHandler(),g)
end
function c65050228.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_SZONE)~=0
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65050228.lvfil(c)
	return c:IsFaceup() and c:GetLevel()>1
end
function c65050228.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Duel.GetMatchingGroup(c65050228.lvfil,tp,LOCATION_MZONE,0,nil)
	local lv=0
	local lc=lg:GetFirst()
	while lc do
		lv=lv+(lc:GetLevel()-1)
		lc=lg:GetNext()
	end
	if chk==0 then return lv>=e:GetHandler():GetOverlayCount() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65050228.disop(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(c65050228.lvfil,tp,LOCATION_MZONE,0,nil)
	local lv=0
	local lc=lg:GetFirst()
	while lc do
		lv=lv+(lc:GetLevel()-1)
		lc=lg:GetNext()
	end
	if lv<e:GetHandler():GetOverlayCount() then return end
	local num=e:GetHandler():GetOverlayCount()
	while num>0 do
		lg=Duel.GetMatchingGroup(c65050228.lvfil,tp,LOCATION_MZONE,0,nil)
		local lcg=lg:FilterSelect(tp,aux.TRUE,1,1,nil)
		Duel.HintSelection(lcg)
		lc=lcg:GetFirst()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(-1)
		lc:RegisterEffect(e2)
		num=num-1
	end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
