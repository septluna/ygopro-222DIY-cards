--樱木真乃
local m=26809002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	--cannot be fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--cannot direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--ATK Gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
end
function cm.ffilter(c)
	return c:IsLevelBelow(6) and (c:IsFusionType(TYPE_FUSION) or bit.band(c:GetFusionType(),0x81)==0x81)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.filter,c:GetControler(),0,LOCATION_GRAVE+LOCATION_MZONE,nil)*300
end
function cm.filter(c)
	return (c:IsLevelBelow(6) and (c:IsType(TYPE_FUSION) or bit.band(c:GetType(),0x81)==0x81)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.thfilter(c)
	return c:IsSetCard(0x602) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end
