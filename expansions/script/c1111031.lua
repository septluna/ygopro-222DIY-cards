---静候春至-
local m=1111031
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1111031.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111031+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111031,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1111031.cost2)
	e2:SetTarget(c1111031.tg2)
	e2:SetOperation(c1111031.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1111031,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1111031.con3)
	e3:SetTarget(c1111031.tg3)
	e3:SetOperation(c1111031.op3)
	c:RegisterEffect(e3)
--
end
--
function c1111031.cfilter2(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c1111031.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c1111031.cfilter2,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c1111031.cfilter2,1,1,nil)
	Duel.Release(g,REASON_COST)
end
--
function c1111031.tfilter2(c)
	return c:IsCode(1170011) and c:IsAbleToHand()
end
function c1111031.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111031.tfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1111031.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1111031.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c1111031.con3(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
--
function c1111031.tfilter3(c,e,tp)
	return muxu.check_set_Urban(c) and c:IsLevelBelow(5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c1111031.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1111031.tfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c1111031.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1111031.tfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)>0 and c:IsRelateToEffect(e) then
			if c:IsCanTurnSet() then
				Duel.BreakEffect()
				Duel.ChangePosition(c,POS_FACEDOWN)
				Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			else
				Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
--
