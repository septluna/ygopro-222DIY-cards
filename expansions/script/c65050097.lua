--霓色独珠的细语者
function c65050097.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050097,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,65050097)
	e1:SetTarget(c65050097.target)
	e1:SetOperation(c65050097.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65050097,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,65050098)
	e3:SetTarget(c65050097.target2)
	e3:SetOperation(c65050097.operation2)
	c:RegisterEffect(e3)
end
function c65050097.filter(c)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c65050097.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050097.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050097.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65050097.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c65050097.tfilter(c,e,tp)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetMZoneCount(tp)>0))
end
function c65050097.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c65050097.tfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	if chk==0 then return g:GetCount()>0 end
	if g:FilterCount(Card.IsAbleToHand,nil)==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
	if g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)==0 or Duel.GetMZoneCount(tp)<=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c65050097.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65050097.tfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	local b1=g:FilterCount(Card.IsAbleToHand,nil)>0
	local b2=g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)>0 and Duel.GetMZoneCount(tp)>0
	if g then
		local s=9
		if b1 and b2 then
			if Duel.SelectYesNo(tp,aux.Stringid(65050097,0)) then 
				s=1
			else s=0 end
		elseif b1 then
			s=0
		elseif b2 then
			s=1
		end
		if s==0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif s==1 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end