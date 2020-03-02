--终末破灭龙
function c21520090.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21520090.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetCode(EFFECT_SPSUMMON_CONDITION)
	e00:SetValue(c21520090.splimit)
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
	e2:SetValue(c21520090.matcheck)
	c:RegisterEffect(e2)
	--effect
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetDescription(aux.Stringid(21520090,1))
	e3_1:SetCategory(CATEGORY_REMOVE)
	e3_1:SetType(EFFECT_TYPE_IGNITION)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetCountLimit(1)
	e3_1:SetLabel(12)
	e3_1:SetCondition(c21520090.con)
	e3_1:SetTarget(c21520090.tg1)
	e3_1:SetOperation(c21520090.op1)
	c:RegisterEffect(e3_1)
	local e3_2=e3_1:Clone()
	e3_2:SetDescription(aux.Stringid(21520090,2))
	e3_2:SetLabel(16)
	e3_2:SetTarget(c21520090.tg2)
	e3_2:SetOperation(c21520090.op2)
	c:RegisterEffect(e3_2)
	local e3_3=e3_1:Clone()
	e3_3:SetDescription(aux.Stringid(21520090,3))
	e3_3:SetLabel(20)
	e3_3:SetTarget(c21520090.tg3)
	e3_3:SetOperation(c21520090.op3)
	c:RegisterEffect(e3_3)
	local e3_4=e3_1:Clone()
	e3_4:SetDescription(aux.Stringid(21520090,4))
	e3_4:SetLabel(24)
	e3_4:SetTarget(c21520090.tg4)
	e3_4:SetOperation(c21520090.op4)
	c:RegisterEffect(e3_4)
end
function c21520090.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520090.ffilter(c,fc,sub,mg,sg)
	return c:IsCanBeFusionMaterial() and c:IsRace(RACE_DRAGON) and (not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsLevel,1,c,c:GetLevel())))
end
function c21520090.matcheck(e,c)
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
	local ct=math.floor((val-8)/4)
	if ct>4 then ct=4 end
	for i=1,ct do 
		c:RegisterFlagEffect(21520090,RESET_EVENT+0xfe0000,0,1)
	end
end
function c21520090.con(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local ct=e:GetHandler():GetFlagEffect(21520090)
	local val=4*ct+8
	return val>=label
end
function c21520090.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520090.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,4,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c21520090.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520090.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,3,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c21520090.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520090.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct==0 then return end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 then ct=2 end
	local sg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c21520090.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520090.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()<=0 then return end
	local sg=g:RandomSelect(tp,1)
--	Duel.HintSelection(sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
