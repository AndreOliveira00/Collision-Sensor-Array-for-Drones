clear;
close ('all');
clear

LIDAR=load('Logs\Log_indoor.txt'); 

t=LIDAR(:,3);
Intensidade=LIDAR(:,4);
LaserAng=LIDAR(:,2);
Range=LIDAR(:,1);


for i=1:length(Range)
    if Range(i)>500
        %disp(i)
        Range(i)=0;
        Intensidade(i)=0;
    end
end


LaserAng_Set1=LIDAR(87:428,2);
Range_Set1=Range(87:428);
LaserAng_Set2=LIDAR(429:770,2);
Range_Set2=Range(429:770);
LaserAng_Set3=LIDAR(771:1112,2);
Range_Set3=Range(771:1112);
LaserAng_Set4=LIDAR(1113:1454,2);
Range_Set4=Range(1113:1454);
LaserAng_Set5=LIDAR(1455:1796,2);
Range_Set5=Range(1455:1796);
LaserAng_Set6=LIDAR(1797:2138,2);
Range_Set6=Range(1797:2138);
LaserAng_Set7=LIDAR(2139:2480,2);
Range_Set7=Range(2139:2480);
LaserAng_Set8=LIDAR(2481:2822,2);
Range_Set8=Range(2481:2822);
LaserAng_Set9=LIDAR(2823:3164,2);
Range_Set9=Range(2823:3164);
LaserAng_Set10=LIDAR(3165:3506,2);
Range_Set10=Range(3165:3506);

Intensidade_Set1=LIDAR(87:428,2);
Intensidade_Set2=LIDAR(429:770,2);
Intensidade_Set3=LIDAR(771:1112,2);
Intensidade_Set4=LIDAR(1113:1454,2);
Intensidade_Set5=LIDAR(1455:1796,2);
Intensidade_Set6=LIDAR(1797:2138,2);
Intensidade_Set7=LIDAR(2139:2480,2);
Intensidade_Set8=LIDAR(2481:2822,2);
Intensidade_Set9=LIDAR(2823:3164,2);
Intensidade_Set10=LIDAR(3165:3506,2);


LaserAng_Set = [LaserAng_Set1,LaserAng_Set2,LaserAng_Set3,LaserAng_Set4,LaserAng_Set5,LaserAng_Set6,LaserAng_Set7,LaserAng_Set8,LaserAng_Set9,LaserAng_Set10];
Range_Set = [Range_Set1,Range_Set2,Range_Set3,Range_Set4,Range_Set5,Range_Set6,Range_Set7,Range_Set8,Range_Set9,Range_Set10];
Intensidade_Set = [Intensidade_Set1,Intensidade_Set2,Intensidade_Set3,Intensidade_Set4,Intensidade_Set5,Intensidade_Set6,Intensidade_Set7,Intensidade_Set8,Intensidade_Set9,Intensidade_Set10];

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

figure ('name','Histograma distâncias medidas')
histogram(Range);
title('Histograma distâncias medidas')
xlabel('Distância medida (cm)') 
ylabel('Nº de leituras') 

figure ('name','Histograma tempo aquisição de dados')
title('Histograma \Deltat aquisição de dados')
hold on;
histogram(dt);
xlabel('Tempo (ms)') 
ylabel('Nº de leituras') 

figure('name','Representação 2D do cenário')
title('Representação 2D do cenário')
hold on;
plot(-Lx,Ly,'.','Color','#0072BD')
scatter(0, 0,'+', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
title('Representação 2D do cenário')
xlabel('Distância em x (cm)') 
ylabel('Distância em y (cm)') 

figure('name','Representação 2D do cenário (valores médios)')
hold on;
plot(-mean(Lx_set,2),mean(Ly_set,2),'.','Color','#0072BD')
scatter(0, 0,'+', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
title('Representação 2D do cenário (valores médios)')
xlabel('Distância em x (cm)') 
ylabel('Distância em y (cm)') 

% Ranges no scan
figure('name','Dados adquiridos (distância para cada ângulo)')
plot(thetas_deg,Range','.','Color','#A2142F')
title('Dados adquiridos (distância para cada ângulo)')
xlabel('Angulo (º)') 
ylabel('Distância (cm)') 

figure('name','Média dados adquiridos (distância para cada ângulo)')
plot(thetas_deg_set,mean(Range_Set,2),'.','Color','#A2142F')
title('Média dados adquiridos (distância para cada ângulo)')
xlabel('Ângulo (º)') 
ylabel('Distância (cm)') 

% Ranges standard deviation
figure ('name','Gráfico Evolutivo do Desvio Padrão')
plot(thetas_deg_set(1:171,1:end),std(Range_Set(1:171,1:end),[],2),'Color','#EDB120')
title('Gráfico Evolutivo do Desvio Padrão')
xlabel('Ângulo (º)') 
ylabel('Desvio padrão da medição (cm)') 


% Intensidades
figure('name','Dados adquiridos (intensidade para cada ângulo)')
plot(thetas_deg,Intensidade','.','Color','#D95319')
title('Dados adquiridos (intensidade para cada ângulo)')
xlabel('Angulo (º)') 
ylabel('Intensidade (u.m.)') 




