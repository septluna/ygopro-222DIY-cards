--灵刻使的谢幕
function c10904036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10904036+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c10904036.target)
	e1:SetOperation(c10904036.activate)
	c:RegisterEffect(e1)
	--remove 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38363525,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c10904036.retg)
	e2:SetOperation(c10904036.reop)
	c:RegisterEffect(e2)
end
function c10904036.cfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x237) and c:IsType(TYPE_MONSTER)
end
function c10904036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local g2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g1-g2>=2 and Duel.IsExistingMatchingCard(c10904036.cfilter,tp,LOCATION_DECK,0,2,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_DECK)
end
function c10904036.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Destroy(g,REASON_EFFECT)>0 then
	Duel.BreakEffect()
	local tg=Duel.SelectMatchingCard(tp,c10904036.cfilter,tp,LOCATION_DECK,0,2,2,nil)
	if tg:GetCount()==2 then
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	end
	end
end
function c10904036.refilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x237)
end
function c10904036.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10904036.refilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) and e:GetHandler():IsAbleToRemove() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c10904036.refilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	g1:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,3,0,0)
end
function c10904036.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if tg:GetCount()>0 then
	tg:AddCard(e:GetHandler())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end