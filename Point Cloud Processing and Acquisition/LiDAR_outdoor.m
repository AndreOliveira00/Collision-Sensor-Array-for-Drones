clear;
close ('all');
clear

LIDAR=load('Logs\Log_outdoor.txt');            

t=LIDAR(:,3);
Intensidade=LIDAR(:,4);
LaserAng=LIDAR(:,2);
Range=LIDAR(:,1);


for i=1:length(Range)
    if Range(i)>400
        %disp(i)
        Range(i)=0;
        Intensidade(i)=0;
    end
end


LaserAng_Set1=LIDAR(58:285,2);
Range_Set1=Range(58:285);
LaserAng_Set2=LIDAR(286:513,2);
Range_Set2=Range(286:513);
LaserAng_Set3=LIDAR(514:741,2);
Range_Set3=Range(514:741);
LaserAng_Set4=LIDAR(742:969,2);
Range_Set4=Range(742:969);
LaserAng_Set5=LIDAR(970:1197,2);
Range_Set5=Range(970:1197);
LaserAng_Set6=LIDAR(1198:1425,2);
Range_Set6=Range(1198:1425);

Intensidade_Set1=LIDAR(58:285,2);
Intensidade_Set2=LIDAR(286:513,2);
Intensidade_Set3=LIDAR(514:741,2);
Intensidade_Set4=LIDAR(742:969,2);
Intensidade_Set5=LIDAR(970:1197,2);
Intensidade_Set6=LIDAR(1198:1425,2);

LaserAng_Set = [LaserAng_Set1,LaserAng_Set2,LaserAng_Set3,LaserAng_Set4,LaserAng_Set5,LaserAng_Set6];
Range_Set = [Range_Set1,Range_Set2,Range_Set3,Range_Set4,Range_Set5,Range_Set6];
Intensidade_Set = [Intensidade_Set1,Intensidade_Set2,Intensidade_Set3,Intensidade_Set4,Intensidade_Set5,Intensidade_Set6];

thetas=LaserAng*(2*pi/4096);
thetas_deg=thetas*180/pi;

thetas_set=LaserAng_Set*(2*pi/4096);
thetas_deg_set=thetas_set*180/pi;

Lx= cos(thetas).*Range;
Ly= sin(thetas).*Range;
Lx_set= cos(thetas_set).*Range_Set;
Ly_set= sin(thetas_set).*Range_Set;

% FILTRO INICIO
[numRows,numCols] = size(Range_Set);
zero_detect=0;
soma=0;
cnt=0;
for i=1:length(LaserAng_Set1)
   for j=1:numCols
       if ((Ly_set(i,j)==0))
            zero_detect=1;
            %disp(i);
            %disp(j);
       else
           %cnt=j;
           cnt=cnt+1;
           soma=soma+Ly_set(i,j);
       end
   end
   if (zero_detect==1)
        zero_detect=0;
        %disp(cnt)
        %disp(soma)
        if (cnt~=0)
            value=soma/cnt;
            for j=1:numCols
                Ly_set(i,j)=value;
                %Ly_set(i,j)=Ly_set(i,cnt);
            end
        end
   end
   soma=0;
   cnt=0;
end

zero_detect=0;
soma=0;
cnt=0;
for i=1:length(LaserAng_Set1)
   for j=1:numCols
       if ((Lx_set(i,j)==0))
            zero_detect=1;
            %disp(i);
            %disp(j);
       else
           %cnt=j;
           cnt=cnt+1;
           soma=soma+Lx_set(i,j);
       end
   end
   if (zero_detect==1)
        zero_detect=0;
        %disp(cnt)
        %disp(soma)
        if (cnt~=0)
            value=soma/cnt;
            for j=1:numCols
                Lx_set(i,j)=value;
                %Lx_set(i,j)=Lx_set(i,cnt);
            end
        end
   end
   soma=0;
   cnt=0;
end

zero_detect=0;
soma=0;
cnt=0;
for i=1:length(LaserAng_Set1)
   for j=1:numCols
       if ((Range_Set(i,j)==0))
            zero_detect=1;
            %disp(i);
            %disp(j);
       else
           %cnt=j;
           cnt=cnt+1;
           soma=soma+Range_Set(i,j);
       end
   end
   if (zero_detect==1)
        zero_detect=0;
        %disp(cnt)
        %disp(soma)
        if (cnt~=0)
            value=soma/cnt;
            for j=1:numCols
                Range_Set(i,j)=value;
                %Range_Set(i,j)=Range_Set(i,cnt);
            end
        end
   end
   soma=0;
   cnt=0;
end

% FILTRO FIM

dt = diff(t); 

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

figure('name','Representa��o 2D do cen�rio (valores m�dios)')
hold on;
plot(-mean(Lx_set,2),mean(Ly_set,2),'.','Color','#0072BD')
scatter(0, 0,'+', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
title('Representa��o 2D do cen�rio (valores m�dios)')
xlabel('Dist�ncia em x (cm)') 
ylabel('Dist�ncia em y (cm)') 

% Ranges no scan
figure('name','Dados adquiridos (dist�ncia para cada �ngulo)')
plot(thetas_deg,Range','.','Color','#A2142F')
title('Dados adquiridos (dist�ncia para cada �ngulo)')
xlabel('Angulo (�)') 
ylabel('Dist�ncia (cm)') 

figure('name','M�dia dados adquiridos (dist�ncia para cada �ngulo)')
plot(thetas_deg_set,mean(Range_Set,2),'.','Color','#A2142F')
title('M�dia dados adquiridos (dist�ncia para cada �ngulo)')
xlabel('�ngulo (�)') 
ylabel('Dist�ncia (cm)') 


% Ranges standard deviation
figure ('name','Gr�fico Evolutivo do Desvio Padr�o')
plot(thetas_deg_set(1:114,1:end),std(Range_Set(1:114,1:end),[],2),'Color','#EDB120')
title('Gr�fico Evolutivo do Desvio Padr�o')
xlabel('�ngulo (�)') 
ylabel('Desvio padr�o da medi��o (cm)') 

% Intensidades
figure('name','Dados adquiridos (intensidade para cada �ngulo)')
plot(thetas_deg,Intensidade','.','Color','#D95319')
title('Dados adquiridos (intensidade para cada �ngulo)')
xlabel('Angulo (�)') 
ylabel('Intensidade (u.m.)') 




