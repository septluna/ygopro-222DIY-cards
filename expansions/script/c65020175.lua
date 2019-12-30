--幻世绘本页-惊吓-
function c65020175.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65020175,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65020175)
	e1:SetCondition(c65020175.condition)
	e1:SetCost(c65020175.cost)
	e1:SetTarget(c65020175.target)
	e1:SetOperation(c65020175.activate)
	c:RegisterEffect(e1)
	 --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,65020176)
	e2:SetTarget(c65020175.tg)
	e2:SetOperation(c65020175.op)
	c:RegisterEffect(e2)
end
function c65020175.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c65020175.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c65020175.filter2(c,e,tp,mc)
	return c:IsCode(65020163) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and ((Duel.GetLocationCountFromEx(tp,tp,mc)>0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetMZoneCount(tp,mc,tp)>0 and c:IsLocation(LOCATION_GRAVE)))
end
function c65020175.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65020175.filter1(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65020175.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():GetPreviousLocation()==LOCATION_OVERLAY end
	local g=Duel.SelectTarget(tp,c65020175.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c65020175.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if ((Duel.GetLocationCountFromEx(tp,tp,tc)<=0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetMZoneCount(tp,tc,tp)<=0 and c:IsLocation(LOCATION_GRAVE))) or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65020175.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
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
	end
end

function c65020175.acfil(c)
	return c:IsSetCard(0xcda8) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c65020175.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and Duel.IsExistingMatchingCard(c65020175.acfil,tp,LOCATION_MZONE,0,1,nil) and ep~=tp
end
function c65020175.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cc=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):GetFirst()
	local xgc=cc:GetOverlayCount()
	if chk==0 then return cc:CheckRemoveOverlayCard(tp,xgc,REASON_COST) end
	local xg=cc:GetOverlayGroup()
	local num=Duel.SendtoGrave(xg,REASON_COST)
	e:SetLabel(num)
end
function c65020175.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	end
end
function c65020175.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,e:GetLabel(),nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
