--空中都市潜影 —[真理]—
function c30556008.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO)),1)
	c:EnableReviveLimit()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c30556008.condition)
	e1:SetOperation(c30556008.activate)
	c:RegisterEffect(e1)
	 --damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROY)
	e4:SetTarget(c30556008.damtg)
	e4:SetOperation(c30556008.damop)
	c:RegisterEffect(e4)
end
function c30556008.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,30556008)==0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c30556008.tgfil(c)
	return c:IsSetCard(0x305) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c30556008.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,30556008,RESET_PHASE+PHASE_END,0,1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c30556008.tgfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(30556008,0)) then
		local g=Duel.SelectMatchingCard(tp,c30556008.tgfil,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SSet(tp,g:GetFirst())
	end
end

function c30556008.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c30556008.confil,1-tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c30556008.confil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c30556008.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep~=tp 
		and Duel.GetMatchingGroupCount(c30556008.confil,tp,LOCATION_MZONE,0,1,nil)>0 and rc:IsAbleToGrave()
end
function c30556008.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c30556008.repop)
end