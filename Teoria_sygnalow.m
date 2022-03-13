load
%1.1 Przebieg czasowy zarejestrowanego sygna�u
N=30720; %liczba pr�bek
fp=22050; %cz�stotiwo�� pr�bkowania
dt=1/fp; %obliczenie kolejnego kroku
y=Jakub_Baczyk; %zapisanie sygna�u do zmiennej
t=0:1/22050:30719/22050; %ustalenie wektora czasu
figure(1)
plot(t,y); %wykres przebiegu czasowego sygna�u
title('Przebieg czasowy zarejestrowanego sygna�u (Jakub)');
xlabel('czas [s]')
ylabel('y [-]')
grid on;


%2. Podstawowe parametry sygna��w
%Warto�� �rednia
y_srednia=mean(y)
%Warto�� maksymalna
y_max=max(y)
%Warto�� minimalna
y_min=min(y)
%Odchylenie standardowe
y_std=std(y)
%Energia
y_eng=dt*sum(y.^2) 
%Moc �rednia
y_moc=(1/N)*sum(y.^2) 
%Warto�� skuteczna
y_skut=sqrt(y_moc) 

%3. Obliczenie i narysowanie funkcji autokorelacji i autokowariancji
%Autokorelacja
R1=xcorr(y,'biased'); %unormowana przez d�ugo��
tR=[-fliplr(t) t(2:N)]; %uporz�dkowanie szyku od lewej do prawej
figure(2)
plot(tR,R1);
title('Funkcja autokorelacji')
xlabel('przesuni�cie w czasie (s)')
ylabel('warto��')
grid on;
%Autokowariancja
C=xcov(y);
figure(3);
plot(tR,C)
title('Funkcja autokowariancji')
xlabel('przesuni�cie w czasie (s)')
ylabel('warto��');
grid on;

%4. Widmo amplitudowe sygna�u i jego periodogram
y_fft=fft(y); %obliczenie szybkiej tansformaty Fouriera
N=length(y_fft); %zliczenie ilo�ci pr�bek na podstawie fft
i=0:1:(N-1); %skalowanie osi cz�stotliwo�ci
fi=((i/N)*fp); %skalowanie osi cz�stotliwo�ci
%Wykres widma amplitudowego
figure(4);
plot(fi,(2/N)*abs(y_fft)); 
title('Widmo amplitudowe sygna�u')
xlabel('f [Hz]');
ylabel('abs (Ay)');
grid on;

%G�sto�� widmowa mocy
figure(5)
h=spectrum.welch;
psd(h,y,'Fs',fp);
%Wygenerowania g�sto�i widmowej mocy z 98% przedzia�em ufno�ci
hpsd=psd(h,y,'ConfLevel',.98);
figure(6)
plot(hpsd)
figure(7)
Hs=spectrum.periodogram;
psd(Hs,y,'Fs',fp);%wykres g�sto�ci widmowej mocy


%5. Zaprojektowanie filtru dolnoprzepustowego
%Cz�stotliow�c odci�cia filtru
fd=2800;
%Cz�stotliwo�� zaporowa
fz=2500;
%Rz�d filtru z oknem czasowym Hamminga
N=round((fp/(fd-fz))*3.1);
wn=fd/(fp/2);
%Filtr dolnoprzepustowy z oknem czasowym Hamminga
filtr=fir1(N,wn,'low');
%odpowied� cz�stotliwo�ciowa cyfrowego filtru
%A- odpowied� filtru, f- czestotliwo�� w Hz
[A,f]=freqz(filtr,1,10000,fp);
figure(8)
plot(f,20*log(A)); %charakterystyka amplitudowa logarytmiczna
title('Charakterystyka amplitudowa logarytmiczna')
xlabel('f [Hz]');
ylabel('20*log(A) [dB]');
grid on;
%Filtracja sygna�u
yf=filter2(filtr,y); %filtracja zadanego sygna�u
figure(9)
plot(t,y,'b',t,yf,'r');%wykres sygna�u przed i po filtracji
title('Wykres sygna�u przed i po filtracji')
legend('Sygna� przed filtracj�','Sygna� po filtracji')
xlabel('czas [s]');
ylabel('y [-]');
grid on;

%6. Przedstaw widmo amplitudowe sygna�u przed filtracj� oraz po filtracji
yft=fft(yf); %fft sygna�u po filtracji
N=length(y_fft); 
i=0:1:(N-1);
fi=((i/N)*fp);
figure(10)
plot(fi,abs(y_fft),'b',fi,abs(yft),'r') %przedstawienie widma sygna�u
%zadanego i widma sygna�u przefiltrowanego
title('Widmo sygna�u zadanego i widmo sygna�u przefiltrowanego')
xlabel('f [Hz]')
ylabel('abs (Ay)')
legend('Widmo sygna�u zadanego','Widmo sygna�u przefiltrowanego')
grid on

save


