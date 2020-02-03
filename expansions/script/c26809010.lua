--Lonely Birthday
function c26809010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c26809010.condition)
	e1:SetTarget(c26809010.target)
	e1:SetOperation(c26809010.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c26809010.eqlimit)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c26809010.indcon)
	e4:SetValue(c26809010.efilter)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(c26809010.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
	--cannot summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SUMMON)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c26809010.eqlimit(e,c)
	if e:GetHandler():GetEquipTarget()==c then return true end
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	local tc=g:GetFirst()
	return g:GetCount()==1 and tc==c
end
function c26809010.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return g:GetCount()==1 and tc:IsFaceup()
end
function c26809010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chkc then return chkc==tc end
	if chk==0 then return tc and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c26809010.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local tc=Duel.GetFirstTarget()
	if ct==1 and e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c26809010.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c26809010.indcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
