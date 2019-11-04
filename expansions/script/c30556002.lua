--空中都市 调查者
function c30556002.initial_effect(c)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30556002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c30556002.sccon)
	e1:SetTarget(c30556002.sctg)
	e1:SetOperation(c30556002.scop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,30556002)
	e2:SetCondition(c30556002.con)
	e2:SetTarget(c30556002.tg)
	e2:SetOperation(c30556002.op)
	c:RegisterEffect(e2)
end
function c30556002.confil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0x305) and c:IsType(TYPE_SYNCHRO)
end
function c30556002.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30556002.confil,1,nil,tp)
end
function c30556002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c30556002.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function c30556002.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c30556002.sctfil(c,ec,mg)
	return c:IsSynchroSummonable(ec,mg) and c:IsSetCard(0x305)
end
function c30556002.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		return Duel.IsExistingMatchingCard(c30556002.sctfil,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),mg) and e:GetHandler():GetFlagEffect(30556002)==0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:GetHandler():RegisterFlagEffect(30556002,RESET_CHAIN,0,1)
end
function c30556002.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(c30556002.sctfil,tp,LOCATION_EXTRA,0,nil,e:GetHandler(),mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),e:GetHandler(),mg)
	end
end