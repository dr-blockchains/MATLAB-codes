clear;clc;

years = 80; 
maxX = 100; maxY = 120;

ownerCost = 100; motelCost = 400;
maxPrice = 500; minPrice = 0;

nTenant = 3800;

Distance = rand(maxX,maxY)*maxPrice/100000;
Pricing = rand(maxX,maxY)*(maxPrice-minPrice) + minPrice;

PricePlot = zeros(years,maxY);

for year =1:years    
    %n=n+50;
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
        
        xA=Winners(y);
        Losers = 1:maxX;
        Losers(xA)=[];               
        [nextMax, xinL]=max(Profit(Losers,y));
        xB=Losers(xinL);        
        Losers(xinL)=[];
        
        %Pricing(xB,y);
        %Pricing(xA,Y);       
                        
        Selection = randperm(maxX-2,ceil(maxX/2));
        Pricing(Losers(Selection),y)=  bestPrice + 4*randn(length(Selection),1);       
        
    end
    [year mean(mean(Profit))]
end

plot(PricePlot);