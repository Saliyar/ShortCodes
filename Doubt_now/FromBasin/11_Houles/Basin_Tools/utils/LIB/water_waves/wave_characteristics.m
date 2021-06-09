function [omega, k, velocities] = wave_characteristics(freq, h)
if ( nargout < 1 )
	 angular_freq  = 2.0 * pi * freq
elseif ( nargout == 1 )
    omega          = 2.0 * pi * freq;
elseif ( nargout == 2 )
	omega          = 2.0 * pi * freq;
    n_row = size(freq,1);
    if n_row == 1
    	k(1,:)         = wave_number(freq, h);
	    k(2,:)         = wave_number(2.0 * freq, h);
    else
    	k(:,1)         = wave_number(freq, h);
	    k(:,2)         = wave_number(2.0 * freq, h);
    end
else 
	omega          = 2.0 * pi * freq;
    n_row = size(freq,1);
    if n_row == 1
    	k(1,:)         = wave_number(freq, h);
	    k(2,:)         = wave_number(2.0 * freq, h);
    	velocities(1,:)  = phase_velocity(freq, k(1,:));
        velocities(2,:)  = group_velocity(freq, k(1,:), h);
        velocities(3,:)  = phase_velocity(2.0 * freq, k(2,:));
        velocities(4,:)  = group_velocity(2.0 * freq, k(2,:), h);
    else
    	k(:,1)         = wave_number(freq, h);
	    k(:,2)         = wave_number(2.0 * freq, h);
        velocities(:,1)  = phase_velocity(freq, k(:,1));
        velocities(:,2)  = group_velocity(freq, k(:,1), h);
        velocities(:,3)  = phase_velocity(2.0 * freq, k(:,2));
        velocities(:,4)  = group_velocity(2.0 * freq, k(:,2), h);
    end
end;
%