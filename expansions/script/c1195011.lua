--风舞的少女·弗朗索瓦
local m=1195011
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1195011.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1195011.mfilter,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1195011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1195011.tg1)
	e1:SetOperation(c1195011.op1)
	c:RegisterEffect(e1)
--
end
--
function c1195011.mfilter(c)
	return not c:IsLinkType(TYPE_TOKEN)
		and c:GetAttack()==0 and c:IsLinkRace(RACE_PLANT)
end
--
function c1195011.tfilter1(c)
	return c:IsRace(RACE_PLANT) and c:IsFaceup()
end
function c1195011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1195011.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1195011.tfilter1,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tg=Duel.SelectTarget(tp,c1195011.tfilter1,tp,LOCATION_MZONE,0,1,1,c)
	Duel.HintSelection(tg)
end
--
function c1195011.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	local code1,code2=tc:GetOriginalCodeRule()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_ADD_LINK_CODE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1_1:SetValue(code1)
	c:RegisterEffect(e1_1)
	if code2 then
		local e1_2=e1_1:Clone()
		e1_2:SetValue(code2)
		c:RegisterEffect(e1_2)
	end
end
--
