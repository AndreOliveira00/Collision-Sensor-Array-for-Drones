clear;
%close ('all');
clear

%LIDAR=load('Logs\Log_parede2.txt');                  % Motor em movimento com frequencia de 10 Hz para parede 
%LIDAR=load('Logs\Log_parede.txt');                  % Motor em movimento com frequencia de 10 Hz para parede 
%LIDAR=load('Logs\Log_parede_lim_11hz.txt');         % Limite frequencia leitura com motor em movimento
%LIDAR=load('Logs\Log_teste_freq125.txt');           % Log LiDAR 125 Hz, motor parado 

t=LIDAR(:,3);
Intensidade=LIDAR(:,4);
LaserAng=LIDAR(:,2);
Range=LIDAR(:,1);


for i=1:length(Range)
    if Range(i)>400
        disp(i)
        Range(i)=0;
        Intensidade(i)=0;
    end
end


thetas=LaserAng*(2*pi/4096);
thetas_deg=thetas*180/pi;

Lx= cos(thetas).*Range;
Ly= sin(thetas).*Range;

dt = diff(t); 
%dt2 = diff(t);
%dt=dt2-2;

figure ('name','Histograma dist�ncias medidas')
histogram(Range);
title('Histograma dist�ncias medidas')
xlabel('Dist�ncia medida (cm)') 
ylabel('N� de leituras') 

figure ('name','Histograma tempo aquisi��o de dados')
title('Histograma \Deltat aquisi��o de dados')
hold on;
histogram(dt);
xlabel('Tempo (ms)') 
ylabel('N� de leituras') 

figure('name','Representa��o 2D do cen�rio')
title('Representa��o 2D do cen�rio')
hold on;
plot(-Lx,Ly,'.','Color','#0072BD')
scatter(0, 0,'+', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
title('Representa��o 2D do cen�rio')
xlabel('Dist�ncia em x (cm)') 
ylabel('Dist�ncia em y (cm)') 
