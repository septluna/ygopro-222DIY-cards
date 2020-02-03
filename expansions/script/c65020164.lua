--幻世绘本-默语一页-
function c65020164.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,4)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65020164.imcon)
	e1:SetValue(c65020164.efilter)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c65020164.atkcon)
	e2:SetCost(c65020164.atkcost)
	e2:SetTarget(c65020164.atktg)
	e2:SetOperation(c65020164.atkop)
	c:RegisterEffect(e2)
	--books
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65020164.con2)
	e3:SetTarget(c65020164.target2)
	e3:SetOperation(c65020164.activate)
	c:RegisterEffect(e3)
end
function c65020164.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
function c65020164.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end

function c65020164.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function c65020164.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65020164.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65020164.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function c65020164.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c65020164.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c65020164.filter2(c,e,tp,mc)
	return c:IsCode(65020163) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and ((Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetMZoneCount(tp,mc,tp)>0 and c:IsLocation(LOCATION_GRAVE)))
end
function c65020164.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65020164.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c65020164.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65020164,0)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local tc=e:GetHandler()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65020164.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
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
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end