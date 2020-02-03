--End Time
function c26807008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c26807008.target)
	e1:SetOperation(c26807008.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c26807008.actcon)
	c:RegisterEffect(e2)
end
function c26807008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rac=0
		local crac=1
		while bit.band(RACE_ALL,crac)~=0 do
			local catt=1
			for iatt=0,7 do
				if Duel.IsPlayerCanSpecialSummonMonster(tp,26807008,0,0x11,2200,600,6,crac,catt) then
					rac=rac+crac
					break
				end
				catt=catt*2
			end
			crac=crac*2
		end
		e:SetLabel(rac)
		return rac~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local crac=Duel.AnnounceRace(tp,1,e:GetLabel())
	local att=0
	local catt=1
	for iatt=0,7 do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,26807008,0,0x11,2200,600,6,crac,catt) then
			att=att+catt
		end
		catt=catt*2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	catt=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(crac)
	Duel.SetTargetParam(catt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26807008.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rac=e:GetLabel()
	local att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,26807008,0,0x11,2200,600,6,rac,att) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,att,rac,0,0,0)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c26807008.cfilter(c)
	return c:IsFaceup() and c:IsAttack(2200) and c:IsDefense(600)
end
function c26807008.actcon(e,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g>0 and g:FilterCount(c26807008.cfilter,nil)==#g
end
