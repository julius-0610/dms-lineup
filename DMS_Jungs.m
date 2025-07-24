clear
close

% Generelle Daten zu Veranstaltung und Team

nswimmer = xlsread("DMS_ohneMiron.xlsx","Zuordnungen","B1","basic");
nevents = xlsread("DMS_ohneMiron.xlsx","Zuordnungen","B2","basic");
maxNumStarts = xlsread("DMS_ohneMiron.xlsx","Zuordnungen","B3","basic");
index_1500 = xlsread("DMS_ohneMiron.xlsx","Zuordnungen","B4","basic");
dim_x = nswimmer * nevents;


%intlinprog Parameters

intcon = zeros(dim_x,1);
for k = 1:size(intcon)
    intcon(k) = k;
end;

LB = zeros(dim_x,1);
UB = ones(dim_x,1);




% Einlesen der Schwimmerpunkte. Zuordnung siehe Excel

c_s1 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","B2:B18","basic");
c_s2 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","C2:C18","basic");
c_s3 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","D2:D18","basic");
c_s4 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","E2:E18","basic");
c_s5 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","F2:F18","basic");
c_s6 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","G2:G18","basic");
c_s7 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","H2:H18","basic");
c_s8 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","I2:I18","basic");
c_s9 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","J2:J18","basic");
c_s10 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","K2:K18","basic");
c_s11 = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","L2:L18","basic");


% Punkte in DMS Format bringen

c_s1 = [c_s1;c_s1];
c_s1(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","B20","basic");

c_s2 = [c_s2;c_s2];
c_s2(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","C20","basic");

c_s3 = [c_s3;c_s3];
c_s3(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","D20","basic");

c_s4 = [c_s4;c_s4];
c_s4(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","E20","basic");

c_s5 = [c_s5;c_s5];
c_s5(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","F20","basic");

c_s6 = [c_s6;c_s6];
c_s6(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","G20","basic");

c_s7 = [c_s7;c_s7];
c_s7(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","H20","basic");

c_s8 = [c_s8;c_s8];
c_s8(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","I20","basic");

c_s9 = [c_s9;c_s9];
c_s9(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","J20","basic");

c_s10 = [c_s10;c_s10];
c_s10(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","K20","basic");

c_s11 = [c_s11;c_s11];
c_s11(index_1500) = xlsread("DMS_ohneMiron.xlsx","Punktetabelle","L20","basic");


% Speichern der Daten in einem großen Vektor: Objective function

c = [c_s1;c_s2;c_s3;c_s4;c_s5;c_s6;c_s7;c_s8;c_s9;c_s10;c_s11];
c = -c;


% Bedingung 1: Maximale Anzahl an Starts pro Schwimmer

A1 = zeros(nswimmer,dim_x);
for imax=1:nswimmer
    for jmax=1 : index_1500-1
        A1(imax,(imax-1) * nevents + jmax) = 1;
    end
    A1(imax,(imax-1)*nevents + index_1500) = 3;
    for jmax=index_1500+1 : nevents/2 + index_1500 - 1
        A1(imax,(imax-1) * nevents + jmax) = 1;
    end
    A1(imax, (imax-1)*nevents + nevents/2 + index_1500) = 2;
    for jmax= nevents/2 + index_1500 +1 : nevents 
        A1(imax,(imax-1) * nevents + jmax) = 1;
    end
end

b1 = maxNumStarts * ones(nswimmer,1);


% Bedingung 2: Zwischen den Starts soll man genug Pause haben

A2_s1 = zeros(nevents/2);

A2_s1(1,1:4) = 1;                        %100L --> 100S
A2_s1(2,2:6) = 1;                        %200F --> 200L
A2_s1(3,3:7) = 1;                        %100B --> 1500F
A2_s1(4,4:7) = 1;                        %200R --> 1500F
A2_s1(5,5:8) = 1;                        %100S --> 50S
A2_s1(6,6:8) = 1;                        %50B  --> 50S
A2_s1(7,7:9) = 1;                        %200L --> 200B
A2_s1(8,8:12) = 1;                       %1500F--> x
A2_s1(:,index_1500) = 1;
A2_s1(9,9:12) = 1;                       %50S  --> 50F
A2_s1(10,10:14) = 1;                     %200B --> 50R
A2_s1(11,11:14) = 1;                     %100R --> 50R
A2_s1(12,12:15) = 1;                     %200S --> 400F
A2_s1(13,13:15) = 1;                     %50F  --> 400F
A2_s1(14,14:16) = 1;                     %400L --> 100F
A2_s1(15,15:17) = 1;                     %50R  --> x
A2_s1(16,16:17) = 1;                     %400F --> x
A2_s1(17,17)    = 1;                     %100F --> x


A2_s2 = zeros(nevents/2);

A2_s2(1,1:4) = 1;                        %100L --> 100S
A2_s2(2,2:6) = 1;                        %200F --> 200L
A2_s2(3,3:7) = 1;                        %100B --> 800F
A2_s2(4,4:7) = 1;                        %200R --> 800F
A2_s2(5,5:8) = 1;                        %100S --> 50S
A2_s2(6,6:8) = 1;                        %50B  --> 50S
A2_s2(7,7:9) = 1;                        %200L --> 200B
A2_s2(8,8:12) = 1;                       %800F --> 50F
A2_s2(9,9:12) = 1;                       %50S  --> 50F
A2_s2(10,10:14) = 1;                     %200B --> 50R
A2_s2(11,11:14) = 1;                     %100R --> 50R
A2_s2(12,12:15) = 1;                     %200S --> 400F
A2_s2(13,13:15) = 1;                     %50F  --> 400F
A2_s2(14,14:16) = 1;                     %400L --> 100F
A2_s2(15,15:17) = 1;                     %50R  --> x
A2_s2(16,16:17) = 1;                     %400F --> x
A2_s2(17,17)    = 1;                     %100F --> x

A2_s = blkdiag(A2_s1,A2_s2);

A2 = [];

for k2 = 1:nswimmer
    A2 = blkdiag(A2,A2_s);
end

b2 = ones(dim_x,1);

% Bedingung 3: Die gleiche Strecke darf nicht 2x geschwommen werden

A3_s = eye(nevents/2,nevents/2);
A3_s(index_1500,:)=[];
A3_s = [A3_s,A3_s];

A3 = [];

for k3 = 1:nswimmer
    A3 = blkdiag(A3,A3_s);
end

b3 = ones(nswimmer * (nevents/2-1),1);


% Bedingung 4: Jeder muss mind. einen Start haben?

A4 = zeros(nswimmer,dim_x);
for imin=1:nswimmer
    for jmin=1:nevents
        A4(imin,(imin-1) * nevents + jmin) = -1;
    end
end

b4 = -1 * ones(nswimmer,1);

%A4 = [];
%b4 = [];

A5 = zeros(2*nswimmer,dim_x);
for iabs = 1:2*nswimmer
    for jabs = 1:nevents/2
        A5(iabs,(iabs-1) * nevents/2 + jabs) = 1;
    end
end

b5 = 3 * ones(2*nswimmer,1);





A = [A1;A2;A3;A4;A5];
b = [b1;b2;b3;b4;b5];

% Bedingung 5: Jede Strecke muss genau einmal belegt sein

Aeq_s = eye(nevents);

Aeq = [];

for keq = 1:nswimmer
    Aeq = [Aeq,Aeq_s];
end

beq = ones(nevents,1);




[x,points] = intlinprog(c,intcon,A,b,Aeq,beq,LB,UB);

x = c.*x;

x1 = sparse(x(1 : nevents))
x2 = sparse(x(nevents+1 : 2*nevents))
x3 = sparse(x(2*nevents+1 : 3*nevents))
x4 = sparse(x(3*nevents+1 : 4*nevents))
x5 = sparse(x(4*nevents+1 : 5*nevents))
x6 = sparse(x(5*nevents+1 : 6*nevents))
x7 = sparse(x(6*nevents+1 : 7*nevents))
x8 = sparse(x(7*nevents+1 : 8*nevents))
x9 = sparse(x(8*nevents+1 : 9*nevents))

points




