--SG继承者，波恋达斯
function c12008009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x1fb3),2,2)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12008009,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c12008009.linkcon)
	e1:SetOperation(c12008009.linkop)
	c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12008009,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12008009.descon)
	e1:SetTarget(c12008009.destg)
	e1:SetOperation(c12008009.desop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008009,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12008009)
	e2:SetCost(c12008009.cost)
	e2:SetTarget(c12008009.target)
	e2:SetOperation(c12008009.operation)
	c:RegisterEffect(e2)
end
function c12008009.sprfilter(c,sc)
	return c:IsCanBeLinkMaterial(sc) and c:IsRace(RACE_SEASERPENT) and Duel.IsExistingMatchingCard(c12008009.sprfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c) and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_LINK)>0 and c:IsAbleToRemoveAsCost()
end
function c12008009.sprfilter1(c,sc)
	return c:IsCanBeLinkMaterial(sc) and c:IsRace(RACE_MACHINE) and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_LINK)>0 and c:IsAbleToRemoveAsCost()
end
function c12008009.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c12008009.sprfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	return g:GetCount()>0
end
function c12008009.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12008009.sprfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cc1=g:Select(tp,1,1,nil)
	local cc2=Duel.SelectMatchingCard(tp,c12008009.sprfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,cc1)
	cc1:Merge(cc2)
	Duel.Remove(cc1,POS_FACEUP,REASON_EFFECT)
	end
end
function c12008009.filter(c)
	return c:IsSetCard(0x1fb3) and c:IsAbleToHand()
end
function c12008009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008009.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12008009.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12008009.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c12008009.cfilter(c,g)
	return g:IsContains(c)
end
function c12008009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12008009.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c12008009.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c12008009.cfilter2(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsSetCard(0x1fb3)
end
function c12008009.descon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c12008009.cfilter2,1,nil,lg)
end
function c12008009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function c12008009.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if dg:GetCount()>0 then
	   Duel.HintSelection(dg)
	   Duel.Destroy(dg,REASON_EFFECT)
	end
end
