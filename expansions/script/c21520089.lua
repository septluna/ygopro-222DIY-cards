--始源创造龙
function c21520089.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21520089.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetCode(EFFECT_SPSUMMON_CONDITION)
	e00:SetValue(c21520089.splimit)
	c:RegisterEffect(e00)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c21520089.matcheck)
	c:RegisterEffect(e2)
	--effect
	local e3_8=Effect.CreateEffect(c)
	e3_8:SetDescription(aux.Stringid(21520089,1))
	e3_8:SetCategory(CATEGORY_DRAW)
	e3_8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3_8:SetType(EFFECT_TYPE_IGNITION)
	e3_8:SetRange(LOCATION_MZONE)
	e3_8:SetCountLimit(1)
	e3_8:SetLabel(8)
	e3_8:SetCondition(c21520089.con)
	e3_8:SetTarget(c21520089.tg8)
	e3_8:SetOperation(c21520089.op8)
	c:RegisterEffect(e3_8)
	local e3_12=e3_8:Clone()
	e3_12:SetDescription(aux.Stringid(21520089,2))
	e3_12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3_12:SetLabel(12)
	e3_12:SetTarget(c21520089.tg12)
	e3_12:SetOperation(c21520089.op12)
	c:RegisterEffect(e3_12)
	local e3_16=e3_8:Clone()
	e3_16:SetDescription(aux.Stringid(21520089,3))
	e3_16:SetCategory(CATEGORY_SEARCH)
	e3_16:SetProperty(0)
	e3_16:SetLabel(16)
	e3_16:SetTarget(c21520089.tg16)
	e3_16:SetOperation(c21520089.op16)
	c:RegisterEffect(e3_16)
	local e3_20=e3_8:Clone()
	e3_20:SetDescription(aux.Stringid(21520089,4))
	e3_20:SetCategory(0)
	e3_20:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CARD_TARGET)
	e3_20:SetLabel(20)
	e3_20:SetTarget(c21520089.tg20)
	e3_20:SetOperation(c21520089.op20)
	c:RegisterEffect(e3_20)
end
function c21520089.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520089.ffilter(c,fc,sub,mg,sg)
	return c:IsCanBeFusionMaterial() and c:IsRace(RACE_DRAGON) and (not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsLevel,1,c,c:GetLevel())))
end
function c21520089.matcheck(e,c)
	local mg=c:GetMaterial()
	local val=0
	for tc in aux.Next(mg) do 
		val=val+tc:GetLevel()
	end
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_SET_BASE_ATTACK)
	ae:SetValue(val*250)
	ae:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(de)
	local ct=math.floor((val/4)-1)
	if ct>4 then ct=4 end
	for i=1,ct do 
		c:RegisterFlagEffect(21520089,RESET_EVENT+0xfe0000,0,1)
	end
end
function c21520089.con(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local ct=e:GetHandler():GetFlagEffect(21520089)
	local val=4*(ct+1)
	return val>=label
end
function c21520089.tg8(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21520089.op8(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c21520089.filter12(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c21520089.tg12(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c21520089.filter12(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21520089.filter12,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520089.filter12,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21520089.op12(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21520089.filter16(c,tpe)
	return c:IsAbleToHand() and c:IsType(tpe)
end
function c21520089.tg16(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	e:SetLabel(res)
end
function c21520089.op16(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	local res=e:GetLabel()
	Duel.ConfirmDecktop(tp,3)
	if res==0 and g:FilterCount(c21520089.filter16,nil,TYPE_MONSTER)>0 then 
		local sg=g:Filter(c21520089.filter16,nil,TYPE_MONSTER)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	elseif res==1 and g:FilterCount(c21520089.filter16,nil,TYPE_SPELL)>0 then 
		local sg=g:Filter(c21520089.filter16,nil,TYPE_SPELL)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	elseif res==2 and g:FilterCount(c21520089.filter16,nil,TYPE_TRAP)>0 then 
		local sg=g:Filter(c21520089.filter16,nil,TYPE_TRAP)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end
function c21520089.chlimit(e,ep,tp)
	return tp==ep
end
function c21520089.tg20(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetChainLimit(c21520089.chlimit)
end
function c21520089.op20(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
