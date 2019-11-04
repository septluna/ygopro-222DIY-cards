--幼小的影子 米恩
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rsof.DefineCard(33330094)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"des,sp",nil,rstg.target(Card.IsFaceup,"des",LOCATION_MZONE,LOCATION_MZONE),cm.desop)
	local e2=rsef.QO(c,nil,{m,1},nil,"sp",nil,LOCATION_GRAVE,nil,rscost.cost(Card.IsAbleToDeckAsCost,"td"),rsop.target(cm.spfilter,"sp",LOCATION_EXTRA),cm.spop)
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.Destroy(tc,REASON_EFFECT)<=0 then return end
	if Duel.IsExistingMatchingCard(rscf.spfilter2(Card.IsCode,tc:GetCode()),LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		rsof.SelectHint(tp,"sp")
		local sg=Duel.SelectMatchingCard(tp,rscf.spfilter2(Card.IsCode,tc:GetCode()),tp,LOCATION_DECK,0,1,1,nil,e,tp)
		rssf.SpecialSummon(sg)
	end
end
function cm.matfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsLevelBelow(2)
end
function cm.spfilter(c,e,tp)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_GRAVE,0,nil)
	return #mg>=2 and mg:CheckSubGroup(cm.spfilter2,2,2,c)
end
function cm.spfilter2(matg,lc)
	return matg:GetClassCount(Card.GetCode)==1 and lc:IsLinkSummonable(matg,nil,2,2)
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local lc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not lc then return end
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_GRAVE,0,nil)
	rsof.SelectHint(tp,"td")
	local matg=mg:SelectSubGroup(tp,cm.spfilter2,false,2,2,lc)
	rssf.LinkMaterialAction=cm.customlk
	Duel.LinkSummon(tp,lc,matg,nil,2,2)
end
function cm.customlk(mg,c,e,tp)
	Duel.SendtoDeck(mg,nil,2,REASON_COST+REASON_MATERIAL+REASON_LINK)
end