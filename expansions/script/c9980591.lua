--降临卡片·黑翼重剑
function c9980591.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9980591.target)
	e1:SetOperation(c9980591.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c9980591.eqlimit)
	c:RegisterEffect(e2)
	--atk/def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(800)
	c:RegisterEffect(e4)
	--discard
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9980591,0))
	e5:SetCategory(CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,9980591)
	e5:SetCondition(c9980591.descon)
	e5:SetTarget(c9980591.destg)
	e5:SetOperation(c9980591.desop)
	c:RegisterEffect(e5)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetDescription(aux.Stringid(9980591,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c9980591.eqcondtion)
	e4:SetTarget(c9980591.eqtarget)
	e4:SetOperation(c9980591.operation)
	c:RegisterEffect(e4)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980591,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9980591.tdcon)
	e2:SetTarget(c9980591.tdtg)
	e2:SetOperation(c9980591.tdop)
	c:RegisterEffect(e2)
	 --no damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c9980591.damcon)
	e4:SetOperation(c9980591.damop)
	c:RegisterEffect(e4)
end
function c9980591.eqlimit(e,c)
	return c:IsSetCard(0x6bca)
end
function c9980591.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbca)
end
function c9980591.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9980591.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980591.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9980591.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9980591.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9980591.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsContains(ec)
end
function c9980591.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c9980591.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c9980591.eqcondtion(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL) 
end
function c9980591.eqtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c9980591.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9980591.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9980591.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9980591.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bca)
end
function c9980591.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c9980591.rccfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c9980591.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9980591.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c9980591.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ep==tp and (Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec)
end
function c9980591.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
