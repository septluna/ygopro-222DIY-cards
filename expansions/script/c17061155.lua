--
local m=17061155
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side1=17061156
cm.dfc_back_side2=17061157
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	if not cm.global_flag then
		cm.global_flag=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCode(EVENT_CHAINING)
		ge0:SetCondition(cm.atcon)
		ge0:SetOperation(cm.atop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,17061154,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(rp,17061154)>0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,17061155,0,0,0)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,17061155)>9
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ops={aux.Stringid(17061155,1),aux.Stringid(17061155,2)}
	local op=Duel.SelectOption(tp,table.unpack(ops))
	Duel.Hint(HINT_CARD,0,17061156+op)
	--back
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCountLimit(1)
	e1:SetLabel(e:GetHandler():GetOriginalCode())
	e1:SetCondition(cm.backon)
	e1:SetOperation(cm.backop)
	e:GetHandler():RegisterEffect(e1)
	local tcode=17061156+op
	e:GetHandler():SetEntityCode(tcode,true)
	e:GetHandler():ReplaceEffect(tcode,0,0)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	e:GetHandler():RegisterFlagEffect(17061155,0,0,0)
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetFlagEffect(17061155)>0
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=e:GetLabel()
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
	e:GetHandler():ResetFlagEffect(17061155)
end
