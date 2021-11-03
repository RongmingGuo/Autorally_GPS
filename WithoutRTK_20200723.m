%% Read the File
fileName = "robust_9_alpha_autorally0_2020-07-23-14-49-29_0-gpsRoverStatus";

fileName = fileName + ".txt";
fid = fopen(fileName);
Data = [];

% Extract Read
theLine = fgetl(fid);
while (isempty(theLine) == 0)
    rowData = [];
    ColData = split(theLine, ',');
    ColData = ColData(([1, 7 : (end - 1)]), :); % Extracting Only Time, LLA and Covariance Data
    
    for i = 1 : length(ColData)
        rowData = [rowData, str2num(ColData{i})];
    end
    
    Data = [Data; rowData];
    theLine = fgetl(fid);
end

fclose(fid);


%% Plotting 
%3D Plot Trajectory without Covariance

%Method 1 Transform LLA to XYZ
PosiData_LLA = Data(:, 2:4); % lat, lon, alt
PosiData_XYZ = [];
[M, ~] = size(PosiData_LLA);
for i = 1 : M
    PosiData_XYZ = [PosiData_XYZ; LLAtoXYZ(PosiData_LLA(i, :))];
end

% Making The Starting Point as the reference (0, 0, 0)
ref_p = PosiData_XYZ(1, :);
PosiData_XYZ = PosiData_XYZ - ref_p;

% Using The ProjPlane Algorithm to Account for Angle Offsets
normalVec = ref_p / norm(ref_p);
PosiData_XYZ_c = [];
for i = 1 : M
    i
    rowData = (projPlane(ref_p', normalVec', PosiData_XYZ(i, :)'))';
    PosiData_XYZ_c = [PosiData_XYZ_c; rowData];
end

ref_z = PosiData_XYZ_c(1, 3);
PosiData_XYZ_c(:, 3) =  PosiData_XYZ_c(:, 3) - ref_z;

% Embed Time into Discussion
PosiData_XYZ_c = [Data(:, 1), PosiData_XYZ_c]; % Time(absolute), X(rela), Y(rela), Z(rela)

% Get rid of error point
[~, id] = min(PosiData_XYZ_c(:, 2));
PosiData_XYZ_c(id, :) = [];

%% Plotting
figure(1)
plot3(PosiData_XYZ_c(:, 2), PosiData_XYZ_c(:, 3), PosiData_XYZ_c(:, 4), 'b');
grid on
xlabel('x')
ylabel('y')
zlabel('height')

%% Kinematic Analysis
% Speed Analysis
V_vec = diff(PosiData_XYZ_c(:, 2:3)) ./ (diff(PosiData_XYZ_c(:, 1)) / 10^9); % Time Measured in nm
V_t = [];
[M, ~] = size(V_vec);
for i = 1 : M
    v = norm(V_vec(i, :));
    V_t = [V_t; v];
end
time_Exact = PosiData_XYZ_c(1 : end-1, 1) / (10^9);
time_Processed = (PosiData_XYZ_c(1 : end-1, 1) - PosiData_XYZ_c(1, 1)) / 10^9;
V_t = [time_Exact, time_Processed, V_t];

figure(4)
plot(V_t(:, 1), V_t(:, 3), 'r'); %Exact Time Versus Speed
grid on
title('Speed of Vehicle versus Time & Identifying Clock Jump')
xlabel('GPS Exact Time, in seconds')
ylabel('Vehicle XY-plane speed, in m/s')

% Highlight Around Jumps
[~, index] = sort(V_t(:, 3), 'descend');
t1_id = index(1);
t2_id = index(2);

id_Range1 = [t1_id - 50 : t1_id + 50];
id_Range2 = [t2_id - 50 : t2_id + 50];

% Highlight Positions Around These Jumping Points
JumpingAround1 = PosiData_XYZ_c(id_Range1, :);
JumpingAround2 = PosiData_XYZ_c(id_Range2, :);
figure(1);
hold on
plot3(JumpingAround1(:, 2), JumpingAround1(:, 3), JumpingAround1(:, 4), 'r', 'LineWidth', 3);
plot3(JumpingAround2(:, 2), JumpingAround2(:, 3), JumpingAround2(:, 4), 'r', 'LineWidth', 3);
plot3(PosiData_XYZ_c(t2_id, 2), PosiData_XYZ_c(t2_id, 3), PosiData_XYZ_c(t2_id, 4), 'y.', "MarkerSize", 24);





