--幻世绘本-自由二页-
function c65020165.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,5,5)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65020165.negcon)
	e1:SetCost(c65020165.negcost)
	e1:SetTarget(c65020165.negtg)
	e1:SetOperation(c65020165.negop)
	c:RegisterEffect(e1)
	--cannot trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65020165.imcon)
	e2:SetOperation(c65020165.actop)
	c:RegisterEffect(e2)
	--books
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c65020165.target2)
	e3:SetOperation(c65020165.activate)
	c:RegisterEffect(e3)
end
function c65020165.negcon(e,tp,eg,ep,ev,re,r,rp)
	local xg=e:GetHandler():GetOverlayGroup()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) and xg:IsExists(Card.IsSetCard,1,nil,0xcda8) and ep~=tp
end
function c65020165.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToGraveAsCost()
end
function c65020165.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	local xg=e:GetHandler():GetOverlayGroup()
	if chk==0 then return xg:IsExists(c65020165.cfilter,1,nil,rtype) end
	local g=xg:FilterSelect(tp,c65020165.cfilter,1,1,nil,rtype)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65020165.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65020165.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


function c65020165.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
function c65020165.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ep==tp then
		Duel.SetChainLimit(c65020165.chainlm)
	end
end
function c65020165.chainlm(e,rp,tp)
	return tp==rp
end

function c65020165.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c65020165.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c65020165.filter2(c,e,tp,mc)
	return c:IsCode(65020163) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and ((Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetMZoneCount(tp,mc,tp)>0 and c:IsLocation(LOCATION_GRAVE)))
end
function c65020165.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c65020165.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65020165,0)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local tc=e:GetHandler()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65020165.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
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