--空中都市 歼灭者
function c30556007.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,30556007)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetTarget(c30556007.destg)
	e2:SetOperation(c30556007.desop)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROY)
	e4:SetTarget(c30556007.damtg)
	e4:SetOperation(c30556007.damop)
	c:RegisterEffect(e4)
end
function c30556007.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,30556007)==0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c30556007.tgfil(c)
	return c:IsSetCard(0x305) and c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c30556007.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,30556007,RESET_PHASE+PHASE_END,0,1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c30556007.tgfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(30556007,0)) then
		local g=Duel.SelectMatchingCard(tp,c30556007.tgfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end


function c30556007.desfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c30556007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c30556007.desfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c30556007.desfil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local dg=Duel.SelectTarget(tp,c30556007.desfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function c30556007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g2:GetCount()>0 and Duel.SendtoHand(g2,nil,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		 Duel.Destroy(tc,REASON_EFFECT)
	end
end
