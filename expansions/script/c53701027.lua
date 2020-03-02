--惧 轮 急 转
function c53701027.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53701027)
	e1:SetTarget(c53701027.sptg)
	e1:SetOperation(c53701027.spop)
	c:RegisterEffect(e1)
	--link rating
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,537010270)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c53701027.lktg)
	e4:SetOperation(c53701027.lkop)
	c:RegisterEffect(e4)
end
function c53701027.spfilter(c,e,tp)
	return c:IsSetCard(0x530) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53701027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53701027.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c53701027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c53701027.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>=5 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c53701027.lkfilter(c)
	return c:IsSetCard(0x530) and c:IsType(TYPE_LINK)
end
function c53701027.lktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c53701027.lkfilter(chkc) end
	local b1=Duel.IsExistingMatchingCard(c53701027.lkfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c53701027.lkfilter,tp,LOCATION_MZONE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c53701027.lkfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c53701027.lkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(53701027,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(53701027,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(53701027,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
end
function c53701027.lkop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if sel==1 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetValue(LINK_MARKER_BOTTOM_LEFT)
		tc:RegisterEffect(e2)
	elseif sel==2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetValue(LINK_MARKER_BOTTOM)
		tc:RegisterEffect(e2)
	else
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetValue(LINK_MARKER_BOTTOM_RIGHT)
		tc:RegisterEffect(e2)
	end
end
