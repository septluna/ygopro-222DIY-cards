--战斗模式·白上吹雪
function c81008007.initial_effect(c)
	c:EnableReviveLimit()
	--change level
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c81008007.lvcon)
	e0:SetValue(2)
	c:RegisterEffect(e0)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c81008007.synlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,81008007)
	e2:SetCondition(c81008007.thcon)
	e2:SetTarget(c81008007.sptg)
	e2:SetOperation(c81008007.spop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c81008007.sumcon)
	e3:SetOperation(c81008007.sumsuc)
	c:RegisterEffect(e3)
end
function c81008007.synlimit(e,c)
	return bit.band(c:GetType(),0x81)==0x81
end
function c81008007.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81c) and not c:IsCode(81008007)
end
function c81008007.lvcon(e)
	return Duel.IsExistingMatchingCard(c81008007.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c81008007.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81008007.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81c)
end
function c81008007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81008007.damfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local ct=Duel.GetMatchingGroupCount(c81008007.damfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c81008007.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c81008007.damfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Damage(p,ct*300,REASON_EFFECT)
end
function c81008007.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81008007.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81008007,0))
end
