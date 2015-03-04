function [signal_strength, signal_interference, connected_index] = findUserInfo( ...
    mobile_location, cell_centers, cell_nums, tier_nums, cell_radius, ...
    ref_dist, ref_power, beta, shadow_variance,lambda)

findInterferingCells = 0; % 0 means no anything else means yes
equation = 1; % 0 means friisFreeSpace  --  1 means pathLossModel
% 2 means the antenna one

% finds the serving cell for the single user that is being presented
[connected_cn, connected_tn, connected_cp] = findServingCell( ...
    mobile_location, cell_centers, cell_nums, tier_nums );

 drawCell( connected_cp, cell_radius, '', 'g' );


% Draw the mobile user at the appropriate location
plot( mobile_location, '*', 'Color', 'k' );

% Draw a line connecting the center (basestation) of the serving cell
%    and the mobile user
line( [real(connected_cp) real(mobile_location)], ...
    [imag(connected_cp) imag(mobile_location)], ...
    'Color', 'g' );

    signal_strength = pathLossModel(ref_dist, ref_power, beta, shadow_variance, ...
        abs(mobile_location-connected_cp)); % in watts

signal_interference = 0;

if (findInterferingCells ~= 0)
    indicies = find( cell_nums == connected_cn );
    for a=indicies
        if(tier_nums(a) ~= connected_tn)
            drawCell( cell_centers(a), cell_radius, '', 'r' );
            line( [real(cell_centers(a)) real(mobile_location)], ...
                [imag(cell_centers(a)) imag(mobile_location)], ...
                'Color', 'r' );
            
            if (equation == 1)
                signal_interference = pathLossModel(ref_dist, ref_power, ...
                    beta, shadow_variance, abs(mobile_location-connected_cp));
            else
                signal_interference = friisFreeSpace( ...
                    abs(mobile_location-cell_centers(a)));
            end;
            
        end;
    end;
end;

connected_index = find(cell_nums == connected_cn & tier_nums == connected_tn);