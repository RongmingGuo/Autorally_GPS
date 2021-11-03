function [XYZ] = LLAtoXYZ (LLA)

    lat = LLA(1); % degrees
    lon = LLA(2); % degrees
    rou = LLA(3) + 6378137; % meters, earth sea level radius = 6378137m
    XYZ = [rou * cosd(lat) * cosd(lon), rou * cosd(lat) * sind(lon), rou * sind(lat)];

end