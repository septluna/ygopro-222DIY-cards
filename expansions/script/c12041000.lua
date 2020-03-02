--海与少女的契约
function c12041000.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c12041000.cost)
	e1:SetTarget(c12041000.target)
	e1:SetOperation(c12041000.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c12041000.con)
	e2:SetTarget(c12041000.tg)
	e2:SetOperation(c12041000.op)
	c:RegisterEffect(e2)
end
function c12041000.confil(c,tp)
	return Duel.IsExistingMatchingCard(c12041000.conffil,tp,LOCATION_GRAVE,0,1,nil,c) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c12041000.conffil(c,mc)
	local res=(c:IsType(TYPE_FUSION) and mc:IsType(TYPE_FUSION)) or (c:IsType(TYPE_SYNCHRO) and mc:IsType(TYPE_SYNCHRO)) or (c:IsType(TYPE_XYZ) and mc:IsType(TYPE_XYZ)) or (c:IsType(TYPE_LINK) and mc:IsType(TYPE_LINK))
	return c:IsSetCard(0x3faa) and res and c:IsAbleToExtra()
end
function c12041000.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12041000.confil,1,nil,tp)
end
function c12041000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c12041000.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c12041000.confil,nil,tp)
	local sg=Group.CreateGroup()
	local gc=g:GetFirst()
	while gc do
		sg:Merge(Duel.GetMatchingGroup(c12041000.conffil,tp,LOCATION_GRAVE,0,nil,gc))
		gc=g:GetNext()
	end
	if e:GetHandler():IsRelateToEffect(e) and sg:GetCount()>0 then
		local ng=sg:FilterSelect(tp,aux.TRUE,1,1,nil)
		Duel.HintSelection(ng)
		if Duel.SendtoDeck(ng,nil,2,REASON_EFFECT)~=0 then
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		end
	end
end

function c12041000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c12041000.tgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x3faa)
end
function c12041000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12041000.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c12041000.hspfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_SEASERPENT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c12041000.tgvfilter(c)
	return c:IsSetCard(0x3faa) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c12041000.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12041000.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local b1=tc:IsType(TYPE_FUSION) and tc:IsAbleToExtra() and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12003011,0xfb8,0x4011,800,1000,3,RACE_SEASERPENT,ATTRIBUTE_WATER)
		local b2=tc:IsType(TYPE_SYNCHRO) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12041000.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		local b3=tc:IsType(TYPE_XYZ) and Duel.IsPlayerCanSpecialSummonMonster(tp,12003011,0xd4,0x11,0,0,9,RACE_SEASERPENT,ATTRIBUTE_WATER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e)
		local b4=tc:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(c12041000.tgvfilter,tp,LOCATION_DECK,0,1,nil)
		if b1 and Duel.SelectYesNo(tp,aux.Stringid(12041000,0)) then
			for i=1,3 do
			local token=Duel.CreateToken(tp,12003011)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			--cannot material
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e1:SetValue(1)
			token:RegisterEffect(e1,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			token:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e4,true)
			end
			Duel.SpecialSummonComplete()
		end
		if b2 and Duel.SelectYesNo(tp,aux.Stringid(12041000,0)) then
			 local ga=Duel.SelectMatchingCard(tp,c12041000.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			local atc=ga:GetFirst()
			if atc and Duel.SpecialSummonStep(atc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				atc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				atc:RegisterEffect(e2,true)
			end
			Duel.SpecialSummonComplete()
		end
		if b3 and Duel.SelectYesNo(tp,aux.Stringid(12041000,0)) then
			e:GetHandler():AddMonsterAttribute(TYPE_NORMAL)
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
		end
		if b4 and Duel.SelectYesNo(tp,aux.Stringid(12041000,0)) then
			local gn=Duel.SelectMatchingCard(tp,c12041000.tgvfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(gn,REASON_EFFECT)
		end
	end
end