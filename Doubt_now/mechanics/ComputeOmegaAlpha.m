function [pqr, alpha] = ComputeOmegaAlpha(time,roll,pitch,yaw,fc)

if nargin<5
    fc = 5;
end

fs = 1/(time(2,1)-time(1,1));
[b,a]=butter(2,fc/(fs/2),'low');

% Filtering to suppress the step in the signals
roll_filt = filtfilt(b,a,roll);
pitch_filt = filtfilt(b,a,pitch);
yaw_filt = filtfilt(b,a,yaw);



for ii = 2:(size(time,1)-1) % 2nd order finite derivative
    phiP(ii,1) = (roll_filt(ii+1,1)-roll_filt(ii-1,1))/(2*(time(ii,1)-time(ii-1,1)));
    thetaP(ii,1) = (pitch_filt(ii+1,1)-pitch_filt(ii-1,1))/(2*(time(ii,1)-time(ii-1,1)));
    psiP(ii,1) = (yaw_filt(ii+1,1)-yaw_filt(ii-1,1))/(2*(time(ii,1)-time(ii-1,1)));
end
phiP(ii+1,1) = phiP(ii,1);
phiP(1,1) = phiP(2,1);
thetaP(ii+1,1) = thetaP(ii,1);
thetaP(1,1) = thetaP(2,1);
psiP(ii+1,1) = psiP(ii,1);
psiP(1,1) = psiP(2,1);

% Filtering angular rate
phiP = filtfilt(b,a,phiP);
thetaP = filtfilt(b,a,thetaP);
psiP = filtfilt(b,a,psiP);

for ii = 1:size(time,1)
    TRPYpqr = [1 0 -sin(pitch_filt(ii,1)); ...
        0 cos(roll_filt(ii,1)) sin(roll_filt(ii,1))*cos(pitch_filt(ii,1)); ...
        0 -sin(roll_filt(ii,1)) cos(roll_filt(ii,1))*cos(pitch_filt(ii,1))];
    pqr(:,ii) = TRPYpqr*[phiP(ii,1) thetaP(ii,1) psiP(ii,1)]';
end

for ii = 2:(size(time,1)-1) % 2nd order finite derivative
    alpha(ii,1) = ((pqr(2,ii+1)-pqr(2,ii-1))/(2*(time(ii,1)-time(ii-1,1))));
end
alpha(ii+1,1) = alpha(ii,1);
alpha(1,1) = alpha(2,1);
alpha = filtfilt(b,a,alpha);

end