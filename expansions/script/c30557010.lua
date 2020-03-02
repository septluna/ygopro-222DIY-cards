--永辉真理 谬误驳斥
function c30557010.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,30557010)
	e1:SetTarget(c30557010.tg)
	e1:SetOperation(c30557010.op)
	c:RegisterEffect(e1)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30557010,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,30557010)
	e4:SetCondition(c30557010.necon)
	e4:SetTarget(c30557010.netg)
	e4:SetOperation(c30557010.neop)
	c:RegisterEffect(e4) 
end
function c30557010.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x306)
end
function c30557010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30557010.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c30557010.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c30557010.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end


function c30557010.necon(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c30557010.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c30557010.neop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=re:GetHandler(),e:GetHandler()
	local mmm=0
	local g=Group.FromCards(c)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) and Duel.SelectYesNo(tp,aux.Stringid(30557010,0)) then
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
		if g1:GetFirst():IsSetCard(0x306) then mmm=1 end
		g:Merge(g1)
	end
	local num=Duel.Destroy(g,REASON_EFFECT)
	if num~=0 then
		if Duel.NegateActivation(ev) and num==2 and mmm==1 and tc:IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(30557010,1)) then
		  Duel.SendtoGrave(tc,REASON_EFFECT)  
		end
	end
end