clear; clc;
%% Initialization:

years = 200; nT = 40;
maxX = 100; maxY = 120;

ownerCost = 100; motelCost = 400;
maxPrice = 500; minPrice = 0;
span = 10;

nHouse = 2;

nTenant = 6000;

Distance = ones(maxX,1)*(1:maxY) + rand(maxX,maxY)*maxPrice/100000;
Pricing = rand(nT,maxX,maxY)*(maxPrice-minPrice) + minPrice;
RentPeriod = sort(randi(nT,2,nTenant));
PricePlot = zeros(years,maxY);

%% Simulation
for year =1:years    
 
    %% Restart at the begining of the year: 
    Profit = zeros(maxX,maxY);
    TenantCost = ones(1, nTenant)*motelCost;
    Price = zeros(maxX,maxY);    
    PricePlot(year,:)=squeeze(Pricing(1,1,:));
    
    BestFound = zeros(nTenant,nT);
 
    %% Periods during the year:
    for t=1:nT
                
        Sold = (Price>=Inf);
        Price = squeeze(Pricing(1,:,:));        
        Price(Sold) = Inf;
        
        %% Searching houses by customers:        
        for i = find(RentPeriod(1,:)<=t & t<RentPeriod(2,:))
            Area = randperm(maxX*maxY,nHouse);
            [~, bestInArea]= min(Price(Area)+Distance(Area));
            BestFound(i,t) = Area(bestInArea);            
        end    
        
        %% Renting
        Customer=find(RentPeriod(2,:)==t);        
        for i = Customer(randperm(length(Customer)))
            
            Area = randperm(maxX*maxY,nHouse);
            [~, bestInArea]= min(Price(Area)+Distance(Area));
            BestFound(i,t) = Area(bestInArea);            
            
            Besti = BestFound(i,RentPeriod(1,i):t);
            [minCost, bestInBest]= min(Price(Besti)+Distance(Besti));
            bestHouse = Besti(bestInBest);
            
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
    plot(RentPeriod,[TenantCost ; TenantCost]);
    axis([0 nT 0 maxPrice]);
    Film(year)=getframe;    
    
    %% Tenants evolve:
    [~,bestA] = min(TenantCost);
    BestPeriod = RentPeriod(:,bestA);    
    TenantCost(bestA)=Inf;    
    [~,bestB] = min(TenantCost);   
    
    RentPeriod(:,randperm(nTenant,floor(nTenant/2))) = sort(max(RentPeriod(:,bestB)*ones(1,nTenant/2) + randi(3,2,nTenant/2)-2,1),1) ;                        
    RentPeriod(:,randperm(nTenant,floor(nTenant/2))) = sort(max(BestPeriod*ones(1,nTenant/2) + randi(3,2,nTenant/2)-2,1),1) ;    
    
    %% Landlords evolve:
    [MaxProfits, Winners] = max(Profit);        
    [~, yWinner] = max(MaxProfits);
    bestPrice = Pricing(1,Winners(yWinner),yWinner);
        
    for y = randperm(maxY)
        
        Ys = max(y-span,1):min(y+span,maxY);
        [~, winner] = max(MaxProfits(Ys));
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
        Pricing(1,Losers(Selection),y) = Pricing(1,bestX,bestY) + randn(nLosers,1);               
    end
    
    [year mean(mean(Profit))]
end

figure(3);
plot(PricePlot);
movie(Film);
movie2avi(Film,'Co-evolution.avi');