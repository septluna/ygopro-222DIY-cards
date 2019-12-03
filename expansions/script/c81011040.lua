--清晨阳光·椎名咪玉
function c81011040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81011040.mfilter,2,2)
	--equip change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81011040)
	e1:SetTarget(c81011040.eqtg)
	e1:SetOperation(c81011040.eqop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81011940)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81011040.thtg)
	e2:SetOperation(c81011040.thop)
	c:RegisterEffect(e2)
end
function c81011040.mfilter(c)
	return not c:IsType(TYPE_LINK) and c:IsLinkRace(RACE_WARRIOR)
end
function c81011040.eqfilter1(c)
	return c:GetEquipTarget()
		and Duel.IsExistingTarget(c81011040.eqfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget(),c)
end
function c81011040.eqfilter2(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c81011040.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c81011040.eqfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c81011040.eqfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	local tc=g1:GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c81011040.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc:GetEquipTarget(),tc)
end
function c81011040.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==ec then tc=g:GetNext() end
	if ec:IsFaceup() and ec:IsRelateToEffect(e) and ec:CheckEquipTarget(tc) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,ec,tc)
	end
end
function c81011040.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c81011040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81011040.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81011040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81011040.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81011040.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c81011040.atktg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c81011040.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR)
end
function c81011040.atktg(e,c)
	return c:GetEquipCount()==0
end
