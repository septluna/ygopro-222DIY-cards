--幻世绘本页-惊吓-
function c65020173.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65020173)
	e1:SetCondition(c65020173.accon)
	e1:SetCost(c65020173.accost)
	e1:SetTarget(c65020173.actg)
	e1:SetOperation(c65020173.acop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,65020174)
	e2:SetTarget(c65020173.tg)
	e2:SetOperation(c65020173.op)
	c:RegisterEffect(e2)
end
function c65020173.acfil(c)
	return c:IsSetCard(0xcda8) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c65020173.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and Duel.IsExistingMatchingCard(c65020173.acfil,tp,LOCATION_MZONE,0,1,nil)
end
function c65020173.actgfil(c)
	return c:IsCanBeEffectTarget() and c:IsAbleToDeck()
end
function c65020173.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tgc=Duel.GetMatchingGroupCount(c65020173.actgfil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local gc=g:GetFirst()
	local rk=gc:GetRank()
	if tgc>rk then tgc=rk end
	if chk==0 then return tgc>0 and gc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local num=gc:RemoveOverlayCard(tp,1,tgc,REASON_COST)
	e:SetLabel(num)
end
function c65020173.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return true end
	local num=e:GetLabel()
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,num,num,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,num,0,0)
end
function c65020173.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

function c65020173.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetPreviousLocation()==LOCATION_OVERLAY and Duel.IsExistingMatchingCard(c65020173.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65020173.thfilter(c)
	return c:IsSetCard(0xcda8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() 
end
function c65020173.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c65020173.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
