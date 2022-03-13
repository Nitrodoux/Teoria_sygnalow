load
%1.1 Przebieg czasowy zarejestrowanego sygna³u
N=30720; %liczba próbek
fp=22050; %czêstotiwoœæ próbkowania
dt=1/fp; %obliczenie kolejnego kroku
y=Jakub_Baczyk; %zapisanie sygna³u do zmiennej
t=0:1/22050:30719/22050; %ustalenie wektora czasu
figure(1)
plot(t,y); %wykres przebiegu czasowego sygna³u
title('Przebieg czasowy zarejestrowanego sygna³u (Jakub)');
xlabel('czas [s]')
ylabel('y [-]')
grid on;


%2. Podstawowe parametry sygna³ów
%Wartoœæ œrednia
y_srednia=mean(y)
%Wartoœæ maksymalna
y_max=max(y)
%Wartoœæ minimalna
y_min=min(y)
%Odchylenie standardowe
y_std=std(y)
%Energia
y_eng=dt*sum(y.^2) 
%Moc œrednia
y_moc=(1/N)*sum(y.^2) 
%Wartoœæ skuteczna
y_skut=sqrt(y_moc) 

%3. Obliczenie i narysowanie funkcji autokorelacji i autokowariancji
%Autokorelacja
R1=xcorr(y,'biased'); %unormowana przez d³ugoœæ
tR=[-fliplr(t) t(2:N)]; %uporz¹dkowanie szyku od lewej do prawej
figure(2)
plot(tR,R1);
title('Funkcja autokorelacji')
xlabel('przesuniêcie w czasie (s)')
ylabel('wartoœæ')
grid on;
%Autokowariancja
C=xcov(y);
figure(3);
plot(tR,C)
title('Funkcja autokowariancji')
xlabel('przesuniêcie w czasie (s)')
ylabel('wartoœæ');
grid on;

%4. Widmo amplitudowe sygna³u i jego periodogram
y_fft=fft(y); %obliczenie szybkiej tansformaty Fouriera
N=length(y_fft); %zliczenie iloœci próbek na podstawie fft
i=0:1:(N-1); %skalowanie osi czêstotliwoœci
fi=((i/N)*fp); %skalowanie osi czêstotliwoœci
%Wykres widma amplitudowego
figure(4);
plot(fi,(2/N)*abs(y_fft)); 
title('Widmo amplitudowe sygna³u')
xlabel('f [Hz]');
ylabel('abs (Ay)');
grid on;

%Gêstoœæ widmowa mocy
figure(5)
h=spectrum.welch;
psd(h,y,'Fs',fp);
%Wygenerowania gêstoœi widmowej mocy z 98% przedzia³em ufnoœci
hpsd=psd(h,y,'ConfLevel',.98);
figure(6)
plot(hpsd)
figure(7)
Hs=spectrum.periodogram;
psd(Hs,y,'Fs',fp);%wykres gêstoœci widmowej mocy


%5. Zaprojektowanie filtru dolnoprzepustowego
%Czêstotliowœc odciêcia filtru
fd=2800;
%Czêstotliwoœæ zaporowa
fz=2500;
%Rz¹d filtru z oknem czasowym Hamminga
N=round((fp/(fd-fz))*3.1);
wn=fd/(fp/2);
%Filtr dolnoprzepustowy z oknem czasowym Hamminga
filtr=fir1(N,wn,'low');
%odpowiedŸ czêstotliwoœciowa cyfrowego filtru
%A- odpowiedŸ filtru, f- czestotliwoœæ w Hz
[A,f]=freqz(filtr,1,10000,fp);
figure(8)
plot(f,20*log(A)); %charakterystyka amplitudowa logarytmiczna
title('Charakterystyka amplitudowa logarytmiczna')
xlabel('f [Hz]');
ylabel('20*log(A) [dB]');
grid on;
%Filtracja sygna³u
yf=filter2(filtr,y); %filtracja zadanego sygna³u
figure(9)
plot(t,y,'b',t,yf,'r');%wykres sygna³u przed i po filtracji
title('Wykres sygna³u przed i po filtracji')
legend('Sygna³ przed filtracj¹','Sygna³ po filtracji')
xlabel('czas [s]');
ylabel('y [-]');
grid on;

%6. Przedstaw widmo amplitudowe sygna³u przed filtracj¹ oraz po filtracji
yft=fft(yf); %fft sygna³u po filtracji
N=length(y_fft); 
i=0:1:(N-1);
fi=((i/N)*fp);
figure(10)
plot(fi,abs(y_fft),'b',fi,abs(yft),'r') %przedstawienie widma sygna³u
%zadanego i widma sygna³u przefiltrowanego
title('Widmo sygna³u zadanego i widmo sygna³u przefiltrowanego')
xlabel('f [Hz]')
ylabel('abs (Ay)')
legend('Widmo sygna³u zadanego','Widmo sygna³u przefiltrowanego')
grid on

save


