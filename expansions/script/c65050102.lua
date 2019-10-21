--霓色独珠 新日的祝福
function c65050102.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,65050102)
	e1:SetCondition(c65050102.con)
	e1:SetTarget(c65050102.tg)
	e1:SetOperation(c65050102.op)
	c:RegisterEffect(e1)
   --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,65050103)
	e2:SetCondition(c65050102.thcon)
	e2:SetTarget(c65050102.thtg)
	e2:SetOperation(c65050102.thop)
	c:RegisterEffect(e2)
end
function c65050102.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c65050102.spfil1(c,e,tp)
	local code=c:GetCode()
	local lv=c:GetLevel()
	return c:IsSetCard(0x3da8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.IsExistingMatchingCard(c65050102.spfil2,tp,LOCATION_GRAVE,0,1,c,e,tp,code,lv) and lv>0
end
function c65050102.spfil2(c,e,tp,code,lc)
	return c:IsSetCard(0x3da8) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(code)
end
function c65050102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050102.spfil1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp)>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c65050102.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local g=Duel.SelectMatchingCard(tp,c65050102.spfil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local code=g:GetFirst():GetCode()
		local lv=g:GetFirst():GetLevel()
		local gn=Duel.SelectMatchingCard(tp,c65050102.spfil2,tp,LOCATION_GRAVE,0,1,1,g,e,tp,code,lv)
		g:Merge(gn)
		if g:GetCount()==2 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end

function c65050102.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c65050102.thfilter(c)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c65050102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050102.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050102.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end