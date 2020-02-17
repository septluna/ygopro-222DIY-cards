--ZEON-吉恩号
local m=11700010
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
 --damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdgcon)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
 --to deck
	local e4=Effect.CreateEffect(c)
   e4:SetCategory(CATEGORY_TODECK)
   e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
   e4:SetCode(EVENT_TO_GRAVE)
   e4:SetCondition(cm.retcon)
   e4:SetTarget(cm.rettg)
   e4:SetOperation(cm.retop)
	c:RegisterEffect(e4)
end
function cm.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	return Duel.IsExistingMatchingCard(cm.spcostfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.spcostfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	local label=0
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) then
		label=label+1
	end
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) then
		label=label+2
	end
	e:SetLabel(label)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=c:GetPreviousAttackOnField()
	local tc2=c:GetFlagEffect(m)
	local tc3=2800-500*tc2
	return e:GetHandler():IsLocation(LOCATION_GRAVE)  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and tc1~=0 and tc3>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:GetFlagEffect(m)<6  then 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
	else
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_GRAVE) and  ((c:GetBaseAttack()>0  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:GetBaseAttack()==0 and c:IsAbleToDeck()))) then return end
	local tc1=c:GetFlagEffect(m)
	if c:IsRelateToEffect(e) then	   
			local tc2=2300-500*tc1
			if tc2<0 then tc2=0 end 
			Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetValue(tc2)
			e2:SetReset(RESET_EVENT+RESET_TEMP_REMOVE+RESET_TODECK+RESET_TOHAND)
			c:RegisterEffect(e2)
		   Duel.SpecialSummonComplete()  
	   c:RegisterFlagEffect(m,RESET_EVENT+RESET_TEMP_REMOVE+RESET_TODECK+RESET_TOHAND,0,0)
	end
end

function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetPreviousAttackOnField()
	return e:GetHandler():IsReason(REASON_BATTLE) and tc==0
		and e:GetHandler():GetPreviousControler()==tp
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end