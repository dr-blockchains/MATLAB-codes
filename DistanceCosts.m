clear;clc;

years = 80; 
maxX = 100; maxY = 120;

ownerCost = 100; motelCost = 400;
maxPrice = 500; minPrice = 0;
span = 10;

nTenant = 5000;

Distance = ones(maxX,1)*(1:maxY) + rand(maxX,maxY)*maxPrice/100000;
Pricing = rand(maxX,maxY)*(maxPrice-minPrice) + minPrice;

PricePlot = zeros(years,maxY);

for year =1:years
    
    Profit = zeros(maxX,maxY); 
    TenantCost = ones(1,nTenant)*motelCost;
    Price = Pricing;
    PricePlot(year,:)=Pricing(1,:);

    for i = randperm(nTenant)
        [minCost, bestHouse]= min(Price(:)+Distance(:));
        if minCost>=motelCost 
            display('prefers to live in a motel');
            break;
        end
        Profit(bestHouse)= Price(bestHouse) - ownerCost;
        TenantCost(i) = minCost;    
        Price (bestHouse) = Inf;    
    end

    [MaxProfits, Winners] = max(Profit);        
    [maxMax, yWinner] = max(MaxProfits);
    bestPrice = Pricing(Winners(yWinner),yWinner);

    for y = randperm(maxY)
        
        Ys = max(y-span,1):min(y+span,maxY);
        [localMax, winner] = max(MaxProfits(Ys));
        bestY = Ys(winner);
        bestX = Winners(bestY);                        
        
        xA=Winners(y);
        Losers = 1:maxX;
        Losers(xA)=[];               
        [nextMax, xinL]=max(Profit(Losers,y));
        xB=Losers(xinL);        
        Losers(xinL)=[];
        
        %Pricing(xB,y);
        %Pricing(xA,y);       
        %Pricing(bestX,bestY);
        %bestPrice
        
        Selection = randperm(maxX-2,floor(maxX/5));
        nLosers = length(Selection);
        Pricing(Losers(Selection),y)=  Pricing(bestX,bestY) + randn(nLosers,1);      
        
    end
    [year mean(mean(Profit))]
end

plot(PricePlot);