--Happy Lily·Tenka
local m=81000002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,cm.mfilter1,cm.mfilter2,1,3,true)
end
function cm.mfilter1(c)
	return c:GetOriginalCode()==81000000
end
function cm.mfilter2(c)
	return c:IsFusionType(TYPE_EFFECT)
end