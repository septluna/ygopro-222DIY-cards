--幻世绘本-扉页-
function c65020163.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,nil,c65020163.xyzcheck,2,99)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65020163,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c65020163.cost)
	e1:SetTarget(c65020163.target)
	e1:SetOperation(c65020163.operation)
	c:RegisterEffect(e1)
	--rankup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_RANK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c65020163.rkval)
	c:RegisterEffect(e2)
	--books
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65020163,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65020163.con)
	e3:SetTarget(c65020163.target2)
	e3:SetOperation(c65020163.activate)
	c:RegisterEffect(e3)
end
function c65020163.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c65020163.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65020163.filter(c)
	return c:IsSetCard(0xcda8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c65020163.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020163.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020163.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65020163.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() and e:GetHandler():IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(65020163,0)) then
				local mg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0xcda8)
				Duel.Overlay(e:GetHandler(),mg)
			end
		end
	end
end

function c65020163.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c65020163.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c65020163.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c65020163.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0xcda8) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c65020163.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c65020163.filter1(e:GetHandler(),e,tp) and e:GetHandler():GetFlagEffect(65020163)==0 end
	e:GetHandler():RegisterFlagEffect(65020163,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65020163.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65020163.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function c65020163.rkval(e,c)
	local num=e:GetHandler():GetOverlayCount()
	return num
end