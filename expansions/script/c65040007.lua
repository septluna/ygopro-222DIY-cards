--黯食偶像 希斯托所曼
function c65040007.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c65040007.sprcon)
	e1:SetOperation(c65040007.sprop)
	c:RegisterEffect(e1)
	 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65040007.recon)
	e2:SetCost(c65040007.recost)
	e2:SetTarget(c65040007.retg)
	e2:SetOperation(c65040007.reop)
	c:RegisterEffect(e2)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65040007.bccon)
	e3:SetTarget(c65040007.bctg)
	e3:SetOperation(c65040007.bcop)
	c:RegisterEffect(e3)
	--reg
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c65040007.regop)
	c:RegisterEffect(e4)
end
function c65040007.sprfilter(c)
	return c:IsSetCard(0x3da3) and c:IsReleasable()
end
function c65040007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c65040007.sprfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c65040007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c65040007.sprfilter,tp,LOCATION_MZONE,0,3,3,nil)
	Duel.Release(g,REASON_COST)
end
function c65040007.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) 
end
function c65040007.cfilter2(c,ft)
	return c:IsSetCard(0x3da3) and c:IsReleasable() and (ft>0 or (ft<=0 and c:IsLocation(LOCATION_MZONE)))
end
function c65040007.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local num=e:GetHandler():GetFlagEffect(65040007)+1
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c65040007.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,num,e:GetHandler(),ft) end
	local sg=Duel.SelectMatchingCard(tp,c65040007.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,num,num,e:GetHandler(),ft)
	Duel.Release(sg,REASON_COST)
	e:GetHandler():RegisterFlagEffect(65040007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65040007,2))
end

function c65040007.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c65040007.reop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		Duel.Remove(ec,POS_FACEUP,REASON_EFFECT)
	end
end

function c65040007.bccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(65040007)==0
end

function c65040007.bctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c65040007.bcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)~=0 then
			local life=Duel.GetLP(tp)
			Duel.SetLP(tp,life-1500)
		end
	end
end

function c65040007.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END then
	e:GetHandler():RegisterFlagEffect(65040007,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	end
end
