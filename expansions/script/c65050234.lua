--辉耀沉迷的星月转夜
function c65050234.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65050234)
	e1:SetCondition(c65050234.con)
	e1:SetTarget(c65050234.tg)  
	e1:SetOperation(c65050234.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c65050234.tcon)
	e2:SetTarget(c65050234.ttg)
	e2:SetOperation(c65050234.top)
	c:RegisterEffect(e2)
	 --RaiseEvent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEVEL_UP)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c65050234.raop)
	c:RegisterEffect(e3)
end
function c65050234.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c65050234.tcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c65050234.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5da9) and c:IsLevel(10)
		and Duel.IsExistingMatchingCard(c65050234.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c65050234.filter2(c,e,tp,mc)
	return c:IsSetCard(0x5da9) and mc:IsCanBeXyzMaterial(c) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
		and ((Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetMZoneCount(tp,mc)>0 and c:IsLocation(LOCATION_GRAVE)))
end
function c65050234.mfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5da9) and c:IsRank(10) and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(c65050234.mfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c65050234.mfilter2(c,e,tp,mc)
	return c:IsSetCard(0x5da9) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
		and ((Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetMZoneCount(tp,mc)>0 and c:IsLocation(LOCATION_GRAVE)))
end
function c65050234.mfilter20(c,e,tp)
	return c:IsSetCard(0x5da9) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c65050234.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65050234.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c65050234.mfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=3
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(65050234,0),aux.Stringid(65050234,1))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65050234,op))
	e:SetLabel(op)
end
function c65050234.top(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	 local b1=Duel.IsExistingMatchingCard(c65050234.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c65050234.mfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if (op==0 and not b1) or (op==1 and not b2) then return end
	if op==0 then
		local g1=Duel.SelectMatchingCard(tp,c65050234.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.HintSelection(g1)
		local gc1=g1:GetFirst()
		local g2=Duel.SelectMatchingCard(tp,c65050234.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,gc1)
			local sc=g2:GetFirst()
			if sc then
				sc:SetMaterial(Group.FromCards(gc1))
				Duel.Overlay(sc,Group.FromCards(gc1))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
				sc:CompleteProcedure()
			end
	elseif op==1 then
		local g1=Duel.SelectMatchingCard(tp,c65050234.mfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.HintSelection(g1)
		if Duel.Release(g1,REASON_EFFECT)~=0 then
			local g2=Duel.SelectMatchingCard(tp,c65050234.mfilter20,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g2,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
			g2:GetFirst():CompleteProcedure()
		end
	end
end

function c65050234.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050234.confil,1,nil) 
end
function c65050234.confil(c)
   return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsSetCard(0x5da9)
end
function c65050234.thfil(c)
	return c:IsSetCard(0x5da9) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c65050234.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050234.thfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65050234.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c65050234.thfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end