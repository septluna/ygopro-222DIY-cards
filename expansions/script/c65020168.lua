--幻世绘本录-欢笑-
function c65020168.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020168+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65020168.tg)
	e1:SetOperation(c65020168.op)
	c:RegisterEffect(e1)
	 --gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e2:SetCondition(c65020168.xmcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
end
function c65020168.xmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xcda8)
end

function c65020168.filter(c)
   return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c65020168.filter1(c)
   return c:IsSetCard(0xcda8) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c65020168.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65020168.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020168.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65020168.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)>0 end
	Duel.SelectTarget(tp,c65020168.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c65020168.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local n1=Duel.GetMatchingGroupCount(c65020168.filter1,tp,LOCATION_DECK,0,nil)
		local n2=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
		if n1>n2 then n1=n2 end
		local num=Duel.DiscardHand(tp,Card.IsAbleToGrave,1,n1,REASON_EFFECT,nil)
		if num>0 then
		local ng=Duel.SelectMatchingCard(tp,c65020168.filter1,tp,LOCATION_DECK,0,num,num,nil)
		if ng:GetCount()>0 then
			Duel.Overlay(tc,ng) 
		end
		end
	end
end