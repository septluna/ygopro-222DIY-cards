--
local m=17061158
local cm=_G["c"..m]
cm.dfc_front_side=m
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17061158+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,17061159,0,0x21,800,800,3,RACE_FAIRY,ATTRIBUTE_LIGHT)
	local b2=Duel.IsPlayerCanSpecialSummonMonster(tp,17061160,0,0x21,1200,400,3,RACE_FAIRY,ATTRIBUTE_DARK)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (b1 or b2)end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(17061158,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(17061158,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(op)
	e:SetCategory(CATEGORY_TOHAND)
	Duel.Hint(HINT_CARD,0,17061159+op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local tcode=17061159+sel
	local b1=nil
	if tcode==17061159 then b1=Duel.IsPlayerCanSpecialSummonMonster(tp,17061159,0,0x21,800,800,3,RACE_FAIRY,ATTRIBUTE_LIGHT) 
	else b1=Duel.IsPlayerCanSpecialSummonMonster(tp,17061160,0,0x21,1200,400,3,RACE_FAIRY,ATTRIBUTE_DARK) end 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not b1 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetHandler():CancelToGrave()
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
	e:GetHandler():SetEntityCode(tcode,true)
	e:GetHandler():ReplaceEffect(tcode,0,0)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	e:GetHandler():RegisterFlagEffect(17061158,0,0,0)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetFlagEffect(17061158)>0
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=e:GetLabel()
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
	e:GetHandler():ResetFlagEffect(17061158)
end