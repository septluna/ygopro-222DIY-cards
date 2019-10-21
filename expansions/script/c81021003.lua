--佐城雪美的蓝色时间
function c81021003.initial_effect(c)
	c:EnableCounterPermit(0x818)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetCondition(c81021003.ctcon)
	e2:SetOperation(c81021003.ctop)
	c:RegisterEffect(e2)
	--lpcost replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81021003,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_LPCOST_REPLACE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81021003.lrcon)
	e3:SetOperation(c81021003.lrop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c81021003.recp)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,81021003)
	e5:SetCondition(c81021003.reccon)
	e5:SetTarget(c81021003.rectg)
	e5:SetOperation(c81021003.recop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c81021003.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c81021003.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x818,1)
end
function c81021003.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	local lp=Duel.GetLP(ep)
	if lp<ev then return false end
	if not re or not re:IsHasType(0x7e0) then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x818) and (rc:IsLocation(LOCATION_MZONE) or rc:IsLocation(LOCATION_PZONE)) and e:GetHandler():GetCounter(0x818)>0
end
function c81021003.lrop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x818,1,REASON_EFFECT)
end
function c81021003.recp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x818)
	e:SetLabel(ct)
end
function c81021003.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_FZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c81021003.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*800)
end
function c81021003.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
