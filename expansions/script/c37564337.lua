--DON'T CUT
local m=37564337
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
function cm.initial_effect(c)
	Senya.AddXyzProcedureCustom(c,function(c) return c:IsType(TYPE_LINK) and c:GetLink()==3 end,nil,2,63)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_XYZ)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(function(e) return e:GetHandler():GetOverlayCount()>0 end)
	e1:SetTarget(function(e,c) return c:IsType(TYPE_LINK) end)
	e1:SetValue(function(e,c) return math.ceil(c:GetBaseAttack()/2) end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REMOVE_LINK_MARKER_KOISHI)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(function(e) return e:GetHandler():GetOverlayCount()>0 end)
	e1:SetTarget(function(e,c) return c:IsType(TYPE_LINK) end)
	e1:SetValue(0xfff)
	c:RegisterEffect(e1)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
