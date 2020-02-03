--ALSTROEMERIA！
function c26802003.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,26800000,c26802003.ffilter,1,true,true)
end
function c26802003.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) and c:IsLevel(8) and c:IsFusionType(TYPE_NORMAL)
end
