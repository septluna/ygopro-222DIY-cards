--热量回收
function c1111032.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1111032.cost1)
	e1:SetTarget(c1111032.tg1)
	e1:SetOperation(c1111032.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111032,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_DRAW+CATEGORY_COUNTER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c1111032.tg2)
	e2:SetOperation(c1111032.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111032.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1015,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1015,2,REASON_COST)
end
--
function c1111032.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33400553,0x63413344,0x4011,0,0,4,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1111032.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,33400553,0x63413344,0x4011,0,0,4,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP,tp) then
		local token=Duel.CreateToken(tp,33400553)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c1111032.tfilter2(c,tp)
	local b1=Duel.GetMZoneCount(tp)>0
	local b2=c:IsControlerCanBeChanged() and Duel.GetMZoneCount(1-tp)>0 
	return c:IsFaceup() and c:IsCode(33400553) and (b1 or b2)
end
function c1111032.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1111032.tfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111032.tfilter2,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111032,2))
	local sg=Duel.SelectTarget(tp,c1111032.tfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
--
function c1111032.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsControler(1-tp) then return end
	if tc:IsImmuneToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq=0
	if tc:IsControlerCanBeChanged() then
		seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)
	else
		seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0xe000e0)
	end
	if seq==nil then return end
	local nseq=math.log(seq,2)
	if nseq<16 then Duel.MoveSequence(tc,nseq) end
	if nseq>15 then 
		local dis=bit.lshift(0x1,nseq-16)
		Duel.GetControl(tc,1-tp,0,0,dis)
--
		local sg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1015,1)
		if sg:GetCount()<1 then return end
		if not Duel.IsPlayerCanDraw(tp,1) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(1111032,3)) then
			Duel.Draw(tp,1,REASON_EFFECT)
			local tc=sg:GetFirst()
			while tc do
				tc:AddCounter(0x1015,1)
				tc=sg:GetNext()
			end
		end
--
	end
end
--

