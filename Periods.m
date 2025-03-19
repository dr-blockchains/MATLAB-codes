clear; clc;

years = 80; nT = 40;
maxX = 100; maxY = 120;

ownerCost = 100; motelCost = 400;
maxPrice = 500; minPrice = 0;
span = 10;

housing = 120;

nTenant = 3000;

Distance = ones(maxX,1)*(1:maxY) + rand(maxX,maxY)*maxPrice/100000;
Pricing = rand(maxX,maxY)*(maxPrice-minPrice) + minPrice;

RentPeriod = randi(nT,1,nTenant);

PricePlot = zeros(years,maxY);

Film(1:years) = struct('cdata', [],'colormap', []);

for year =1:years    
    
    Profit = zeros(maxX,maxY);
    TenantCost = ones(1, nTenant)*motelCost;
    Price = zeros(maxX,maxY);    
    PricePlot(year,:)=Pricing(1,:);
    
    
    for t=1:nT
                
        Sold = (Price>=Inf);
        Price = squeeze(Pricing(:,:));        
        Price(Sold) = Inf;
        
        Customer=find(RentPeriod==t);
        
        for i = Customer(randperm(length(Customer)))
            
            Area = randperm(maxX*maxY,housing);
            [minCost, bestInArea]= min(Price(Area)+Distance(Area));            
            bestHouse = Area(bestInArea);
            
            if minCost>=motelCost
                display('prefers to live in a motel');
                break;
            end
            
            Profit(bestHouse)= Price(bestHouse) - ownerCost;
            TenantCost(i) = minCost;
            Price (bestHouse) = Inf;           
            
        end    
    end
    
    figure(2);
    plot(RentPeriod,TenantCost,'.');
    Film(year)=getframe;    
    pause;

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
        
        %Pricing(1,xB,y);
        %Pricing(1,xA,y);       
        %Pricing(1,bestX,bestY);
        %bestPrice
        
        Selection = randperm(maxX-2,floor(maxX/2));
        nLosers = length(Selection);
        Pricing(Losers(Selection),y) = Pricing(bestX,bestY) + randn(nLosers,1);       
        
    end
    
    [year mean(mean(Profit))]
end

movie(Film);

figure(3);
plot(PricePlot);