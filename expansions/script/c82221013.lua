function c82221013.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,82221013+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_SSET)  
	e1:SetTarget(c82221013.target)  
	e1:SetOperation(c82221013.activate)  
	c:RegisterEffect(e1)  
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e2:SetCondition(c82221013.handcon1)  
	c:RegisterEffect(e2)  
	--act in hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e3:SetCondition(c82221013.handcon2)  
	c:RegisterEffect(e3)  
end  
function c82221013.handcon1(e)  
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0  
end  
function c82221013.handcon2(e)  
	return Duel.IsExistingMatchingCard(c82221013.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)  
end  
function c82221013.filter0(c)  
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION)
end  
function c82221013.filter1(c)  
	return c:IsAbleToRemove()  
end  
function c82221013.filter2(c)  
	return c:IsSetCard(0x292) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end  
function c82221013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and c82221013.filter1(chkc) and chkc~=e:GetHandler() end  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221013.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingTarget(c82221013.filter1,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,c82221013.filter1,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_ONFIELD)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0) 
end  
function c82221013.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget() 
	local g=Duel.SelectMatchingCard(tp,c82221013.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler()) 
	if tc:IsRelateToEffect(e) and Duel.Destroy(g,REASON_EFFECT)~=0 then  
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)  
	end  
end  