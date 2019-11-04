--灵都·安宁时序的轮转
local m=1110152
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110152.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110152,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1110152.con1)
	e1:SetOperation(c1110152.op1)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e1)
--
end
--
function c1110152.con1(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
end
--
function c1110152.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_1:SetReset(RESET_EVENT+0xfe0000)
	e1_1:SetValue(c1110152.val1_1)
	c:RegisterEffect(e1_1,true)
--
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1_2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1_2:SetValue(1)
	e1_2:SetReset(RESET_EVENT+0xfe0000)
	c:RegisterEffect(e1_2,true)
	local e1_3=e1_2:Clone()
	e1_3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e1_3,true)
	local e1_4=e1_2:Clone()
	e1_4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e1_4,true)
	local e1_5=e1_2:Clone()
	e1_5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e1_5,true)
--
end
--
function c1110152.val1_1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
