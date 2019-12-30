--幻世绘本录-等候-
function c65020169.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020169+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65020169.tg)
	e1:SetOperation(c65020169.op)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65020169.xmcon)
	e2:SetValue(c65020169.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c65020169.xmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xcda8)
end
function c65020169.atkval(e,c)
	return c:GetOverlayCount()*200
end

function c65020169.filter(c)
   return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xcda8)
end
function c65020169.filter1(c)
   return c:IsSetCard(0xcda8)  
end
function c65020169.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65020169.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020169.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65020169.filter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetOverlayGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):GetCount()>0 end
	Duel.SelectTarget(tp,c65020169.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65020169.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local og=Duel.GetOverlayGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if og:GetCount()>0 then
			local on=Duel.SendtoGrave(og,REASON_EFFECT)
			if on~=og:GetCount() then return end
			local gcn=Duel.GetMatchingGroupCount(c65020169.filter1,tp,LOCATION_GRAVE,0,nil)
			if on>gcn then on=gcn end
			local g=Duel.SelectMatchingCard(tp,c65020169.filter1,tp,LOCATION_GRAVE,0,1,on,nil)
			if g:GetCount()>0 then 
				Duel.Overlay(tc,g)  
			end
		end
	end
end