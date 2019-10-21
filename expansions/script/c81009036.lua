--小小女仆·赤城米莉亚
function c81009036.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81009036.splimit)
	c:RegisterEffect(e1)
end
function c81009036.splimit(e,se,sp,st)
	local ph=Duel.GetCurrentPhase()
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and Duel.GetActivityCount(e:GetHandlerPlayer(),ACTIVITY_SPSUMMON)==0
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
