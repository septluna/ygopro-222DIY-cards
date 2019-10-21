--霓色独珠 永日的凝望
function c65050105.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050105,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65050105.discon)
	e2:SetTarget(c65050105.distg)
	e2:SetOperation(c65050105.disop)
	c:RegisterEffect(e2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050105,3))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65050105.discon2)
	e1:SetTarget(c65050105.distg2)
	e1:SetOperation(c65050105.disop2)
	c:RegisterEffect(e1)
end
function c65050105.disc2fil(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsType(TYPE_XYZ+TYPE_RITUAL) and c:IsLocation(LOCATION_MZONE)
end
function c65050105.discon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and g:IsExists(c65050105.disc2fil,1,nil)
end
function c65050105.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65050105.thfil1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050105.thfil2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3da8) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050105.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if Duel.IsExistingMatchingCard(c65050105.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050105.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65050105,1)) then
			local g1=Duel.SelectMatchingCard(tp,c65050105.thfil1,tp,LOCATION_DECK,0,1,1,nil)
			local g11=Duel.SelectMatchingCard(tp,c65050105.thfil2,tp,LOCATION_DECK,0,1,1,nil)
			g1:Merge(g11)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		if Duel.IsExistingMatchingCard(c65050105.thfil1,1-tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050105.thfil2,1-tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(65050105,1)) then
			local g2=Duel.SelectMatchingCard(1-tp,c65050105.thfil1,1-tp,LOCATION_DECK,0,1,1,nil)
			local g22=Duel.SelectMatchingCard(1-tp,c65050105.thfil2,1-tp,LOCATION_DECK,0,1,1,nil)
			g2:Merge(g22)
			Duel.SpecialSummon(g2,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end

function c65050105.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:GetHandler():GetSummonLocation()==LOCATION_EXTRA 
end
function c65050105.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65050105.spfil(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65050105.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c65050105.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(65050105,0)) then
			local g1=Duel.SelectMatchingCard(tp,c65050105.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		if Duel.GetMZoneCount(1-tp)>0 and Duel.IsExistingMatchingCard(c65050105.spfil,1-tp,LOCATION_HAND,0,1,nil,e,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(65050105,0)) then
			local g2=Duel.SelectMatchingCard(1-tp,c65050105.spfil,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp)
			Duel.SpecialSummon(g2,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end