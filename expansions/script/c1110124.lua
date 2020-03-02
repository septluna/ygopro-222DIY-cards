---花锦醉蝶-
function c1110124.initial_effect(c)
--
	aux.AddCodeList(c,1110196)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FALSE,3,2,c1110124.XyzFilter,aux.Stringid(1110124,0))
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c1110124.efilter1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110124,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(0)
	e2:SetCost(c1110124.cost2)
	e2:SetTarget(c1110124.tg2)
	e2:SetOperation(c1110124.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--
end
--
function c1110124.XyzFilter(c)
	return aux.IsCodeListed(c,1110196) and c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
--
function c1110124.efilter1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c1110124.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c1110124.tfilter2(c)
	return c:IsAbleToHand() and c:IsCode(1111041)
end
function c1110124.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local n=c:GetOverlayCount()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		return c:CheckRemoveOverlayCard(tp,n,REASON_COST)
			and Duel.IsExistingMatchingCard(c1110124.tfilter2,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(n)
	c:RemoveOverlayCard(tp,n,n,REASON_COST)
end
--
function c1110124.op2(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1110124.tfilter2,tp,LOCATION_DECK,0,1,n,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
