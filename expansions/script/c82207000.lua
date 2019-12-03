local m=82207000
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--cannot special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	c:RegisterEffect(e1) 
	--summon with no tribute  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_SUMMON_PROC)  
	e2:SetCondition(cm.ntcon)  
	c:RegisterEffect(e2) 
	--effect gain  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_BE_MATERIAL)  
	e3:SetCondition(cm.efcon)  
	e3:SetOperation(cm.efop)  
	c:RegisterEffect(e3)  
end  
function cm.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)  
	return r==REASON_XYZ  
end  
function cm.efop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local rc=c:GetReasonCard()  
	local e1=Effect.CreateEffect(rc)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)	
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(cm.thcon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	e1:SetReset(RESET_EVENT+0x1fe0000)  
	rc:RegisterEffect(e1,true)  
	if not rc:IsType(TYPE_EFFECT) then  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_ADD_TYPE)  
		e2:SetValue(TYPE_EFFECT)  
		e2:SetReset(RESET_EVENT+0x1fe0000)  
		rc:RegisterEffect(e2,true)  
	end  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE) 
end  
function cm.thfilter(c)  
	return c:IsCode(82207000) and c:IsAbleToHand()  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  