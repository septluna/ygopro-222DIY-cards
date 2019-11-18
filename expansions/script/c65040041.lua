--幻雪之魔术士
function c65040041.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,3)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c65040041.cost)
	e1:SetTarget(c65040041.target)
	e1:SetOperation(c65040041.activate)
	c:RegisterEffect(e1)
end
function c65040041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65040041.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() 
end
function c65040041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65040041.filter,tp,0,LOCATION_ONFIELD,1,c) and e:GetHandler():GetFlagEffect(65040041)==0 end
	local sg=Duel.GetMatchingGroup(c65040041.filter,tp,0,LOCATION_ONFIELD,c)
	e:GetHandler():RegisterFlagEffect(65040041,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,sg:GetCount()*300)
end
function c65040041.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c65040041.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local num=Duel.SendtoHand(sg,nil,REASON_EFFECT)
	if num~=0 then
		Duel.Damage(1-tp,num*300,REASON_EFFECT)
	end
end