--3L·幽灵乐团
local m=37564823
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
cm.Senya_name_with_3L=true
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	Senya.Fusion_3L(c,Senya.check_fusion_set_3L,nil,2,5)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c:GetMaterialCount()*200)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end)
	c:RegisterEffect(e3)
end
