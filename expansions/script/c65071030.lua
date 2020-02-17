--谐奏放射器
function c65071030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,65071030+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65071030.cost)
	e1:SetTarget(c65071030.target)
	e1:SetOperation(c65071030.operation)
	c:RegisterEffect(e1)
end
function c65071030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,200) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,12000)/200)
	local t={}
	for i=1,m do
		t[i]=i*200
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
end
function c65071030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct/2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,0)
end

function c65071030.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(65071030,0)) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	else
		local sg=Duel.GetMatchingGroup(c65071030.tgfil,0,LOCATION_MZONE,e:GetLabel())
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

function c65071030.tgfil(c,ct)
	return c:GetAttack()<=ct/2 and c:IsFaceup()
end
