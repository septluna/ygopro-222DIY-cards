--造神计划3 星锁 
function c33330103.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c33330103.lcheck)
	c:EnableReviveLimit()
	--atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2)
	e1:SetTarget(c33330103.atktg)
	e1:SetOperation(c33330103.atkop)
	c:RegisterEffect(e1)
	--cannnot chain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c33330103.actop)
	c:RegisterEffect(e2)
	 --disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c33330103.discon)
	e5:SetOperation(c33330103.disop)
	c:RegisterEffect(e5)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetCondition(c33330103.hspcon)
	e3:SetOperation(c33330103.hspop)
	c:RegisterEffect(e3)
end
function c33330103.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=tp and Duel.GetCurrentChain()>=3 
end
function c33330103.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c33330103.hspfilter(c)
	return c:IsSetCard(0x55f)
		and c:IsAbleToDeckOrExtraAsCost()
end
function c33330103.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(c33330103.hspfilter,tp,LOCATION_GRAVE,0,4,c)
end
function c33330103.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.IsExistingMatchingCard(tp,c33330103.hspfilter,tp,LOCATION_GRAVE,0,4,4,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c33330103.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsSetCard(0x55f) then
		Duel.SetChainLimit(c33330103.chainlm)
	end
end
function c33330103.chainlm(e,rp,tp)
	return tp==rp
end
function c33330103.lcheck(g)
	return g:IsExists(c33330103.lcfil,1,nil)
end
function c33330103.lcfil(c)
	return c:IsSetCard(0x55f) and c:IsLinkAbove(2)
end
function c33330103.atkfil(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c33330103.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c33330103.atkfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33330103.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	local g2=Duel.GetDecktopGroup(tp,1)
	local op=99
	if g1:GetCount()>0 and g2:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(33330103,0),aux.Stringid(33330103,1))
	elseif g1:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(33330103,0))
	elseif g2:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(33330103,1))+1
	else return end
	local g=Group.CreateGroup()
	if op==0 then
		g=g1:FilterSelect(tp,aux.TRUE,1,1,nil)
	elseif op==1 then
		g=g2
	end
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local atg=Duel.GetMatchingGroup(c33330103.atkfil,tp,0,LOCATION_MZONE,nil)
		local atc=atg:GetFirst()
		while atc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			atc:RegisterEffect(e1)
			atc=atg:GetNext()
		end
	end
end


	