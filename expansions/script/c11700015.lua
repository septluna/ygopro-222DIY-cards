--ZEON-扎古II·S赤色彗星
local m=11700015
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,5,3,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
--ATKDOWN
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.cost)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsRank(4)
end

function cm.atkval(e,c)
	return c:GetOverlayCount()*300
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local ac=ag:GetFirst()
			local tc=c:GetOverlayCount()*300
			while ac do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(-tc)
				ac:RegisterEffect(e1)
				ac=ag:GetNext()
			end
end