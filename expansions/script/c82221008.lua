function c82221008.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x292),2,2,false)
	--destroy  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221008,0))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,82241008)  
	e1:SetTarget(c82221008.destg)  
	e1:SetOperation(c82221008.desop)  
	c:RegisterEffect(e1) 
	--pendulum  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221008,1))  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,82221008) 
	e2:SetCondition(c82221008.pencon)  
	e2:SetTarget(c82221008.pentg)  
	e2:SetOperation(c82221008.penop)  
	c:RegisterEffect(e2)   
	--destroy
	local e3=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221008,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetCountLimit(1,82231008)  
	e3:SetRange(LOCATION_MZONE)   
	e3:SetTarget(c82221008.des2tg)  
	e3:SetOperation(c82221008.des2op)  
	c:RegisterEffect(e3)  
end
function c82221008.desfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x292)  
end  
function c82221008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	if chk==0 then return Duel.IsExistingTarget(c82221008.desfilter,tp,LOCATION_ONFIELD,0,1,nil)  
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g1=Duel.SelectTarget(tp,c82221008.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)  
	g1:Merge(g2)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)  
end  
function c82221008.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)  
	if tg:GetCount()>0 then  
		Duel.Destroy(tg,REASON_EFFECT)  
	end  
end  
function c82221008.pencon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()  
end  
function c82221008.pentg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end  
end  
function c82221008.penop(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)  
	end  
end  
function c82221008.des2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and not chkc==c end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,99,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  
function c82221008.des2op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	local ct=Duel.Destroy(g,REASON_EFFECT)  
	if ct>0 and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(ct*1200)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_EXTRA_ATTACK)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetValue(1)  
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e2)  
	end  
end  